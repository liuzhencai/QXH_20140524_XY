//
//  CustomSegmentView.m
//  QXH
//
//  Created by XUE on 14-5-21.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "CustomSegmentView.h"

@implementation CustomSegmentView

@synthesize items,selectIndex,targetValue,selector,btnArr,isSetInitValue,hiddenWhenSigle;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        selectIndex = -100;
        NSMutableArray *table = [[NSMutableArray alloc] init];
        self.btnArr = table;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    NSInteger itemsCount = [items count];
    NSInteger btnWidth = self.width/itemsCount;
    NSInteger btnHeight = self.height - 2;
    
    UIImageView *lineBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, btnHeight, self.width, 2)];
    lineBgView.image = [UIImage imageNamed:@"navigation_slippage_bar_bg"];
    [self addSubview:lineBgView];
    
    for (int i = 0; i < itemsCount; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitle:[items objectAtIndex:i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_WITH_ARGB(83, 170, 97, 1.0) forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(changeSelectIndex:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(i*btnWidth, 0, btnWidth, btnHeight);
        [self addSubview:btn];
        
        UIImageView *instructions = [[UIImageView alloc] initWithFrame:CGRectMake(btn.left, btnHeight, btnWidth, 2)];
        instructions.tag = 100 + i;
        if (i != 0) {
            instructions.hidden = YES;
        }
        instructions.image = [UIImage imageNamed:@"navigation_slippage_bar_green"];
        [self addSubview:instructions];
        
        [btnArr addObject:btn];
        
    }
    
//    for (int i = 0; i < itemsCount; i ++) {
//        if (i < itemsCount - 1) {
//            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(btnWidth * (i + 1), 0, 1, self.frame.size.height)];
//            imageView.image = [UIImage imageNamed:@"segment_mid_down"];
//            //            self.backgroundColor = [UIColor redColor];
//            [self addSubview:imageView];
//        }
//    }
    
//    if (isSetInitValue) {
//        for (UIButton *subBtn in btnArr) {
//            if (subBtn.tag == currentSelectIndex) {
//                UIButton *btn = subBtn;
//                [self changeSelectIndex:btn];
//                break;
//            }
//        }
//        isSetInitValue = NO;
//    }
    if ([items count]==1&&hiddenWhenSigle==YES) {
        self.hidden = YES;
    }
}

- (void)setSelectIndex:(NSInteger)index{
    currentSelectIndex = index;
    isSetInitValue = YES;
}

- (void)changeSelectIndex:(id)sender{
    UIButton *btn = (UIButton *)sender;
    UIButton *lastBtn = nil;
    for (UIButton *subBtn in btnArr) {
        if (subBtn.tag == selectIndex) {
            lastBtn = subBtn;
        }
    }
    if (self.selectIndex == btn.tag&&btn) {
        return;
    }
    UIImageView *lastIns = (UIImageView *)[self viewWithTag:lastBtn.tag + 100];
    lastIns.hidden = YES;
    UIImageView *selectIns = (UIImageView *)[self viewWithTag:btn.tag + 100];
    selectIns.hidden = NO;
    
    lastBtn.selected = NO;
    btn.selected = YES;
    selectIndex = btn.tag;
    
    [targetValue performSelector:selector withObject:self afterDelay:0];
}

-(void)addTarget:(id)target action:(SEL)action{
    self.targetValue = target;
    self.selector = action;
}


@end
