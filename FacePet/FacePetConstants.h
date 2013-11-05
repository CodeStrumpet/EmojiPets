//
//  FacePetConstants.h
//  FacePet
//
//  Created by Paul Mans on 11/2/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#ifndef FacePet_FacePetConstants_h
#define FacePet_FacePetConstants_h

#define GRAPH_UPDATE_NOTIFICATION @"GRAPH_UPDATE_NOTIFICATION"
#define WATCH_CONNECTED_NOTIFICATION @"WATCH_CONNECTED_NOTIFICATION"
#define WATCH_DISCONNECTED_NOTIFICATION @"WATCH_DISCONNECTED_NOTIFICATION"
#define PET_TYPE_CHANGED_NOTIFICATION @"PET_TYPE_CHANGED"

#define FB_DIFF_KEY @"FB_DIFF"


typedef enum GraphCall {
    GraphCallNone = 0,
    GraphCallHome,
    GraphCallFeed,
    GraphCallStatuses
} GraphCall;


typedef enum PetType {
    PetTypeNone = 0,
    PetTypeBear,
    PetTypeFox,
    PetTypeElephant
} PetType;

#endif
