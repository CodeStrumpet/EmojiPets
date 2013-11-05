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

+ (PetType)petType {
    return [[NSUserDefaults standardUserDefaults] integerForKey:PET_TYPE_KEY];
}

+ (void)setPetType:(PetType)type {
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:PET_TYPE_KEY];
}

@end
