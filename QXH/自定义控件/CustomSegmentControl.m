//
//  CustomSegmentControl.m
//  QXH
//
//  Created by ZhaoLilong on 5/21/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "CustomSegmentControl.h"

@interface CustomSegmentControl ()
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSMutableArray *buttons;
@end

@implementation CustomSegmentControl

@synthesize num, height, buttons;

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        buttons = [[NSMutableArray alloc] init];
        num = [titles count];
        height = frame.size.height;
        // Initialization code
        for (int i = 0; i < num; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*(320/num), 0, 320/num, height);
            if (i == 0) {
                [btn setTitleColor:RGBCOLOR(78, 199, 60) forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
            [self addSubview:btn];
            [buttons addObject:btn];
        }
        // 添加灰色横条
        UIImageView *slippage = [[UIImageView alloc] initWithFrame:CGRectMake(0, height-2, 320, 2)];
        slippage.image = [UIImage imageNamed:@"navigation_slippage_bar_bg"];
        [self addSubview:slippage];
        
        // 添加绿色横条
        UIImageView *slideView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height-2, 320/num, 2)];
        slideView.tag = 2000;
        slideView.image = [UIImage imageNamed:@"navigation_slippage_bar_green"];
        [self addSubview:slideView];
    }
    return self;
}

- (void)btnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = [buttons indexOfObject:btn];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.25f];
    UIImageView *slideView_ = (UIImageView *)[self viewWithTag:2000];
    slideView_.frame = CGRectMake(index*(320/num), height-2, (320/num), 2);
    [UIView commitAnimations];
    
    for (UIButton *tmpBtn in buttons) {
        [tmpBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [btn setTitleColor:RGBCOLOR(78, 199, 60) forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(segmentClicked:)]) {
        [self.delegate segmentClicked:index];
    }
}

@end
