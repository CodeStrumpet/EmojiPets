//
//  FBDiff.h
//  FacePet
//
//  Created by Paul Mans on 11/2/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBDiff : NSObject

@property (nonatomic, assign) GraphCall graphCall;
@property (nonatomic, assign) int newPosts;
@property (nonatomic, assign) int newLikes;
@property (nonatomic, assign) int newComments;

@end
