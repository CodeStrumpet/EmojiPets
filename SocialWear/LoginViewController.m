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
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        _fbLoginButton.enabled = YES;
        [_activityIndicator stopAnimating];
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
            
            // TODO: present error
            return;
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
        } else {
            NSLog(@"User with facebook logged in!");
        }
        [self dismissViewControllerAnimated:YES completion:^{}];
    }];
}

- (IBAction)fbButtonPressed:(id)sender {
    _fbLoginButton.enabled = NO;
    [_activityIndicator startAnimating];
    
    [self login];
}

@end
