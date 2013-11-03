//
//  FBGraphStore.m
//  SocialWear
//
//  Created by Paul Mans on 10/26/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import "FBGraphStore.h"

@implementation FBGraphStore

- (void)updateWithGraphResults:(NSDictionary *)results graphCall:(GraphCall)graphCall {
    NSArray *data = [results objectForKey:@"data"];
    for (NSDictionary *feedItem in data) {
        NSLog(@"FeedItem: %@", feedItem);
        //NSLog(@"From: %@", [feedItem objectForKey:@"from"]);
    }
}

@end
