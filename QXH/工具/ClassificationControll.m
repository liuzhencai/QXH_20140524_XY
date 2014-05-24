//
//  ClassificationControll.m
//  Education
//
//  Created by liuzhencai on 14-5-5.
//  Copyright (c) 2014年 liuzhencai. All rights reserved.
//

#import "ClassificationControll.h"

#define kbutonWidth 100

@implementation ClassificationControll

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        backScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        backScroll.delegate = self;
        [self addSubview:backScroll];
        
        backScroll.contentSize = CGSizeMake(700, self.frame.size.height);
        NSArray* tempArray = [[NSArray alloc]initWithObjects:@"最新",@"收藏",@"教育", @"学生",nil];
        
        for (int i=0; i<[tempArray count]; i++) {
            UIButton * buton = [UIButton buttonWithType:UIButtonTypeCustom];
            [buton setFrame:CGRectMake(kbutonWidth*i, 0, kbutonWidth, self.frame.size.height)];
            [buton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [buton setTitle:[tempArray objectAtIndex:i] forState:UIControlStateNormal];
            buton.backgroundColor = [UIColor clearColor];
            buton.tag = 10+i;
            [buton addTarget:self action:@selector(butonPress:) forControlEvents:UIControlEventTouchUpInside];//
//            [buton addTarget:self action:@selector(butonDrag:) forControlEvents:UIControlEventTouchDragInside];
            


            [backScroll addSubview:buton];
            
//            buton.userInteractionEnabled = NO;
//            backScroll.userInteractionEnabled = YES;
            
        }
        UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]init];
        panGesture.delegate = self;
        [self addGestureRecognizer:panGesture];
//        //右划
//        UISwipeGestureRecognizer *swipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGesture:)];
//      [backScroll addGestureRecognizer:swipeGesture];
//      //左划
//        UISwipeGestureRecognizer *swipeLeftGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGesture:)];
//        swipeGesture.direction=UISwipeGestureRecognizerDirectionLeft;//不设置黑夜是右
//        [backScroll addGestureRecognizer:swipeLeftGesture];
    }
    return self;
}

- (void)butonPress:(UIButton*)sender
{
    for (UIView* aview in backScroll.subviews )
    {
        if ([aview isKindOfClass:[UIButton class]]) {
            aview.backgroundColor = [UIColor clearColor];
        }
    }
    sender.backgroundColor = [UIColor redColor];
}
//- (void)butonDrag:(UIButton*)sender
//{
//    [sender touchesMoved:[NSSet setWithObject:sender.superview] withEvent:UIControlEventTouchDragInside];
////    for (UIView* aview in backScroll.subviews )
////    {
////        if ([aview isKindOfClass:[UIButton class]]) {
////            aview.backgroundColor = [UIColor clearColor];
////        }
////    }
////    sender.backgroundColor = [UIColor redColor];
//}

#pragma mark Scrolleview
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll");
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] || [gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        return YES;
    }
    UIView* touchedView = [touch view];
    if([touchedView isKindOfClass:[UIButton class]]) {
        
        return NO;
    }
    
    return YES;
}


@end
