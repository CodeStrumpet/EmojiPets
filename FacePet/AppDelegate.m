//
//  AppDelegate.m
//  http-bridge-webview-native
//
//  Created by Paul Mans on 8/13/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "NetworkUtils.h"
#import "SettingsViewController.h"
#import <Parse/Parse.h>
#import <JASidePanels/JASidePanelController.h>

#define PEBBLE_APP_UUID 0xB2, 0xF9, 0xE6, 0x12, 0x68, 0x71, 0x45, 0x1C, 0xB2, 0x3B, 0x2C, 0x93, 0x32, 0xCD, 0x51, 0x27

@implementation AppDelegate

+ (AppDelegate *)instance {
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [Parse setApplicationId:@"3ZwPJcvrYgPaRfO1sAHhKqEAnCaC0EuZAiPsd3t7"
                  clientKey:@"Fo53O8rUOrxMxhDPs3vf5cSbhIG5y1HIdcREoMuz"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [PFFacebookUtils initializeFacebook];
        
    // copy html files in bundle to documents directory
    [self copyBundleDirectoryToDocuments:@"html"];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {

        
        self.viewController = [[JASidePanelController alloc] init];
        
        MainViewController *mainViewcontroller = [[MainViewController alloc] initWithNibName:@"MainViewController_iPhone" bundle:nil];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainViewcontroller];
        self.viewController.centerPanel = navController;
        
        self.viewController.leftPanel = [[SettingsViewController alloc] init];
        
        self.window.rootViewController = self.viewController;
        
    } else {
        
        MainViewController *mainViewcontroller = [[MainViewController alloc] initWithNibName:@"MainViewController_iPad" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewcontroller];
        self.window.rootViewController = self.navigationController;
    }
    [self.window makeKeyAndVisible];
    
    
    // We'd like to get called when Pebbles connect and disconnect, so become the delegate of PBPebbleCentral:
    [[PBPebbleCentral defaultCentral] setDelegate:self];
    
    // Initialize with the last connected watch:
    [self setTargetWatch:[[PBPebbleCentral defaultCentral] lastConnectedWatch]];
        
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)setTargetWatch:(PBWatch*)watch {
    _targetWatch = watch;
    
    // NOTE:
    // For demonstration purposes, we start communicating with the watch immediately upon connection,
    // because we are calling -appMessagesGetIsSupported: here, which implicitely opens the communication session.
    // Real world apps should communicate only if the user is actively using the app, because there
    // is one communication session that is shared between all 3rd party iOS apps.
    
    // Test if the Pebble's firmware supports our app:
    [watch appMessagesGetIsSupported:^(PBWatch *watch, BOOL isAppMessagesSupported) {
        if (isAppMessagesSupported) {
            
            // Configure our communications channel to target our app:
            uint8_t bytes[] = {PEBBLE_APP_UUID};
            NSData *uuid = [NSData dataWithBytes:bytes length:sizeof(bytes)];
            [watch appMessagesSetUUID:uuid];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:WATCH_CONNECTED_NOTIFICATION object:self userInfo:nil];
            
        } else {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:WATCH_DISCONNECTED_NOTIFICATION object:self userInfo:nil];
        }
    }];
}

-(void)copyBundleDirectoryToDocuments:(NSString *)directory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *documentDBFolderPath = [documentsDir stringByAppendingPathComponent:directory];
    NSString *resourceDBFolderPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:directory];
    
    if (![fileManager fileExistsAtPath:documentDBFolderPath]) {
        NSError *copyError = nil;
        if (![[NSFileManager defaultManager] copyItemAtPath:resourceDBFolderPath toPath:documentDBFolderPath error:&copyError]) {
            NSLog(@"Error copying files: %@", [copyError localizedDescription]);
        }
        
         // do we ever need to create the directory??
         //[fileManager createDirectoryAtPath:documentDBFolderPath withIntermediateDirectories:NO attributes:nil error:&error];
        
    } else {
        NSLog(@"Directory already exists! %@", documentDBFolderPath);
    }
}


#pragma mark - PebbleCentralDelegate

- (void)pebbleCentral:(PBPebbleCentral*)central watchDidConnect:(PBWatch*)watch isNew:(BOOL)isNew {
    [self setTargetWatch:watch];
}

- (void)pebbleCentral:(PBPebbleCentral*)central watchDidDisconnect:(PBWatch*)watch {
    [[[UIAlertView alloc] initWithTitle:@"Disconnected!" message:[watch name] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    if (_targetWatch == watch || [watch isEqual:_targetWatch]) {
        [self setTargetWatch:nil];
    }
}

@end
