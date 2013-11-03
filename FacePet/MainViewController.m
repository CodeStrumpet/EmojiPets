//
//  MainViewController.m
//  http-bridge-webview-native
//
//  Created by Paul Mans on 8/13/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import <PebbleKit/PebbleKit.h>
#import "MainViewController.h"
#import "AppDelegate.h"
#import "FBGraphConnection.h"
#import "FBGraphStore.h"
#import "LoginViewController.h"
#import "FBDiff.h"

typedef enum FBUpdateState {
    UpdateStateNone = 0x0,
    UpdateStateFeed = 0x1,
    UpdateStateStatuses = 0x2,
    UpdateStateBoth = 0x3
} FBUpdateState;


@interface MainViewController ()

@property (nonatomic, strong) FBGraphConnection *graphConnection;
@property (nonatomic, strong) FBGraphStore *graphStore;
@property (nonatomic, strong) FBDiff *feedDiff;
@property (nonatomic, strong) FBDiff *statusesDiff;
@property (nonatomic, assign) FBUpdateState currUpdateState;

@end


@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    _graphConnection = [[FBGraphConnection alloc] init];
    
    _graphStore = [[FBGraphStore alloc] init];
    
    [self presentLoginViewControllerIfNecessary];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGraphReturned:) name:GRAPH_UPDATE_NOTIFICATION object:nil];
}

- (void)presentLoginViewControllerIfNecessary {
    if (![PFUser currentUser] ||
        ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:Nil];
        [self presentViewController:loginViewController animated:NO completion:^{}];
    }
}

- (IBAction)getFeedPressed:(id)sender {
    
    _currUpdateState = UpdateStateNone;
    [_graphConnection updateGraphStore:_graphStore withCall:GraphCallFeed];
    [_graphConnection updateGraphStore:_graphStore withCall:GraphCallStatuses];
    
}

- (IBAction)callWatchPressed:(id)sender {
    
    
    // Send data to watch:
    // See demos/feature_app_messages/weather.c in the native watch app SDK for the same definitions on the watch's end:
    NSNumber *iconKey = @(0); // This is our custom-defined key for the icon ID, which is of type uint8_t.
    NSNumber *temperatureKey = @(1); // This is our custom-defined key for the temperature string.
    NSDictionary *update = @{ iconKey:[NSNumber numberWithUint8:1],
                              temperatureKey:[NSString stringWithFormat:@"%d\u00B0C", 55] };
    
    [[AppDelegate instance].targetWatch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
        
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success!");
        }

    }];

}

- (void)updateGraphReturned:(NSNotification *)notification {
    FBDiff *diff = [notification.userInfo objectForKey:FB_DIFF_KEY];
    
    if (diff) {
        if (diff.graphCall == GraphCallFeed) {
            _currUpdateState |= UpdateStateFeed;
            _feedDiff = diff;
            NSLog(@"Feed diff finished");
        } else if (diff.graphCall == GraphCallStatuses) {
            _currUpdateState |= UpdateStateStatuses;
            _statusesDiff = diff;
            NSLog(@"Statuses diff finished");
        }
    }
    
    
    if (_currUpdateState == UpdateStateBoth) {
        NSLog(@"All diffs finished %d", _currUpdateState);
    }
}

- (void)logout {
     [PFUser logOut]; // Log out
}

@end
