//
//  ResourceHelper.m
//  FacePet
//
//  Created by Paul Mans on 11/5/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import "ResourceHelper.h"

@implementation ResourceHelper

+ (UIImage *)petFrameImageForPetType:(PetType)petType {
    NSString *resourceName = @"";
    switch (petType) {
        case PetTypeNone:
            resourceName = @"choose_your_pet_gradient";
            break;
        case PetTypeBear:
            resourceName = @"BEAR_cropped";
            break;
        case PetTypeElephant:
            resourceName = @"ELEPHANT_cropped";
            break;
        case PetTypeFox:
            resourceName = @"FOX_cropped";
        default:
            break;
    }
    return [UIImage imageNamed:resourceName];
}
@end
