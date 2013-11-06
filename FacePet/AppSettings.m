//
//  AppSettings.m
//  FacePet
//
//  Created by Paul Mans on 11/5/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import "AppSettings.h"

@implementation AppSettings

#define PET_TYPE_KEY @"PetType"
#define FACE_SET_NUM_KEY @"FaceSetNum"
#define PROFILE_IMAGE_DATA_KEY @"ProfileImageData"
#define USER_NAME_KEY @"UserName"
#define FACEBOOK_ID_KEY @"FacebookID"

+ (PetType)petType {
    return [[NSUserDefaults standardUserDefaults] integerForKey:PET_TYPE_KEY];
}

+ (void)setPetType:(PetType)type {
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:PET_TYPE_KEY];
}

+ (int)faceSetNum {
    return [[NSUserDefaults standardUserDefaults] integerForKey:FACE_SET_NUM_KEY];
}

+ (void)setFaceSetNum:(int)setNum {
    [[NSUserDefaults standardUserDefaults] setInteger:setNum forKey:FACE_SET_NUM_KEY];
}

+ (UIImage *)userProfileImage {
    NSData *imageData = [[NSUserDefaults standardUserDefaults] dataForKey:PROFILE_IMAGE_DATA_KEY];

    if (imageData) {
        return [UIImage imageWithData:imageData];
    } else {
        return [UIImage imageNamed:@"profile-picture"];
    }
    return nil;
}

+ (void)setUserProfileImageData:(NSData *)imageData {
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:PROFILE_IMAGE_DATA_KEY];
}

+ (NSString *)userName {
    return [[NSUserDefaults standardUserDefaults] stringForKey:USER_NAME_KEY];
}

+ (void)setUserName:(NSString *)userName {
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:USER_NAME_KEY];
}

+ (NSString *)facebookID {
    return [[NSUserDefaults standardUserDefaults] stringForKey:FACEBOOK_ID_KEY];
}

+ (void)setFacebookID:(NSString *)facebookID {
    [[NSUserDefaults standardUserDefaults] setObject:facebookID forKey:FACEBOOK_ID_KEY];
}


@end
