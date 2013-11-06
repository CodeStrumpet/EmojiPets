//
//  EmojiFrameView.h
//  FacePet
//
//  Created by Paul Mans on 11/5/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmojiFrameView : UIView

@property (strong, nonatomic) IBOutlet UIButton *frameButton;
@property (strong, nonatomic) IBOutlet UIImageView *display;

@property (assign, nonatomic) float displayX;
@property (assign, nonatomic) float displayY;
@property (assign, nonatomic) float displayWidth;
@property (assign, nonatomic) float displayHeight;

- (void)updateLayout;
- (void)displayImage:(UIImage *)image;
- (void)setDisplayPositionWithRect:(CGRect)displayRect; 
@end
