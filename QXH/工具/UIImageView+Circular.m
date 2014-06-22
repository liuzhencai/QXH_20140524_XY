//
//  UIImageView+Circular.m
//  QXH
//
//  Created by ZhaoLilong on 14-6-21.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "UIImageView+Circular.h"

@implementation UIImageView (Circular)

- (void)circular
{
    self.layer.cornerRadius = self.bounds.size.height/2;
    self.layer.masksToBounds = YES;
    [self setContentMode:UIViewContentModeScaleAspectFill];
    [self setClipsToBounds:YES];
}

@end
