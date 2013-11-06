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
#import <QuartzCore/QuartzCore.h>
#import "MainViewController.h"
#import "AppDelegate.h"
#import "FBGraphConnection.h"
#import "FBGraphStore.h"
#import "LoginViewController.h"
#import "FBDiff.h"
#import "PetSelectorViewController.h"
#import "EmojiFrameView.h"

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
@property (strong, nonatomic) IBOutlet EmojiFrameView *emojiFrameView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *hungrySegments;
@property (strong, nonatomic) IBOutlet UISegmentedControl *worriedSegments;
@property (strong, nonatomic) IBOutlet UISegmentedControl *boredSegments;
@property (strong, nonatomic) IBOutlet UISegmentedControl *intriguedSegments;
@property (strong, nonatomic) IBOutlet UISegmentedControl *happySegments;
@property (strong, nonatomic) IBOutlet UIView *testPane;

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
    
    [self updateEmojiPetDisplay];

    
    [self setTitle:@"EmojiPet"];
    
    [_hungrySegments setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [_worriedSegments setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [_boredSegments setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [_intriguedSegments setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [_happySegments setSelectedSegmentIndex:UISegmentedControlNoSegment];
//    _testPane.layer.cornerRadius = 8;
//    _testPane.layer.borderWidth = 1;
//    _testPane.layer.borderColor = [[UIColor grayColor] CGColor];
    
    
    // Handle Graph updated
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGraphReturned:) name:GRAPH_UPDATE_NOTIFICATION object:nil];
    
    // Handle Pet Change update
    [[NSNotificationCenter defaultCenter] addObserverForName:PET_TYPE_CHANGED_NOTIFICATION object:nil queue:nil usingBlock:^(NSNotification *notification) {
        
        [self updateEmojiPetDisplay];
    }];
    
    // Handle login change notification LOGGED_IN_USER_CHANGED
    [[NSNotificationCenter defaultCenter] addObserverForName:LOGGED_IN_USER_CHANGED object:nil queue:nil usingBlock:^(NSNotification *notification) {
    }];
}


- (void)updateEmojiPetDisplay {
    PetType petType = [AppSettings petType];
    
    UIImage *backgroundImage = [ResourceHelper petFrameImageForPetType:petType];
    [_emojiFrameView displayFrameImage:backgroundImage];

    if (petType == PetTypeNone) {
        
        _emojiFrameView.frameButton.enabled = YES;
        [_emojiFrameView displayImage:nil];
        [self.navigationItem setRightBarButtonItem:nil];
        
    } else {
        _emojiFrameView.frameButton.enabled = NO;
        
        // update display frame size
        CGRect petFrameRect = [[AppDelegate instance] petFrameForPetType:petType];
        [_emojiFrameView setDisplayPositionWithRect:petFrameRect];
        [_emojiFrameView updateLayout];
    }
    
}

- (void)presentLoginViewControllerIfNecessary {
    if (![PFUser currentUser] ||
        ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self presentLoginViewController];
    }
}

- (void)presentLoginViewController {
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:Nil];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    
    [self presentViewController:navController animated:NO completion:^{}];
}

- (IBAction)getFeedPressed:(id)sender {
    
    _currUpdateState = UpdateStateNone;
    //[_graphConnection updateGraphStore:_graphStore withCall:GraphCallFeed];
    [_graphConnection updateGraphStore:_graphStore withCall:GraphCallStatuses];
    
}


- (IBAction)emojiFramePressed:(id)sender {
    [self showPetSelectorViewController];
}

- (void)showPetSelectorViewController {
    PetSelectorViewController *petSelectorViewController = [[PetSelectorViewController alloc] initWithNibName:@"PetSelectorViewController" bundle:nil];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:petSelectorViewController];
    
    [self presentViewController:navController animated:YES completion:^{
    }];
}

