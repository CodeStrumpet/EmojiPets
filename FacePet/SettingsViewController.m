//
//  SettingsViewController.m
//  FacePet
//
//  Created by Paul Mans on 11/5/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import "SettingsViewController.h"
#import "UIViewController+JASidePanel.h"
#import "LoginViewController.h"
#import <PebbleKit/PebbleKit.h>
#import "AppDelegate.h"
#import "SettingsTableViewCell.h"

@interface SettingsViewController ()

@end

enum {
    kEmojiRow,
    kPebbleRow,
    kUserRow,
    NUM_ROWS
};

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**
 *  Load View
 */
- (void)loadView {
    self.view = [[UIView alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //self.tableView.separatorColor = [UIColor ]
    [self.view addSubview:self.tableView];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"SettingsTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

#pragma mark - Table delegates
/**
 *  Get table header view
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return nil;
}

/**
 *  Header height
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return NUM_ROWS;
        default:
            return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (indexPath.row == kEmojiRow) {
        PetType type = [AppSettings petType];
        cell.imageView.image = [ResourceHelper petFrameImageForPetType:type];
        cell.label.text = @"Choose your pet";
    } else if (indexPath.row == kPebbleRow) {
        cell.imageView.image = [UIImage imageNamed:@"pebble_watch"];
        if ([AppDelegate instance].targetWatch) {
            cell.label.text = [NSString stringWithFormat:@"Connected to %@", [[AppDelegate instance].targetWatch name]];
        } else {
            cell.label.text = @"No watch connection";
        }
    } else {
        cell.imageView.image = [AppSettings userProfileImage];
        if ([AppSettings userName]) {
            cell.label.text = [AppSettings userName];
        } else {
            cell.label.text = @"Login to feed your pet!";
        }
    }
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == kEmojiRow) {
        
    } else if (indexPath.row == kPebbleRow) {
        
    } else if (indexPath.row == kUserRow) {
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:Nil];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        
        [self presentViewController:navController animated:YES completion:^{}];
    }
    
    
}

@end
