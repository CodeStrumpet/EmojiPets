//
//  SettingsViewController.h
//  FacePet
//
//  Created by Paul Mans on 11/5/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end
