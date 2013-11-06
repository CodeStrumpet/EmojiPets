//
//  AppDelegate.h
//  http-bridge-webview-native
//
//  Created by Paul Mans on 8/13/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PebbleKit/PebbleKit.h>

@class JASidePanelController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, PBPebbleCentralDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) JASidePanelController *viewController;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) UISplitViewController *splitViewController;

@property (strong, nonatomic) PBWatch *targetWatch;

+ (AppDelegate *)instance;

@end
