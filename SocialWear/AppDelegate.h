//
//  AppDelegate.h
//  http-bridge-webview-native
//
//  Created by Paul Mans on 8/13/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoutingHTTPServer;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) UISplitViewController *splitViewController;

@property (strong, nonatomic) RoutingHTTPServer *httpServer;

+ (AppDelegate *)instance;

@end
