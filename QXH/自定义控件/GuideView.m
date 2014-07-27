//
//  GuideView.m
//  QXH
//
//  Created by XueYong on 7/12/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "GuideView.h"

@implementation GuideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.MasterScrollView.delegate = self;
//        self.lastOffSetX = 0.0;
        self.frame = frame;
        [self initializeViewComponents];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)initializeViewComponents{
    
    NSArray *  imagesArr = nil;
    if (!iPhone5) {
        imagesArr = @[@"guide_page5_1.jpg",@"guide_page5_2.jpg",@"guide_page5_3.jpg",@"guide_page5_4.jpg"];
    }else{
        imagesArr = @[@"guide1.jpg",@"guide2.jpg",@"guide3.jpg",@"guide4.jpg"];
    }
    
    _MasterScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    self.MasterScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleHeight;
    self.MasterScrollView.pagingEnabled = YES;
    self.MasterScrollView.delegate = self;
    self.MasterScrollView.bounces = NO;
    self.MasterScrollView.showsHorizontalScrollIndicator = NO;
    self.MasterScrollView.showsVerticalScrollIndicator = NO;
    self.MasterScrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.MasterScrollView];
    self.MasterScrollView.backgroundColor = [UIColor redColor];
    self.MasterScrollView.contentSize = CGSizeMake(self.frame.size.width * [imagesArr count], self.frame.size.height);
    
    for (int i = 0; i < [imagesArr count]; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * UI_SCREEN_WIDTH, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
        [self.MasterScrollView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        NSString *imageName = [imagesArr objectAtIndex:i];
        NSLog(@"%@",imageName);
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",imageName]];
        if (i == [imagesArr count] - 1) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((UI_SCREEN_WIDTH - 135)/2.0 + 3, UI_SCREEN_HEIGHT - 60, 135, 30);
            if (!iPhone5) {
                button.frame = CGRectMake((UI_SCREEN_WIDTH - 135)/2.0, UI_SCREEN_HEIGHT - 60, 135, 30);
            }
//            button.backgroundColor = [UIColor redColor];
            [button setTitle:@"立即进入" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(startApp:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
        }
    }
    
    self.PageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH - 100) / 2.0, UI_SCREEN_HEIGHT - 35, 100, 20)];
    self.PageControl.backgroundColor = [UIColor clearColor];
    self.PageControl.numberOfPages = [imagesArr count];
    [self addSubview:self.PageControl];
}

- (void)startApp:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(guideDidFinish:)]) {
        [self.delegate guideDidFinish:self];
    }
}
#pragma mark - UIScrollView Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger CurrentPanelIndex = scrollView.contentOffset.x/self.MasterScrollView.frame.size.width;
    self.PageControl.currentPage = CurrentPanelIndex;
    
}

//This will handle our changing opacity at the end of the introduction
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSInteger index = scrollView.contentOffset.x/self.MasterScrollView.frame.size.width;
//
//    if (self.lastOffSetX > scrollView.contentOffset.x) {
//        if (scrollView.contentOffset.x < (index + 1) * self.MasterScrollView.frame.size.width) {
//        }
//    }else{
//    }
//    
//    CGFloat rate = self.subScrollView.frame.size.width/self.MasterScrollView.frame.size.width;
//    self.subScrollView.contentOffset = CGPointMake(scrollView.contentOffset.x * rate, 0);
//    
//    CGFloat rate2 = BG_MOVE_LENGHT_IPHONE5/self.MasterScrollView.frame.size.width;
//    if (!iPhone5) {
//        rate2 = BG_MOVE_LENGHT_IPHONE4/self.MasterScrollView.frame.size.width;
//    }
//    self.BackgroundImageView.frame = CGRectMake(-scrollView.contentOffset.x * rate2, self.frame.origin.y, self.BackgroundImageView.frame.size.width, self.BackgroundImageView.frame.size.height);
}


@end
