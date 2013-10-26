//
//  MainViewController.m
//  http-bridge-webview-native
//
//  Created by Paul Mans on 8/13/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MainViewController.h"
#import "AppDelegate.h"
#import "FBGraphConnection.h"
#import "FBGraphStore.h"
#import "RoutingHTTPServer.h"
#import "LoginViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) FBGraphConnection *graphConnection;
@property (nonatomic, strong) FBGraphStore *graphStore;

@end


@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    _graphConnection = [[FBGraphConnection alloc] init];
    _graphStore = [[FBGraphStore alloc] init];
    
    [self presentLoginViewControllerIfNecessary];
}

- (void)presentLoginViewControllerIfNecessary {
    if (![PFUser currentUser] ||
        ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:Nil];
        [self presentViewController:loginViewController animated:NO completion:^{}];
    }
}

- (IBAction)getFeedPressed:(id)sender {
    
    [_graphConnection updateGraphStore:_graphStore withCall:GraphCallFeed];
    
}

- (void)logout {
     [PFUser logOut]; // Log out
}

@end
