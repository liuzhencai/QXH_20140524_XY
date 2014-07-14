//
//  HomePageController.h
//  QXH
//
//  Created by ZhaoLilong on 14-5-4.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageController : MyViewController<UIScrollViewDelegate>
{
    NSInteger icout;
}

@property (strong, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIImageView *portraitView;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
/*3.5寸适配*/
@property (weak, nonatomic) IBOutlet UIScrollView *topScrollthree;
/*4寸适配*/
@property (weak, nonatomic) IBOutlet UIScrollView *topScrollfour;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)btnClick:(id)sender;


/*4寸适配*/
@property (strong, nonatomic) IBOutlet UIView *viewfour;

/*3.5寸适配*/
@property (strong, nonatomic) IBOutlet UIView *viewThree;

- (void)reConnection;


@end
