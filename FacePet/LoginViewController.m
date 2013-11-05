//
//  LoginViewController.m
//  SocialWear
//
//  Created by Paul Mans on 10/25/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import <Parse/Parse.h>
#import "LoginViewController.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UIButton *fbLoginButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSURLConnection *urlConnection;

@end

@implementation LoginViewController

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
    
}

- (void)login {
    // The permissions requested from the user
    NSArray *permissionsArray = @[ @"user_about_me", @"read_stream", @"user_status"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        _fbLoginButton.enabled = YES;
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
            
            [self dismiss];
            
            // TODO: present error
            
            return;
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
        } else {
            NSLog(@"User with facebook logged in!");
        }
        
        [self getUserProfileInfo];
    }];
}

- (IBAction)fbButtonPressed:(id)sender {
    _fbLoginButton.enabled = NO;
    [_activityIndicator startAnimating];
    
    [self login];
}

- (void)getUserProfileInfo {
    // Create request for user's Facebook data
    FBRequest *request = [FBRequest requestForMe];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            
            [AppSettings setFacebookID:facebookID];
            [AppSettings setUserName:name];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];            
            
            // kick off loading the user's profile pic
            _imageData = [[NSMutableData alloc] init]; // the data will be loaded in here
            
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                  timeoutInterval:2.0f];
            // Run network request asynchronously
            _urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            [_urlConnection start];

        }
    }];
}

// Called every time a chunk of the data is received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_imageData appendData:data]; // Build the image
}

// Called when the entire image is finished downloading
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSLog(@"Profile image loaded");
    [AppSettings setUserProfileImageData:_imageData];
    
    [self dismiss];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self dismiss];
}

- (void)dismiss {
    [_activityIndicator stopAnimating];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGGED_IN_USER_CHANGED object:nil];
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
