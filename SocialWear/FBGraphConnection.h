//
//  FBGraphConnection.h
//  SocialWear
//
//  Created by Paul Mans on 10/26/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FBGraphStore;

typedef enum GraphCall {
    GraphCallHome,
    GraphCallFeed,
    GraphCallStatuses
} GraphCall;

@interface FBGraphConnection : NSObject

- (void)updateGraphStore:(FBGraphStore *)graphStore withCall:(GraphCall)graphCall;

@end
