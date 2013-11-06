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
    _display.image = image;
}


@end
