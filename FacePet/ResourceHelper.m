//
//  ResourceHelper.m
//  FacePet
//
//  Created by Paul Mans on 11/5/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import "ResourceHelper.h"

@implementation ResourceHelper

static NSArray *petFaces;

+ (void) initialize {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"pet_faces" ofType:@"json"];
    
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    NSError *jsonError;
    petFaces = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
    
    NSLog(@"NumPetFaces: %d", petFaces.count);
    
}


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

+ (NSDictionary *)petFaceForFaceSetNum:(int)faceSetNum hungerLevel:(int)hungerLevel andExcitementLevel:(int)excitement {
    
    if (faceSetNum >= [petFaces count]) {
        NSLog(@"FaceSetNum out of range");
        return nil;
    }

    NSArray *faceSet = [petFaces objectAtIndex:faceSetNum];
    if (hungerLevel >= [faceSet count]) {
        NSLog(@"Hunger level out of range");
        return nil;
    }
    
    NSArray *hungerSet = [faceSet objectAtIndex:hungerLevel];
    if (excitement >= [hungerSet count]) {
        NSLog(@"ExcitementLevel out of range");
        return nil;
    }
    
    NSDictionary *petFace = [hungerSet objectAtIndex:excitement];
    
    return petFace;
}

@end
