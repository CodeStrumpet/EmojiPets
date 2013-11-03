//
//  FBGraphConnection.m
//  SocialWear
//
//  Created by Paul Mans on 10/26/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import "FBGraphConnection.h"
#import "AppDelegate.h"
#import "NetworkUtils.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FBGraphStore.h"
#import <RoutingHTTPServer/RoutingHTTPServer.h>

@implementation FBGraphConnection

- (void)listenForRealtimeUpdates {
    RoutingHTTPServer *http = [[AppDelegate instance] httpServer];
    
    [http get:@"/userUpdate" withBlock:^(RouteRequest *request, RouteResponse *response) {
        [response setHeader:@"Content-Type" value:@"text/plain"];
        
        NSLog(@"Request: %@", request);
        
        //[response respondWithString:[NSString stringWithFormat:@"Hello %@!", [request param:@"name"]]];
    }];
    
    NSString *ipAddress = [NetworkUtils getIPAddress:YES preferCellular:YES];
    
    //"192.168.0.118:59123/userUpdate"
    
    NSLog(@"ipAddress: %@", ipAddress);
    
}

- (void)updateGraphStore:(FBGraphStore *)graphStore withCall:(GraphCall)graphCall {
    
    NSString *OGMethod;
    if (graphCall == GraphCallHome) {
        OGMethod = @"me/home";
    } else if (graphCall == GraphCallStatuses) {
        OGMethod = @"me/statuses";
    } else {
        OGMethod = @"me/feed";
    }
    
    FBRequest * rq = [FBRequest requestWithGraphPath:OGMethod
                                          parameters:nil
                                          HTTPMethod:@"GET"];
    [rq startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result;
            [graphStore updateWithGraphResults:userData graphCall:graphCall];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

@end
