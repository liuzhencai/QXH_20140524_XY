//
//  NSString+LabelFrame.m
//  QXH
//
//  Created by ZhaoLilong on 14-6-21.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "NSString+LabelFrame.h"

@implementation NSString (LabelFrame)

+ (CGSize)getStringRect:(NSString*)aString
{
    return [self getStringRect:aString font:[UIFont systemFontOfSize:13.f] labelSize:CGSizeMake(300, FLT_MAX)];
}

+ (CGSize)getStringRect:(NSString *)aString font:(UIFont *)aFont labelSize:(CGSize)aSize
{
    CGSize size;
    NSDictionary *attribute = @{NSFontAttributeName:aFont};
    if (IS_OS_7_OR_LATER) {
        size = [aString boundingRectWithSize:aSize  options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    }else{
        size=[aString sizeWithFont:aFont constrainedToSize:aSize lineBreakMode:NSLineBreakByCharWrapping];
    }

    return size;
}

@end
