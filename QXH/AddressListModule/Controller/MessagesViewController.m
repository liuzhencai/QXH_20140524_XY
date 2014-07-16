//
//  MessagesViewController.m
//  QXH
//
//  Created by XueYong on 7/8/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "MessagesViewController.h"
#import "MessageDetailCell.h"
#import "MessageBySend.h"

@interface MessagesViewController ()<UITableViewDataSource,UITableViewDelegate,MessageDetailDelegate>
@property (nonatomic, strong) UITableView *mainTable;
@end

@implementation MessagesViewController

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
    self.title = @"系统消息";
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_mainTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 2;
    return [self.messagesList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.messagesList objectAtIndex:indexPath.row];
    int sendType = [[dict objectForKey:@"sendtype"] intValue];
    if (sendType == 3 || sendType == 5) {
        return 160;
    }
    return 160 - 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *identifier1 = @"cellId1";
        MessageDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell) {
            cell = [[MessageDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
    if (self.messagesList) {
        NSDictionary *dict = [self.messagesList objectAtIndex:indexPath.row];
        [cell resetCellParamDict:dict];
//        CGRect rect = CGRectMake(0, 0, UI_SCREEN_WIDTH, 160);
        int sendType = [[dict objectForKey:@"sendtype"] intValue];
        if (sendType == 3 || sendType == 5) {
            
        }
    }
//        NSDictionary *dict = [self.messagesList objectAtIndex:indexPath.row];
//        cell.titleLabel.text = [dict objectForKey:@"city"];
        return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - MessageDetailDelegate
//- (void)selectButtonWithIndex:(int)index{
//    NSLog(@"%d",index);
//    UITableViewCell *cell = [];
//}
- (void)selectButtonWithCell:(MessageDetailCell *)cell atIndex:(int)index{
    NSLog(@"%@,%d",cell,index);
    NSIndexPath *indexPath = (NSIndexPath *)[_mainTable indexPathForCell:cell];
    NSDictionary *dict = [self.messagesList objectAtIndex:indexPath.row];
    NSLog(@"%@",dict);
    int stauts = [[dict objectForKey:@"sendtype"] intValue];
    NSString *memberId = [dict objectForKey:@"senderid"];
    if (index == 0) {
        if (stauts == 3) {
            /**
             *  加好友确认/修改备注
             *  @param targetid 被处理的加入成员的userid
             *  @param type     0为同意并添加对方为好友(备注不为空添加备注)，1为同意但不添加对方为好友，2为拒绝，3为修改备注
             *  @param remark   备注
             *  @param callback 回调
             */
            [DataInterface addFriendConfirm:memberId type:@"1" remark:@"" withCompletionHandler:^(NSMutableDictionary *dict){
                NSLog(@"%@",dict);
                [self showAlert:[dict objectForKey:@"info"]];
            }];
        }
        if (stauts == 5) {
            /**
             *  部落创建者/秘书长处理加入部落请求
             *  @param tribeid  部落唯一标示
             *  @param targetid 被处理的加入成员的userid
             *  @param flag     允许标示：1为允许加入，2为拒绝加入
             *  @param callback 回调
             */
            NSString *tribeId = [dict objectForKey:@"tribeid"];
            [DataInterface dealAddTribeRequest:tribeId targetid:memberId permitflag:@"1" withCompletionHandler:^(NSMutableDictionary *dict){
                NSLog(@"%@",dict);
                [self showAlert:[dict objectForKey:@"info"]];
            }];
        }
    }else{
        if (stauts == 3) {
            [DataInterface addFriendConfirm:memberId type:@"2" remark:@"" withCompletionHandler:^(NSMutableDictionary *dict){
                NSLog(@"%@",dict);
                [self showAlert:[dict objectForKey:@"info"]];
                NSMutableDictionary *messageDict = [[MessageBySend sharMessageBySend] getunKnowCharMessDic];
                NSMutableArray *arr = [messageDict objectForKey:[NSString stringWithFormat:@"%d",stauts]];
                for (int i = 0; i < [arr count]; i ++) {
                    
                    NSLog(@"");
                }
            }];
        }
        
        if (stauts == 5) {
            NSString *tribeId = [dict objectForKey:@"tribeid"];
            [DataInterface dealAddTribeRequest:tribeId targetid:memberId permitflag:@"2" withCompletionHandler:^(NSMutableDictionary *dict){
                NSLog(@"%@",dict);
                [self showAlert:[dict objectForKey:@"info"]];
            }];
        }
        
    }
}


@end
