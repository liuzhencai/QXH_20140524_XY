//
//  MyTribeController.m
//  QXH
//
//  Created by ZhaoLilong on 5/14/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "MyTribeController.h"
#import "TribeDynamicViewController.h"
#import "ChatRoomController.h"

@interface MyTribeController ()
{
    NSMutableArray *mytribes;
    NSMutableArray *tribeList;
}
@end

@implementation MyTribeController

- (void)getMyTribeList
{
    [DataInterface requestTribeList:@"1" tribename:@"" authflag:@"0" status:@"0" tribetype:@"1" tag:@"" district:@"" start:@"0" count:@"20" withCompletionHandler:^(NSMutableDictionary *dict) {
//        [self showAlert:[dict description]];
        mytribes = [ModelGenerator json2TribeList:dict];
        tribeList = [dict objectForKey:@"list"];
        [_mytribeTbl reloadData];
    }];
}

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
    // Do any additional setup after loading the view from its nib.
    self.title = @"加入的部落";
    
    [self getMyTribeList];
     chatview =[[ChatRoomController alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mytribes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"myTribe";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyTribeCell" owner:nil options:nil] objectAtIndex:0];
    }
    MyTribeModel *model = [mytribes objectAtIndex:indexPath.row];
    [(MyTribeCell *)cell setModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    TribeDynamicViewController *controller = [[TribeDynamicViewController alloc]init];
//    controller.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:controller animated:YES];
    NSDictionary *tribeDict = [tribeList objectAtIndex:indexPath.row];
    chatview.tribeInfoDict = tribeDict;
    [self.navigationController pushViewController:chatview animated:NO];
}

@end
