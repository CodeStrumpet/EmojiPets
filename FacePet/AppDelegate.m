//
//  AppDelegate.m
//  http-bridge-webview-native
//
//  Created by Paul Mans on 8/13/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "RoutingHTTPServer.h"
#import "NetworkUtils.h"
#import <Parse/Parse.h>


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
    
    // Configure our logging framework.
	// To keep things simple and fast, we're just going to log to the Xcode console.
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    
    // kick things off by starting the local http server
    _httpServer = [[RoutingHTTPServer alloc] init];
    [_httpServer setPort:12345];
    [_httpServer setDefaultHeader:@"Server" value:@"rockfakie/1.0"];
    
    NSError *error = nil;
    if([_httpServer start:&error]) {
		DDLogInfo(@"Started HTTP Server on port %hu", [_httpServer listeningPort]);
	} else {
		DDLogError(@"Error starting HTTP Server: %@", error);
	}

    // copy html files in bundle to documents directory
    [self copyBundleDirectoryToDocuments:@"html"];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        MainViewController *mainViewcontroller = [[MainViewController alloc] initWithNibName:@"MainViewController_iPhone" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewcontroller];
        self.window.rootViewController = self.navigationController;
        
    } else {
        
        MainViewController *mainViewcontroller = [[MainViewController alloc] initWithNibName:@"MainViewController_iPad" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewcontroller];
        self.window.rootViewController = self.navigationController;
    }
    [self.window makeKeyAndVisible];
    
        
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

@end
