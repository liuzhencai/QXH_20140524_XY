//
//  OneDreamController.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-4.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "OneDreamController.h"
#import "ActivityCell.h"
#import "OnLiveCell.h"
#import "ChatLiveViewController.h"

@interface OneDreamController ()
@property (nonatomic, strong) NSMutableArray *activitysList;//活动列表
@end

@implementation OneDreamController
@synthesize tableview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        _activitysList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:TYPE_LOOK_STUDIO];
    [MobClick beginEvent:TYPE_LOOK_STUDIO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:TYPE_LOOK_STUDIO];
    [MobClick endEvent:TYPE_LOOK_STUDIO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"直播间";
    
    self.tableview.backgroundColor = [UIColor clearColor];
    
//    for (int i = 0; i < 10; i ++) {
//        [self.activitysList addObject:@{@"":@""}];
//    }
    
    [self getActivitysList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getActivitysList{
    /**
     *  获取部落/群组/直播间列表
     *
     *  @param type      1为获取已加入的部落列表，2为搜索相关部落列表(为2时读取下列条件)
     *  @param tribename 部落名称
     *  @param authflag  0为全部，1为普通部落，2为官方认证部落
     *  @param tribetype 1为部落，2为直播间
     *  @param tag       搜索是只允许单个标签搜索
     *  @param district  地域信息
     *  @param start     起始位置
     *  @param count     获取数量
     *  @param callback  回调
     */
    [DataInterface requestTribeList:@""
                          tribename:@""
                           authflag:@"0"
                             status:@"0"
                          tribetype:@"2" //1为部落，2为直播间
                                tag:@""
                           district:@""
                              start:@"0"
                              count:@"20"
              withCompletionHandler:^(NSMutableDictionary *dict){
                  NSLog(@"部落列表返回值：%@",dict);
                  NSNumber* statecode = (NSNumber*)dict[@"statecode"];
                  if ([statecode integerValue] == 200) {
                      NSMutableArray* list = (NSMutableArray*)dict[@"list"];
                      if ([list count]>0) {
                          _activitysList = [[NSMutableArray alloc]initWithArray:list];
                          [self.tableview reloadData];
                      }
                      
                  }else{
                      NSString* info = (NSString*)dict[@"info"];
                      [self showAlert:info];
                  }
//                  [self showAlert:[dict objectForKey:@"info"]];
              }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.activitysList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ActivityCell *cell;
//    static NSString *cellIdentifier = @"ActivityIdentifier";
//    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityCell" owner:nil options:nil] objectAtIndex:0];
//    }
    OnLiveCell *cell;
    static NSString *cellIdentifier = @"ActivityIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[OnLiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell resetCellParamDict:[_activitysList objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic = (NSDictionary*)[_activitysList objectAtIndex:indexPath.row];
    ChatLiveViewController* chatlive = [[ChatLiveViewController alloc]init];
    chatlive.tribeInfoDict = dic;
    [self.navigationController pushViewController:chatlive animated:NO];
}

#pragma mark chatcontroller
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
//    [_chatController addNewMessage:message];
//}

/*!
 Close Chat Controller - Will Dismiss If Nothing Selected
 */
//- (void) closeChatController:(ChatController *)chatController
//{
////    [chatController dismissViewControllerAnimated:YES completion:^{
////        [chatController removeFromParentViewController];
//////        chatController = nil;
////    }];
//}
@end
