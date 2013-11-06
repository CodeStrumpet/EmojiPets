//
//  EmojiFrameView.m
//  FacePet
//
//  Created by Paul Mans on 11/5/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import "EmojiFrameView.h"

@implementation EmojiFrameView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)updateLayout {
    float width = _frameButton.bounds.size.width;
    float height = _frameButton.bounds.size.height;
    
    CGRect displayFrame = CGRectMake(_frameButton.frame.origin.x + _displayX * width, _frameButton.frame.origin.y + _displayY * height, _displayWidth * width, _displayHeight * height);
    
    _display.frame = displayFrame;
}

- (void)displayImage:(UIImage *)image {
    if (image) {
        _display.hidden = NO;
        

        UIImage * landscapeImage = [[UIImage alloc] initWithCGImage: image.CGImage
                                                             scale: 1.0
                                                       orientation: UIImageOrientationRight];
        _display.image = landscapeImage;
        
    } else {
        _display.hidden = YES;
        _display.image = image;
    }
    
}

- (void)displayFrameImage:(UIImage *)image {
    [_frameButton setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)setDisplayPositionWithRect:(CGRect)displayRect {
    _displayX = displayRect.origin.x;
    _displayY = displayRect.origin.y;
    _displayWidth = displayRect.size.width;
    _displayHeight = displayRect.size.height;
}

@end
