//
//  PetSelectorViewController.m
//  FacePet
//
//  Created by Paul Mans on 11/5/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import "PetSelectorViewController.h"

@interface PetSelectorViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *petFrameImageView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation PetSelectorViewController

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
    
    self.title = @"Choose your Pet!";

    [self updatePetDisplay];
    
    UIBarButtonItem *dismissItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
    
    [self.navigationItem setRightBarButtonItem:dismissItem];
    
    UIBarButtonItem *petStoreItem = [[UIBarButtonItem alloc] initWithTitle:@"Pet Store" style:UIBarButtonItemStyleBordered target:nil action:@selector(goToPetStore)];
    
    [self.navigationItem setLeftBarButtonItem:petStoreItem];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
                                    
- (void)goToPetStore {
    NSLog(@"Coming soon");
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)segmentedControlChanged:(id)sender {
    
    [self setPetType:_segmentedControl.selectedSegmentIndex + 1];
    
}

- (IBAction)faceSetChanged:(id)sender {
    if (((UISwitch *) sender).isOn) {
        [AppSettings setFaceSetNum:1];
    } else {
        [AppSettings setFaceSetNum:0];
    }
}

- (void)updatePetDisplay {
    
    PetType type = [AppSettings petType];
    
    
    if (type == PetTypeNone) {
        [self setPetType:_segmentedControl.selectedSegmentIndex + 1];
        return;
    } else {
        [_petFrameImageView setImage:[ResourceHelper petFrameImageForPetType:type]];
    }

    [_segmentedControl setSelectedSegmentIndex:type - 1];
}

- (void)setPetType:(PetType)petType {
    
    [AppSettings setPetType:petType];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PET_TYPE_CHANGED_NOTIFICATION object:nil];
    
    [self updatePetDisplay];
}

@end
