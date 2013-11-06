//
//  FBDiff.m
//  FacePet
//
//  Created by Paul Mans on 11/2/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import "FBDiff.h"

@implementation FBDiff

- (id)init {
    if ((self = [super init])) {
        _newPosts = 0;
        _newLikes = 0;
        _newComments = 0;
        _graphCall = GraphCallNone;
        _totalLikes = 0;
        _totalComments = 0;
        _totalPosts = 0;
    }
    return self;
}

@end
