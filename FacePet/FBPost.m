//
//  FBPost.m
//  FacePet
//
//  Created by Paul Mans on 11/2/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import "FBPost.h"

@implementation FBPost

- (id)init {
    if ((self = [super init])) {
        _numLikes = 0;
        _numComments = 0;
    }
    return self;
}

@end