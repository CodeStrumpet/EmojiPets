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

@end