- (void)updateWatchImage:(int)imageNum {
    
    // Send data to watch:
    // See demos/feature_app_messages/weather.c in the native watch app SDK for the same definitions on the watch's end:
    NSNumber *iconKey = @(0); // This is our custom-defined key for the icon ID, which is of type uint8_t.
    NSDictionary *update = @{ iconKey:[NSNumber numberWithUint8:imageNum] };
    
    [[AppDelegate instance].targetWatch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
        
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success!");
        }
        
    }];
}

//- (IBAction)sliderChanged:(id)sender {
//    int sliderValue;
//    sliderValue = lroundf(_slider.value);
//    [_slider setValue:sliderValue animated:YES];
//    
//    NSLog(@"new slider value: %d", (int)_slider.value);
//    
//    //    NSString *key = [[petFace allKeys] firstObject];
//    
//
//    
//    [self updateWatchImage:(int)_slider.value];
//}

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
    
    
    //if (_currUpdateState == UpdateStateBoth) {
        //NSLog(@"All diffs finished %d", _currUpdateState);
        
    int numPosts = _feedDiff.totalPosts + _statusesDiff.totalPosts;
    // cap the total posts to the number of hunger states
    if (numPosts > 4) {
        numPosts = 4;
    }
    
    BOOL newPosts = _feedDiff.newPosts > 0 || _statusesDiff.newPosts > 0;
    BOOL newActivity = _feedDiff.newLikes > 0 || _statusesDiff.newLikes > 0 || _feedDiff.newComments > 0 || _statusesDiff.newComments > 0;
    
    int activityMeasure = _feedDiff.totalLikes + _feedDiff.totalComments + _statusesDiff.totalLikes + _statusesDiff.totalComments;
    
    if (activityMeasure > 3) {
        activityMeasure = 3;
    }
    
    NSLog(@"NumPosts: %d  NewPosts: %@, NewActivity: %@, ActivityMeasure: %d",
          numPosts, newPosts ? @"YES" : @"NO", newActivity ? @"YES" : @"NO", activityMeasure);
    
    
    if (newPosts && !newActivity) {
        [self updateWithHungerState:numPosts andExcitementLevel:0 turnOff:YES];
    } else if ((newPosts && newActivity) || (!newPosts && newActivity)) {
        [self updateWithHungerState:numPosts andExcitementLevel:activityMeasure turnOff:YES];
    } else {
        [self updateWithHungerState:numPosts andExcitementLevel:0 turnOff:YES];
    }
        
    //}
}

- (void)updateWithHungerState:(int)hungerState andExcitementLevel:(int)excitementLevel turnOff:(BOOL)turnOff {
    
    _graphStore.numPostsToday = hungerState; // make sure we can go back to this number...
    
    int faceSetNum = [AppSettings faceSetNum];
    
    NSDictionary *petFace = [ResourceHelper petFaceForFaceSetNum:faceSetNum hungerLevel:hungerState andExcitementLevel:excitementLevel];
    
    NSString *petFaceName = [[petFace allKeys] firstObject];
    
    if (petFaceName) {
        UIImage *petFaceImage = [UIImage imageNamed:petFaceName];
        [_emojiFrameView displayImage:petFaceImage];
        
        NSNumber *watchImageNumber = [petFace objectForKey:petFaceName];
        
        [self updateWatchImage:[watchImageNumber intValue]];
        
        if (turnOff) {
            // reset back to our base state
            int64_t delayInSeconds = 3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self updateWithHungerState:_graphStore.numPostsToday andExcitementLevel:0 turnOff:NO];
            });
            
        }
    }
}

- (void)logout {
     [PFUser logOut]; // Log out
}


#pragma mark - DEBUG

- (IBAction)debugSegmentChanged:(id)sender {
    int excitementState = ((UISegmentedControl *) sender).selectedSegmentIndex;
    
    int hungerState = ((UISegmentedControl *) sender).tag;
    
    [self updateWithHungerState:hungerState andExcitementLevel:excitementState turnOff:YES];
    
}





@end
