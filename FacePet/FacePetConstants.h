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
#define FB_DIFF_KEY @"FB_DIFF"


typedef enum GraphCall {
    GraphCallNone = 0,
    GraphCallHome,
    GraphCallFeed,
    GraphCallStatuses
} GraphCall;

#endif
