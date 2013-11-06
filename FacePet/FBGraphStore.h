//
//  FBGraphStore.h
//  SocialWear
//
//  Created by Paul Mans on 10/26/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBGraphConnection.h"


@interface FBGraphStore : NSObject

@property (strong, nonatomic) NSDate *referenceDate;
@property (assign, nonatomic) int numPostsToday;

- (void)updateWithGraphResults:(NSDictionary *)results graphCall:(GraphCall)graphCall;

@end


