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

- (void)presentLoginViewControllerIfNecessary {
    if (![PFUser currentUser] ||
        ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:Nil];
        [self presentViewController:loginViewController animated:NO completion:^{}];
    }
}

- (IBAction)getFeedPressed:(id)sender {
    // also try "me/home" & "me/statuses"...
    FBRequest * rq = [FBRequest requestWithGraphPath:@"me/feed"
                                          parameters:nil
                                          HTTPMethod:@"GET"];
    [rq startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result;
            NSLog(@"%@", userData);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{

        });
        
    }];
    
    /*
    
    
    
    // Create request for user's Facebook data
    FBRequest *request = [FBRequest requestForMe];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            NSString *location = userData[@"location"][@"name"];
            NSString *gender = userData[@"gender"];
            NSString *birthday = userData[@"birthday"];
            NSString *relationship = userData[@"relationship_status"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            
            NSLog(@"%@", userData);
        } else {
            NSLog(@"%@", error);
        }
    }];
     */
    
    /*
    NSString *fqlQuery = @"SELECT post_id, created_time,  type, attachment FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid=me() AND type='newsfeed')AND is_hidden = 0 LIMIT 300";
    
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:[NSDictionary dictionaryWithObjectsAndKeys: fqlQuery, @"q", nil]
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error)
     {
         if (error)
             NSLog(@"Error: %@", [error localizedDescription]);
         else
             NSLog(@"Result: %@", result);
     }];
     
     */
}

- (void)logout {
     [PFUser logOut]; // Log out
}

@end
