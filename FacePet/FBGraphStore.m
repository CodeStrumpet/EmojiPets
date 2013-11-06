//
//  FBGraphStore.m
//  SocialWear
//
//  Created by Paul Mans on 10/26/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import "FBGraphStore.h"
#import "FBPost.h"
#import "FBDiff.h"

@interface FBGraphStore ()

@property (nonatomic, strong) NSMutableDictionary *store;

@end

@implementation FBGraphStore

- (id)init {
    if ((self = [super init])) {
        
        // create reference date
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
        [components setHour:6];
        NSDate *today6am = [calendar dateFromComponents:components];
        self.referenceDate = today6am;
        
        _numPostsToday = 0;
        
        
        //_store = [NSKeyedUnarchiver unarchiveObjectWithFile:[self storeArchivePath]];
        if (!_store) {
            _store = [[NSMutableDictionary alloc] init];
        }
         
    }
    return self;
}

- (void)updateWithGraphResults:(NSDictionary *)results graphCall:(GraphCall)graphCall {
    
    FBDiff *diff = [FBDiff new];
    diff.graphCall = graphCall;
    
    NSArray *data = [results objectForKey:@"data"];
    for (NSDictionary *feedItem in data) {
        
        NSString *updatedTime = [feedItem objectForKey:@"updated_time"];
        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        //2010-12-01T21:35:43+0000
        //2011-10-28T18:51:25+0000
        [df setDateFormat:@"yyyy-MM-ddHH:mm:ssZZZZ"];
        
        NSDate *date = [df dateFromString:[updatedTime stringByReplacingOccurrencesOfString:@"T" withString:@""]];
        [df setDateFormat:@"eee MMM dd, yyyy hh:mm"];

        //NSString *dateStr = [df stringFromDate:date];
        
        // we disregard any posts that happened before our reference time...
        if ([date laterDate:_referenceDate] == _referenceDate) {
            continue;
        }
        
        
        NSString *itemID = [feedItem objectForKey:@"id"];
        NSRange underscoreRange = [itemID rangeOfString:@"_"];
        if (underscoreRange.location != NSNotFound) {
            itemID = [itemID substringFromIndex:underscoreRange.location];
        }
        
        FBPost *post = [self postForFeedItem:feedItem];
        FBPost *savedPost = [_store objectForKey:itemID];
        
        if (!savedPost) {
            _numPostsToday++;
            diff.newPosts++;
            diff.newLikes += post.numLikes;
            diff.newComments += post.numComments;
        } else {
            diff.newLikes += post.numLikes - savedPost.numLikes;
            diff.newComments += post.numComments - savedPost.numComments;
        }
        
        diff.totalPosts++;
        diff.totalLikes = post.numLikes;
        diff.totalComments = post.numComments;
        
        [_store setValue:post forKey:itemID];
    }
    
    diff.totalPosts = _numPostsToday;
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:diff forKey:FB_DIFF_KEY];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GRAPH_UPDATE_NOTIFICATION object:self userInfo:userInfo];
    
    //NSLog(@"newPosts: %d, newLikes: %d, newComments: %d", diff.newPosts, diff.newLikes, diff.newComments);
    
    // write the store to the file system
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self persistStoreToArchive];
        
        if (NO) {
            [self writeDictionaryAsJSON:results toFile:@"graphResults.json"];
        }
    });
    
}

- (FBPost *)postForFeedItem:(NSDictionary *)feedItem {
    FBPost *post = [FBPost new];
    NSDictionary *likesObj = [feedItem objectForKey:@"likes"];
    if (likesObj) {
        NSArray *likes = [likesObj objectForKey:@"data"];
        post.numLikes = [likes count];
    }
    NSDictionary *commentsObj = [feedItem objectForKey:@"comments"];
    if (commentsObj) {
        NSArray *comments = [commentsObj objectForKey:@"data"];
        post.numComments = [comments count];
    }
    return post;
}

- (BOOL)persistStoreToArchive {
    return [NSKeyedArchiver archiveRootObject:_store toFile:[self storeArchivePath]];
}

- (NSString *)storeArchivePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"graphStore"];
}

- (void)writeDictionaryAsJSON:(NSDictionary *)results toFile:(NSString *)fileName {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:results
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [paths objectAtIndex:0];
        NSString *documentDBFolderPath = [documentsDir stringByAppendingPathComponent:fileName];
        
        NSError *error;
        [jsonString writeToFile:documentDBFolderPath atomically:NO encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }

}

@end