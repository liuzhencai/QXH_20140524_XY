//
//  UILabel+StringFrame.m
//  QXH
//
//  Created by ZhaoLilong on 14-6-21.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "UILabel+StringFrame.h"

@implementation UILabel (StringFrame)

- (CGSize)boundingRectWithSize:(CGSize)size
{
    CGSize retSize = [NSString getStringRect:self.text font:self.font labelSize:size];
    return retSize;
}

@end
