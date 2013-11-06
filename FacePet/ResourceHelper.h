//
//  ResourceHelper.h
//  FacePet
//
//  Created by Paul Mans on 11/5/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceHelper : NSObject

+ (UIImage *)petFrameImageForPetType:(PetType)petType;

+ (UIImage *)petFaceForFaceSet:(int)faceSet hungerLevel:(int)hungerLevel andExcitementLevel:(int)excitement;

@end
