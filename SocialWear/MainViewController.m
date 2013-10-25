//
//  MainViewController.m
//  http-bridge-webview-native
//
//  Created by Paul Mans on 8/13/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import <Parse/Parse.h>
#import "MainViewController.h"
#import "AppDelegate.h"
#import "RoutingHTTPServer.h"
#import "LoginViewController.h"

@interface MainViewController ()


@end


@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    
    [self presentLoginViewControllerIfNecessary];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentLoginViewControllerIfNecessary {
    if (![PFUser currentUser] ||
        ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:Nil];
        [self presentViewController:loginViewController animated:NO completion:^{}];
    }
}

- (void)logout {
     [PFUser logOut]; // Log out
}

@end
