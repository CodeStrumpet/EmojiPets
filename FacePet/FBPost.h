//
//  FBPost.h
//  FacePet
//
//  Created by Paul Mans on 11/2/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBPost : NSObject <NSCoding>

@property (nonatomic, assign) int numLikes;
@property (nonatomic, assign) int numComments;

@end
