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
        _store = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)updateWithGraphResults:(NSDictionary *)results graphCall:(GraphCall)graphCall {
    
    FBDiff *diff = [FBDiff new];
    diff.graphCall = graphCall;
    
    NSArray *data = [results objectForKey:@"data"];
    for (NSDictionary *feedItem in data) {
        
        NSString *itemID = [feedItem objectForKey:@"id"];
        NSRange underscoreRange = [itemID rangeOfString:@"_"];
        if (underscoreRange.location != NSNotFound) {
            itemID = [itemID substringFromIndex:underscoreRange.location];
        }
        
        FBPost *post = [self postForFeedItem:feedItem];
        FBPost *savedPost = [_store objectForKey:itemID];
        
        if (!savedPost) {
            diff.newPosts++;
            diff.newLikes += post.numLikes;
            diff.newComments += post.numComments;
        } else {
            diff.newLikes += post.numLikes - savedPost.numLikes;
            diff.newComments += post.numComments - savedPost.numComments;
        }
        
        [_store setValue:post forKey:itemID];
    }
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:diff forKey:FB_DIFF_KEY];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GRAPH_UPDATE_NOTIFICATION object:self userInfo:userInfo];
    
    NSLog(@"newPosts: %d, newLikes: %d, newComments: %d", diff.newPosts, diff.newLikes, diff.newComments);
    
    if (NO) {
        [self writeDictionaryAsJSON:results toFile:@"graphResults.json"];
    }
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
    }

}

@end