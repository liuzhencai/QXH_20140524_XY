//
//  TabBarControl.m
//  MotherReminded
//
//  Created by ZhaoLilong on 13-9-4.
//  Copyright (c) 2013年 RedBaby. All rights reserved.
//

#import "TabBarControl.h"
#import <QuartzCore/QuartzCore.h>

@implementation TabBarControl
@synthesize bgView;

- (id)initWithFrame:(CGRect)frame andBackgroundImage:(UIImage *)image andTitle:(NSString *)title andDelegate:(id)del
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *iconImage = [[UIImageView alloc] initWithImage:image highlightedImage:image];
        iconImage.frame = CGRectMake(TabItemOffset, 5, 24, 24);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, 320/3, 21)];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = kTextAlignmentCenter;
        titleLabel.text = title;
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:iconImage];
        [self addSubview:titleLabel];
        
        [self addTarget:del action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    }
    return self;
}
 
@end
