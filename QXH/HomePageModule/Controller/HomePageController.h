//
//  HomePageController.h
//  QXH
//
//  Created by ZhaoLilong on 14-5-4.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageController : MyViewController<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIScrollView *topScroll;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)btnClick:(id)sender;

@end
