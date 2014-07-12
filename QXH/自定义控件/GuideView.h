//
//  GuideView.h
//  QXH
//
//  Created by XueYong on 7/12/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GuideView;
@protocol GuideViewDelegate
- (void)guideDidFinish:(GuideView *)guide;
@end
@interface GuideView : UIView<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *MasterScrollView;//住scrollview
@property (nonatomic, strong) UIPageControl *PageControl;//
@property (nonatomic, assign) id delegate;

@end
