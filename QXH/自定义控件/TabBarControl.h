//
//  TabBarControl.h
//  MotherReminded
//
//  Created by ZhaoLilong on 13-9-4.
//  Copyright (c) 2013年 RedBaby. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TabBarItemWidth 320/3

#define TabItemOffset (TabBarItemWidth/2-12)

@interface TabBarControl : UIControl
@property (nonatomic, strong) UIView *bgView;

- (id)initWithFrame:(CGRect)frame andBackgroundImage:(UIImage *)image andTitle:(NSString *)title andDelegate:(id)del;

@end
