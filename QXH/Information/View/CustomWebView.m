//
//  CustomWebView.m
//  QXH
//
//  Created by ZhaoLilong on 14-7-12.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "CustomWebView.h"

@implementation CustomWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // hide the shadows at the top and bottom of the webview's frame
    for (UIView* shadowView in [self.scrollView subviews])
    {
        if ([shadowView isKindOfClass:[UIImageView class]]) {
            [shadowView setHidden:YES];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
