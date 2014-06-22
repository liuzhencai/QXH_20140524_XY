//
//  NSString+LabelFrame.h
//  QXH
//
//  Created by ZhaoLilong on 14-6-21.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LabelFrame)

+ (CGSize)getStringRect:(NSString*)aString;

+ (CGSize)getStringRect:(NSString *)aString font:(UIFont *)aFont labelSize:(CGSize)aSize;

@end
