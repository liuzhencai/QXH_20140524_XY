//
//  AddressListsViewController.m
//  QXH
//
//  Created by XueYong on 5/18/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddrListCell.h"
#import "MyMsgCell.h"
#import "LoginViewController.h"
#import "NameCardViewController.h"
#import "PeocelCell.h"
#import "MyMessageCell.h"
#import "CustomSegmentControl.h"
#import "ChatViewController.h"
#import "MessageBySend.h"

@interface AddressListViewController ()<CustomSegmentControlDelegate>
@property (nonatomic, assign) int selectIndex;
@property (nonatomic, strong) NSMutableArray *addressList;//通讯录列表
@property (nonatomic, strong) NSMutableArray *myMessageList;//我的消息列表

@end

#define ADDRESS_LIST_TABLE_TAG 2330  //通讯录tag
#define MY_MESSAGE_LIST_TABLE_TAG 2331 //我的消息tag

@implementation AddressListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _selectIndex = 1;
        _addressList = [[NSMutableArray alloc] initWithCapacity:0];
        _myMessageList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //登陆
    [self getAddressList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.hidesBottomBarWhenPushed = NO;
    // Do any additional setup after loading the view from its nib.
    self.title = @"通讯录";
    
    //segment
    CustomSegmentControl *segment = [[CustomSegmentControl alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 32) andTitles:@[@"通讯录",@"我的消息"]];
    segment.delegate = self;
    [self.view addSubview:segment];
    
    //table
    UITableView *myMessageTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_TAB_BAR_HEIGHT - 32) style:UITableViewStylePlain];
    myMessageTable.tag = MY_MESSAGE_LIST_TABLE_TAG;
    myMessageTable.delegate = self;
    myMessageTable.dataSource = self;
    myMessageTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myMessageTable];
    
    UITableView *addressListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_TAB_BAR_HEIGHT - 32) style:UITableViewStylePlain];
    addressListTable.tag = ADDRESS_LIST_TABLE_TAG;
    addressListTable.delegate = self;
    addressListTable.dataSource = self;
    addressListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:addressListTable];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, UI_SCREEN_WIDTH, 44.0f)];
    self.searchBar.placeholder = @"输入名字查找朋友";
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    addressListTable.tableHeaderView = self.searchBar;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMessage:) name:@"addFirend" object:nil];
    
    // Create the search display controller
    //    self.searchDC = [[[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self] autorelease];
    //    self.searchDC.searchResultsDataSource = self;
    //    self.searchDC.searchResultsDelegate = self;
    
//    [self getAddressList];
}

#pragma mark 获取到推送消息
- (void)reloadeChatRoom:(NSNotification*)chatmessage
{
    NSLog(@"reloadeChatRoom");
    NSMutableDictionary *auserinfo = [[NSMutableDictionary alloc]initWithDictionary:(NSDictionary*)[chatmessage valueForKey:@"userInfo"]];
    //    NSDictionary* auserinfo = (NSDictionary*)[chatmessage valueForKey:@"userInfo"];
    
    NSLog(@"接受到的信息:%@",auserinfo);
}


