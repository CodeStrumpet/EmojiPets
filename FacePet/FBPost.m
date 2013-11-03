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

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    _numLikes = [aDecoder decodeIntegerForKey:@"numLikes"];
    _numComments = [aDecoder decodeIntegerForKey:@"numComments"];

    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeInteger:_numLikes forKey:@"numLikes"];
    [aCoder encodeInteger:_numComments forKey:@"numComments"];
}

@end