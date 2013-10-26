//
//  FBGraphConnection.m
//  SocialWear
//
//  Created by Paul Mans on 10/26/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import "FBGraphConnection.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FBGraphStore.h"

@implementation FBGraphConnection

- (void)updateGraphStore:(FBGraphStore *)graphStore withCall:(GraphCall)graphCall {
    
    NSString *OGMethod;
    if (graphCall == GraphCallHome) {
        OGMethod = @"me/home";
    } else if (graphCall == GraphCallStatuses) {
        OGMethod = @"me/statuses";
    } else {
        OGMethod = @"me/feed";
    }
    
    FBRequest * rq = [FBRequest requestWithGraphPath:OGMethod
                                          parameters:nil
                                          HTTPMethod:@"GET"];
    [rq startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result;
            [graphStore updateWithGraphResults:userData graphCall:graphCall];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

@end