- (void)getAddressList{
    /**
     *  获取好友(通讯录)/查找用户列表公用接口
     *
     *  @param type        1为获取好友列表，2为搜索
     *  @param address     籍贯编码
     *  @param domicile    居住地编码
     *  @param displayname 昵称
     *  @param usertype    用户类型,为空时不区分类型
     *  @param start       起始位置
     *  @param count       获取数量
     *  @param callback    回调
     */
    
    [DataInterface getFriendInfo:@"1"
                         address:@""
                        domicile:@""
                     displayname:@""
                        usertype:@""
                           start:@"0"
                           count:@"20"
           withCompletionHandler:^(NSMutableDictionary *dict){
               NSLog(@"通讯录列表返回数据：%@",dict);

               if (dict) {
                   NSArray *list = [dict objectForKey:@"lists"];
                   self.addressList = [NSMutableArray arrayWithArray:list];
                   UITableView *table = (UITableView *)[self.view viewWithTag:ADDRESS_LIST_TABLE_TAG];
                   [table reloadData];
               }
           }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CustomSegmentControlDelegate
- (void)segmentClicked:(NSInteger)index{
    NSLog(@"segment clicked:%d",index);
    NSInteger tag = ADDRESS_LIST_TABLE_TAG + index;
    UITableView *table = (UITableView *)[self.view viewWithTag:tag];
    [self.view bringSubviewToFront:table];

    if (index == 1) {
        /**
         *  获取登录消息
         *  @param callback 获取登陆消息（此接口为用户登陆成功后调用，用户获取在用户离线期间收到的消息）
         */
//        [DataInterface getLoginInfoWithCompletionHandler:^(NSMutableDictionary *dict){
//            NSLog(@"获取登录信息：%@",dict);
//            if (dict) {
//                NSArray *officials = [dict objectForKey:@"official"];
//                NSArray *chats = [dict objectForKey:@"chat"];
//                self.myMessageList = [NSMutableArray arrayWithCapacity:0];
//                if ([officials count]) {
//                    [self.myMessageList addObject:@{@"name":@"official",@"list":officials}];
//                }
//                if ([chats count]) {
//                    [self.myMessageList addObject:@{@"name":@"chats",@"list":chats}];
//                }
//                [table reloadData];
//            }
//        }];
//        recvRemoteNoficationWithCompletionHandler
        
//        [MessageBySend sharMessageBySend];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == ADDRESS_LIST_TABLE_TAG) {
        return [self.addressList count];
    }else{
        return [self.myMessageList count];
    }
//    return [self.myMessageList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == ADDRESS_LIST_TABLE_TAG) {
        NSDictionary *dict = [self.addressList objectAtIndex:section];
        NSArray *list = [dict objectForKey:@"list"];
        return [list count];
    }else{
        NSDictionary *dict = [self.myMessageList objectAtIndex:section];
        NSArray *list = [dict objectForKey:@"list"];
        return [list count];
//        return [self.myMessageList count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
//    if (tableView.tag == ADDRESS_LIST_TABLE_TAG) {
//        return 20;
//    }else{
//        return 0;
//    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (tableView.tag == ADDRESS_LIST_TABLE_TAG) {
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
        bgView.image = [UIImage imageNamed:@"bar_transition"];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 20)];

        title.backgroundColor = [UIColor clearColor];
    
        NSDictionary *dict = nil;
        if (tableView.tag == ADDRESS_LIST_TABLE_TAG) {
            dict = [self.addressList objectAtIndex:section];
        }else{
            dict = [self.myMessageList objectAtIndex:section];
        }
        if (dict) {
            NSString *titleStr = [dict objectForKey:@"name"];
            title.text = titleStr;
        }
        [bgView addSubview:title];
        return bgView;
//    }
//    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (tableView.tag == MY_MESSAGE_LIST_TABLE_TAG) {
        static NSString *myMsgIdentifier = @"myMsgIdentifier";
        MyMessageCell *myMsgCell = nil;
        myMsgCell = [tableView dequeueReusableCellWithIdentifier:myMsgIdentifier];
        if (!myMsgCell) {
            myMsgCell = [[MyMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myMsgIdentifier];
            myMsgCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (self.myMessageList) {
            NSDictionary *dict = [self.myMessageList objectAtIndex:indexPath.section];
            NSArray *list = [dict objectForKey:@"list"];
            NSDictionary *address = [list objectAtIndex:indexPath.row];
            [myMsgCell resetCellParamDict:address];
        }

        cell = myMsgCell;
    }else if(tableView.tag == ADDRESS_LIST_TABLE_TAG){
        static NSString *addrIdentifier = @"addrListIdentifier";
        PeocelCell *addrListCell = nil;
        addrListCell = [tableView dequeueReusableCellWithIdentifier:addrIdentifier];
        if (!addrListCell) {
            addrListCell = [[PeocelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addrIdentifier];
            addrListCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
       
        if (self.addressList) {
            NSDictionary *dict = [self.addressList objectAtIndex:indexPath.section];
            NSArray *list = [dict objectForKey:@"list"];
            NSDictionary *address = [list objectAtIndex:indexPath.row];
            [addrListCell resetCellParamDict:address];
        }

        cell = addrListCell;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == ADDRESS_LIST_TABLE_TAG) {
        NSLog(@"点击通讯录第%d部分第%d行", indexPath.section, indexPath.row);
        NSDictionary *dict = [self.addressList objectAtIndex:indexPath.section];
        NSArray *list = [dict objectForKey:@"list"];

        NSDictionary *item = [list objectAtIndex:indexPath.row];
        NSLog(@"联系人信息%@",item);
        if (self.addressListBlock) {
            self.addressListBlock(item);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NameCardViewController *nameCard = [[NameCardViewController alloc] init];
            nameCard.isMyFriend = YES;
            nameCard.memberDict = item;
            [self.navigationController pushViewController:nameCard animated:YES];
        }
    }else if(tableView.tag == MY_MESSAGE_LIST_TABLE_TAG){
        NSLog(@"点击我的消息第%d行", indexPath.row);
//        ChatViewController *chat = [[ChatViewController alloc] init];
//        [self.navigationController pushViewController:chat animated:YES];
        NSDictionary *dict = [self.addressList objectAtIndex:indexPath.section];
        NSArray *list = [dict objectForKey:@"list"];
        NSDictionary *item = [list objectAtIndex:indexPath.row];
        NameCardViewController *nameCard = [[NameCardViewController alloc] init];
        nameCard.memberDict = item;
        nameCard.isMyFriend = YES;
        [self.navigationController pushViewController:nameCard animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
}

@end
