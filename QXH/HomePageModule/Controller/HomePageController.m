//
//  HomePageController.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-4.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "HomePageController.h"
#import "OneDreamController.h"
#import "SquareViewController.h"
#import "EverydayAskController.h"
#import "InfluenceViewController.h"
#import "InformationViewController.h"
#import "FindPeopleViewController.h"
#import "ActivityViewController.h"
#import "TribeController.h"
#import "chatRoomActivViewController.h"


@interface HomePageController ()
{
    NSArray *pics;
}

@end

@implementation HomePageController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = NO;
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.titleView = _topView;
    pics = @[@"banner_img02", @"banner_img01"];
    _topScroll.contentSize = CGSizeMake(320*pics.count, 132);
    [self addTopImage];
}

- (void)addTopImage
{
    for (int i = 0; i < pics.count; i++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 132)];
        image.image = [UIImage imageNamed:pics[i]];
        [_topScroll addSubview:image];
    }
    [_topScroll bringSubviewToFront:_pageControl];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage = (int)scrollView.contentOffset.x/320;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClick:(id)sender {
    
    UIButton *btn  = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            NSLog(@"点击资讯");
            InformationViewController* ainfor = [[InformationViewController alloc]initWithNibName:@"InformationViewController" bundle:nil];
            ainfor.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ainfor animated:YES];
        }
            break;
        case 2:
        {
            NSLog(@"点击活动");
//            ActivityController *aController = [[ActivityController alloc] initWithNibName:@"ActivityController" bundle:nil];
//            [self.navigationController pushViewController:aController animated:YES];
            ActivityViewController *activeCon = [[ActivityViewController alloc] init];
            activeCon.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:activeCon animated:YES];
        }
            break;
        case 3:
        {
            NSLog(@"点击找人");
//            FindPeopleController *fpController = [[FindPeopleController alloc] initWithNibName:@"FindPeopleController" bundle:nil];
//            [self.navigationController pushViewController:fpController animated:YES];
            
            FindPeopleViewController *fpController = [[FindPeopleViewController alloc] init];
            fpController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fpController animated:YES];
        }
            break;
        case 4:
        {
            NSLog(@"点击直播间");
            OneDreamController *odController = [[OneDreamController alloc] initWithNibName:@"OneDreamController" bundle:nil];
            odController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:odController animated:YES];
        }
            break;
        case 5:
        {
            NSLog(@"点击部落");
            TribeController *tribeVC = [[TribeController alloc] init];
            tribeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:tribeVC animated:YES];
        }
            break;
        case 6:
        {
            NSLog(@"点击广场");
            SquareViewController *svController = [[SquareViewController alloc] initWithNibName:@"SquareViewController" bundle:nil];
            svController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:svController animated:YES];
        }
            break;
        case 7:
        {
            NSLog(@"点击每日一问");
            EverydayAskController *eaController = [[EverydayAskController alloc] initWithNibName:@"EverydayAskController" bundle:nil];
            eaController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:eaController animated:YES];
        }
            break;
        case 8:
        {
            NSLog(@"点击影响力");
//            InfluenceViewController *ivController = [[InfluenceViewController alloc] initWithNibName:@"InfluenceViewController" bundle:nil];
//            ivController.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:ivController ani
//            ChatController *controller = [[ChatController alloc] initWithCustomView:tempView];
            
            
            ChatController *controller = [[ChatController alloc]init];
           
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
//            chatRoomActivViewController* chatroomactive = [[chatRoomActivViewController alloc]init];
//            [self.view addSubview:chatroomactive.view];
////            [self.navigationController pushViewController:chatroomactive animated:YES];
        }
            break;
        default:
            break;
    }
    
}

//#pragma mark chatcontroller
//- (void) chatController:(ChatController *)chatController didSendMessage:(NSMutableDictionary *)message
//{
//    // Messages come prepackaged with the contents of the message and a timestamp in milliseconds
//    //    NSLog(@"Message Contents: %@", message[kMessageContent]);
//    NSLog(@"Timestamp: %@", message[kMessageTimestamp]);
//    
//    // Evaluate or add to the message here for example, if we wanted to assign the current userId:
//    message[@"sentByUserId"] = @"currentUserId";
//    icout++;
//    
//    message[@"kMessageRuntimeSentBy"] = [NSNumber numberWithInt:((icout%2)?kSentByUser:kSentByOpponent)];
//    
//    // Must add message to controller for it to show
//    [chatController addNewMessage:message];
//}


@end
