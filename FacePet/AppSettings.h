//
//  AppSettings.h
//  FacePet
//
//  Created by Paul Mans on 11/5/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettings : NSObject

+ (PetType)petType;
+ (void)setPetType:(PetType)type;
+ (int)faceSetNum;
+ (void)setFaceSetNum:(int)setNum;
+ (UIImage *)userProfileImage;
+ (void)setUserProfileImageData:(NSData *)imageData;
+ (NSString *)userName;
+ (void)setUserName:(NSString *)userName;
+ (NSString *)facebookID;
+ (void)setFacebookID:(NSString *)facebookID;

@end
