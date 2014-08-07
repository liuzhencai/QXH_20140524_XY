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
//#import "ChatViewController.h"
#import "MessageBySend.h"
#import "MessagesViewController.h"
#import "ChatController.h"
#import "ChatRoomController.h"
#import "FindAddressResultViewController.h"

#import "ChineseToPinyin.h"

@interface AddressListViewController ()<CustomSegmentControlDelegate,UISearchBarDelegate,MessagesDelegate>
@property (nonatomic, strong) UITableView *messageTable;
@property (nonatomic, assign) int selectIndex;
@property (nonatomic, strong) NSMutableArray *addressList;//通讯录列表
@property (nonatomic, strong) NSMutableArray *myMessageList;//我的消息列表
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, assign) NSInteger curIndex;//当前下标

@property (nonatomic, strong) NSMutableArray *lastMessages;//上次查看的消息
@property (nonatomic, strong) NSMutableDictionary *dealMessages;//处理过的消息（加好友，加入部落）
@property (nonatomic, strong) NSMutableArray *searchMyFriends;//搜索结果



//排序
@property (nonatomic, strong) NSArray *myFriendsList;
@property (nonatomic, strong) NSMutableDictionary *addressDict;//好友信息
@property (nonatomic, strong) NSArray *addressIndexArray;//索引
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
        _lastMessages = [[NSMutableArray alloc] initWithCapacity:0];
        _dealMessages = [[NSMutableDictionary alloc] initWithCapacity:0];
        NSMutableArray *agreeList = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *refuseList = [[NSMutableArray alloc] initWithCapacity:0];
        [_dealMessages setObject:agreeList forKey:@"agreeList"];
        [_dealMessages setObject:refuseList forKey:@"refuseList"];
        _curIndex = 0;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //登陆
    if (_curIndex == 0) {
        [self getAddressList];
    }
    
    /*获取系统推送的聊天数据*/
    [self getChatMessInfo];
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
    
    UILabel *tipCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 5, 20, 20)];
    tipCountLabel.layer.cornerRadius = tipCountLabel.width/2.0;
    tipCountLabel.layer.backgroundColor = [UIColor redColor].CGColor;
    self.tipLabel = tipCountLabel;
    tipCountLabel.font = [UIFont systemFontOfSize:12];
    tipCountLabel.textAlignment = NSTextAlignmentCenter;
    tipCountLabel.textColor = [UIColor whiteColor];
    tipCountLabel.text = @"5";
    tipCountLabel.backgroundColor = [UIColor clearColor];
    [segment addSubview:tipCountLabel];
    [self resetTipLabelWithMessage:self.myMessageList];
    
    //table
    myMessageTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_TAB_BAR_HEIGHT - 32) style:UITableViewStylePlain];
    myMessageTable.tag = MY_MESSAGE_LIST_TABLE_TAG;
    self.messageTable = myMessageTable;
    myMessageTable.delegate = self;
    myMessageTable.dataSource = self;
    myMessageTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myMessageTable];
    
    addressListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_TAB_BAR_HEIGHT - 32) style:UITableViewStylePlain];
    addressListTable.tag = ADDRESS_LIST_TABLE_TAG;
    addressListTable.delegate = self;
    addressListTable.dataSource = self;
    addressListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:addressListTable];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, UI_SCREEN_WIDTH, 44.0f)];
    self.searchBar.placeholder = @"输入名字查找朋友";
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.delegate = self;
    addressListTable.tableHeaderView = self.searchBar;
     self.navigationItem.leftBarButtonItem = nil;
    //暂时屏蔽
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMessage:) name:@"addFirend" object:nil];
    
    /*系统推送聊天接口*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadeChatMessInfo:) name:@"reloadeChatMessInfo" object:nil];
    // Create the search display controller
    //    self.searchDC = [[[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self] autorelease];
    //    self.searchDC.searchResultsDataSource = self;
    //    self.searchDC.searchResultsDelegate = self;
    
//    [self getAddressList];
}

- (void)resetTipLabelWithMessage:(NSMutableArray *)messagesList{
    int count = 0;
    for (int i = 0; i < [messagesList count]; i ++) {
        NSArray *list = [messagesList objectAtIndex:i];
        NSDictionary *messageDict = [list lastObject];
        NSInteger sendtype = [[messageDict objectForKey:@"sendtype"] integerValue];
        if (sendtype != 1 && sendtype != 2) {
            int newCount = 0;
            for (int i = 0; i < [list count]; i ++) {
                NSDictionary *newDict = [list objectAtIndex:i];
                NSInteger newMessid = [[newDict objectForKey:@"messid"] integerValue];
                BOOL isNew = YES;
                for (int j = 0; j < [self.lastMessages count]; j ++) {
                    NSDictionary *oldDict = [self.lastMessages objectAtIndex:j];
                    NSInteger oldMessid = [[oldDict objectForKey:@"messid"] integerValue];
                    if (newMessid == oldMessid) {
                        isNew = NO;
                        break;
                    }
                }
                if (isNew) {
                    newCount ++;
                }
            }
            count += newCount;
        }else{
            NSDictionary *messageDict = [list lastObject];
            NSInteger chatsCount = [[messageDict objectForKey:@"count"] integerValue];
            count += chatsCount;
//            count += [list count];
        }
    }
    if (count == 0) {
        self.tipLabel.hidden = YES;
        self.tipLabel.text = @"0";//[NSString stringWithFormat:@"%d",count];
    }else{
        self.tipLabel.hidden = NO;
        if (count > 99) {
            self.tipLabel.text = [NSString stringWithFormat:@"99+"];
        }else{
            self.tipLabel.text = [NSString stringWithFormat:@"%d",count];
        }
    }
}

#pragma mark 获取到推送消息
- (void)reloadMessage:(NSNotification*)chatmessage
{
    NSLog(@"addFirend");
    NSMutableDictionary *auserinfo = [[NSMutableDictionary alloc]initWithDictionary:(NSDictionary*)[chatmessage valueForKey:@"userInfo"]];
    NSLog(@"接受到的信息:%@",auserinfo);
//    [self.myMessageList addObject:auserinfo];
//    [_messageTable reloadData];
    
    NSMutableArray *systemArr = [[NSMutableArray alloc] initWithArray:[auserinfo allValues]];
    self.myMessageList = systemArr;
    [self resetTipLabelWithMessage:self.myMessageList];
    [_messageTable reloadData];
}

#pragma mark 系统推送的部落聊天或者私聊接口
/*系统推送的部落聊天或者私聊接口*/
- (void)reloadeChatMessInfo:(NSNotification*)chatmessage
{
    NSLog(@"chatmessage==%@",chatmessage);
//    NSMutableArray* keys = [chatmessage ]
//    NSMutableDictionary *messDic = [[NSMutableDictionary alloc]initWithDictionary:(NSDictionary*)[chatmessage valueForKey:@"userInfo"]];
    NSMutableDictionary* achatmessage = (NSMutableDictionary*)[chatmessage valueForKey:@"userInfo"];


    NSArray* values = [achatmessage  allValues];
    _myMessageList = [[NSMutableArray alloc]initWithArray:values];

//    NSMutableArray* values = (NSMutableArray*)[achatmessage  allValues];
//    NSLog(@"%@",values);
//    
//    self.myMessageList = [[NSMutableArray alloc]initWithArray:values];
    [self resetTipLabelWithMessage:_myMessageList];

    [myMessageTable reloadData];

}

#pragma mark 主动获取部落聊天或者私聊接口
- (void)getChatMessInfo
{
    NSLog(@"getChatMessInfo\n");
    NSMutableDictionary* messagedic = [[MessageBySend sharMessageBySend]getunKnowCharMessDic];

    NSMutableArray* values = (NSMutableArray*)[messagedic  allValues];
    if ([values count]) {
        self.myMessageList = [[NSMutableArray alloc]initWithArray:values];
        [self resetTipLabelWithMessage:self.myMessageList];
        [myMessageTable reloadData];
    }

    //
    //    NSLog(@"接受到的信息:%@",auserinfo);
    //    [self.myMessageList addObject:auserinfo];
    //    [_messageTable reloadData];
}

- (void)getAddressList{
    /**
     *  获取好友(通讯录)/查找用户列表公用接口
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
                           count:@"100"
           withCompletionHandler:^(NSMutableDictionary *dict){
               NSLog(@"通讯录列表返回数据：%@",dict);

               if (dict) {
                   NSArray *lists = [dict objectForKey:@"lists"];
                   self.addressList = [NSMutableArray arrayWithArray:lists];
                   
                   NSDictionary *tmpdict = [lists objectAtIndex:0];
                   NSArray *list = [tmpdict objectForKey:@"list"];
                   self.myFriendsList = [NSMutableArray arrayWithArray:list];
                   
                   self.addressDict = [self sortArrayWithArray:self.myFriendsList];
                   self.addressIndexArray = [self getIndexesByTribes:self.addressDict];
                   
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

#pragma mark - sort
- (NSMutableDictionary *)sortArrayWithArray:(NSArray *)list{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < [list count]; i ++) {
        NSDictionary *cityDict = list[i];
        //得到拼音首字母
        NSString *letter = [ChineseToPinyin firstPinyinCharacter:cityDict[@"displayname"]];
        if ([letter compare:@"A"] == NSOrderedAscending || [letter compare:@"Z"] == NSOrderedDescending) {
            letter = @"#";
            NSMutableArray *array = [dict valueForKey:letter];
            if (!array){
                array = [NSMutableArray array];
                [dict setObject:array forKey:letter];
            }
            [array addObject:cityDict];
        }
        else {
            letter = [letter uppercaseString];
            NSMutableArray *array = [dict valueForKey:letter];
            if (!array){
                array = [NSMutableArray array];
                [dict setObject:array forKey:letter];
            }
            [array addObject:cityDict];
        }
    }
    
    //    NSLog(@"拍好后：%@",dict);
    return dict;
}

//获取排序过的索引
- (NSArray *)getIndexesByTribes:(NSMutableDictionary *)dict{
    NSArray *sortIndexArray = [dict allKeys];
    sortIndexArray = [sortIndexArray sortedArrayUsingSelector:@selector(compare:)];
    return sortIndexArray;
}

//type 1:我的好友  2:----
-(NSArray *)sortWithSection:(NSInteger)section withType:(int)type {
    NSArray *array;
    if (type == 1) {//我的好友
        array = _addressIndexArray;
        if(section != -1){
            NSString *key = [_addressIndexArray objectAtIndex:section];
            //        if ([key isEqualToString:HOT_CITY_NOASTR]) {
            //            key = HOT_CITY_STR;
            //        }
            array = [_addressDict objectForKey:key];
        }
    }
    else {//----
    }
    return array;
}


#pragma mark - CustomSegmentControlDelegate
- (void)segmentClicked:(NSInteger)index{
    NSLog(@"segment clicked:%d",index);
    [self.searchBar resignFirstResponder];
    NSInteger tag = ADDRESS_LIST_TABLE_TAG + index;
    UITableView *table = (UITableView *)[self.view viewWithTag:tag];
    [self.view bringSubviewToFront:table];

    _curIndex = index;
    if (index == 1) {
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == ADDRESS_LIST_TABLE_TAG) {
        return [self.addressDict count];
//        return [self.addressList count];
    }else{
//        return [self.myMessageList count];
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == ADDRESS_LIST_TABLE_TAG) {
        return [[self sortWithSection:section withType:1] count];
//        NSDictionary *dict = [self.addressList objectAtIndex:section];
//        NSArray *list = [dict objectForKey:@"list"];
//        return [list count];
    }else{
//        NSDictionary *dict = [self.myMessageList objectAtIndex:section];
//        NSArray *list = [dict objectForKey:@"list"];
//        return [list count];
        return [_myMessageList count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 20;
    if (tableView.tag == ADDRESS_LIST_TABLE_TAG) {
        return 22;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == ADDRESS_LIST_TABLE_TAG) {
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 22)];
        bgView.image = [UIImage imageNamed:@"bar_transition"];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 22)];
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont systemFontOfSize:16];
        title.textColor = GREEN_FONT_COLOR;
        title.text = [[self sortWithSection:-1 withType:1] objectAtIndex:section];
//        NSDictionary *dict = [self.addressList objectAtIndex:section];
//        if (dict) {
//            NSString *titleStr = [dict objectForKey:@"name"];
//            title.text = titleStr;
//        }
        
        [bgView addSubview:title];
        return bgView;
    }
    return nil;
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
            NSDictionary *dict = [self.myMessageList objectAtIndex:indexPath.row];
            myMsgCell.lastMessages = self.lastMessages;
            [myMsgCell resetCellParamDict:dict];
//        NSInteger arow = indexPath.row;
//        if ([self.myMessageList count]) {
//            NSMutableArray* temparray = (NSMutableArray*)[self.myMessageList objectAtIndex:arow];
////            NSDictionary *dict = 
//            [myMsgCell resetCellParamDict:temparray];
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
       
        if (self.addressDict) {
            NSDictionary *address = [[self sortWithSection:indexPath.section withType:1] objectAtIndex:indexPath.row];
            [addrListCell resetCellParamDict:address];
        }

//        if (self.addressList) {
//            NSDictionary *dict = [self.addressList objectAtIndex:indexPath.section];
//            NSArray *list = [dict objectForKey:@"list"];
//            NSDictionary *address = [list objectAtIndex:indexPath.row];
//            [addrListCell resetCellParamDict:address];
//        }

        cell = addrListCell;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    if (tableView.tag == ADDRESS_LIST_TABLE_TAG) {
        NSLog(@"点击通讯录第%d部分第%d行", indexPath.section, indexPath.row);
//        NSDictionary *dict = [self.addressList objectAtIndex:indexPath.section];
//        NSArray *list = [dict objectForKey:@"list"];
//        NSDictionary *item = [list objectAtIndex:indexPath.row];
        NSDictionary *item = [[self sortWithSection:indexPath.section withType:1] objectAtIndex:indexPath.row];
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
        id objct = [_myMessageList objectAtIndex:indexPath.row];
        
        if ([objct isKindOfClass:[NSMutableArray class]]) {
            NSMutableArray* temp = (NSMutableArray*)objct;
            NSMutableDictionary* message = (NSMutableDictionary*)[temp lastObject];
            /*聊天数据*/
            NSNumber*  asendtype = (NSNumber*)[message valueForKey:@"sendtype"];
            NSString* bsendtype =[NSString stringWithFormat:@"%d",[asendtype intValue]];
            if ([bsendtype isEqualToString:@"1"])
            {

                /*
                 displayname = "\U5218\U6b63\U624d111";
                 level = 1;
                 online = 0;
                 photo = "20140629/0034251930.png";
                 remark = "";
                 signature = jintiankenkuaile;
                 userid = 100069;
                 username = "";
                 usertype = 1;*/
                NSNumber* ntribeid = (NSNumber*)[message valueForKey:@"senderid"];
                NSString* atribeid = [NSString stringWithFormat:@"%d",[ntribeid intValue]];
                 chat = [[ChatController alloc]init];
                
                [DataInterface getUserInfo:atribeid withCompletionHandler:^(NSMutableDictionary* dic){
                    /*私聊*/
                   
                    NSMutableDictionary* tempdic = [[NSMutableDictionary alloc]initWithDictionary:dic];
                    tempdic[@"userid"]=ntribeid;
                    /*私聊对方信息*/
                    chat.otherDic = tempdic;
                     [self.navigationController pushViewController:chat animated:NO];
                    
//                    /*如果count值大于数组个数，则有离线消息*/
//                    NSNumber* acount = [message valueForKey:@"count"];
//                    NSInteger bcount = [acount integerValue];
//                    if (bcount >=[temp count]) {
//                        /*获取所有离线消息*/
//                        NSMutableDictionary* tempdic = [[NSMutableDictionary alloc]init];
//                        [tempdic setValue:atribeid forKey:@"targetid"];
//                        [tempdic setValue:@"0" forKey:@"start"];
//                        
//                        [tempdic setValue:[NSString stringWithFormat:@"%d",[acount integerValue]] forKey:@"count"];
//                        /*添加离线消息*/
//                        chat.offMessageDic = tempdic;
////                        [[MessageBySend sharMessageBySend]getMessageHistory:tempdic andSendtype:@"1"];
//                    }
                   
                }];
//                if (chat.otherDic) {
//                     [self.navigationController pushViewController:chat animated:NO];
//                }
  
            }else if([bsendtype isEqualToString:@"2"])
            {
                NSNumber* ntribeid = (NSNumber*)[message valueForKey:@"tribeid"];
                NSString* atribeid = [NSString stringWithFormat:@"%d",[ntribeid intValue]];
                [DataInterface getTribeInfo:atribeid withCompletionHandler:^(NSMutableDictionary* dic){
                    /*部落聊天*/
                    chatroom = [[ChatRoomController alloc]init];
                    NSMutableDictionary* tempdic = [[NSMutableDictionary alloc]initWithDictionary:dic];
                    tempdic[@"tribeid"] = ntribeid;
                    chatroom.tribeInfoDict = tempdic;
                    
                    /*如果count值大于数组个数，则存在离线消息*/
                    NSNumber* acount = [message valueForKey:@"count"];
                    NSInteger bcount = [acount integerValue];
//                    if (bcount >=[temp count]) {
                        /*获取所有离线消息*/
//                        NSMutableDictionary* atempdic = [[NSMutableDictionary alloc]init];
                        [tempdic setValue:atribeid forKey:@"targetid"];
                        [tempdic setValue:@"0" forKey:@"start"];
                        
                        [tempdic setValue:[NSString stringWithFormat:@"%d",[acount integerValue]] forKey:@"count"];
                        chatroom.offMessageDic = tempdic;
//                        [[MessageBySend sharMessageBySend]getMessageHistory:tempdic andSendtype:@"2"];
//                    }
                    
                    
                    [self.navigationController pushViewController:chatroom animated:NO];
                }];
                
      
 
            }else{
                MessagesViewController *messages = [[MessagesViewController alloc] init];
                messages.delegate = self;
                messages.messagesList = [self.myMessageList objectAtIndex:indexPath.row];
                messages.lastMessagesList = [self.lastMessages copy];
                messages.dealMessages = self.dealMessages;
                
                if ([self.lastMessages count] == 0) {
                    [self.lastMessages addObjectsFromArray:messages.messagesList];
                }else{
                    NSMutableArray *newMessages = [[NSMutableArray alloc] initWithCapacity:0];
                    for (int i = 0; i < [messages.messagesList count]; i ++) {
                        NSDictionary *newDict = [messages.messagesList objectAtIndex:i];
                        NSInteger newMessid = [[newDict objectForKey:@"messid"] integerValue];
                        BOOL isNew = YES;
                        for (int j = 0; j < [self.lastMessages count]; j ++) {
                            NSDictionary *oldDict = [self.lastMessages objectAtIndex:j];
                            NSInteger oldMessid = [[oldDict objectForKey:@"messid"] integerValue];
                            if (newMessid == oldMessid) {
                                isNew = NO;
                                break;
                            }
                        }
                        if (isNew) {
                            [newMessages addObject:newDict];
                        }
                    }
                    [self.lastMessages addObjectsFromArray:newMessages];
                }
                [self.navigationController pushViewController:messages animated:YES];
            }
        }else{
//            MessagesViewController *messages = [[MessagesViewController alloc] init];
////            messages.messagesList = [self.myMessageList copy];
//            messages.messagesList = [self.myMessageList objectAtIndex:indexPath.row];
//            [self.navigationController pushViewController:messages animated:YES];
        }

    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"搜索");
    [searchBar resignFirstResponder];
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
    
    [DataInterface getFriendInfo:@"2"
                         address:@""
                        domicile:@""
                     displayname:searchBar.text
                        usertype:@""
                           start:@"0"
                           count:@"100"
           withCompletionHandler:^(NSMutableDictionary *dict){
               NSLog(@"通讯录列表返回数据：%@",dict);
               
               if (dict) {
                   NSArray *list = [dict objectForKey:@"lists"];
                   
                   //筛选出好友
                   [self checkHaveMySelf:list];
                   
                   FindAddressResultViewController *findAddressResult = [[FindAddressResultViewController alloc] init];
//                   findAddressResult.membersList = [NSMutableArray arrayWithArray:list];
                   if (self.searchMyFriends) {
                       findAddressResult.membersList = self.searchMyFriends;
                   }
                   [self.navigationController pushViewController:findAddressResult animated:YES];
               }
           }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.searchBar resignFirstResponder];
}

- (void)checkHaveMySelf:(NSArray *)lists{//筛选掉自己
    if (lists) {
        NSMutableArray *myFriends = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < [lists count]; i ++) {
            NSDictionary *dict = [lists objectAtIndex:i];
            NSArray *list = [dict objectForKey:@"list"];
            for (int j = 0; j < [list count]; j ++) {
                NSDictionary *memberDict = [list objectAtIndex:j];
                BOOL isMyFriend = [self checkIsMyFriendByUserInfo:memberDict];
                if (isMyFriend) {
                    [myFriends addObject:memberDict];
                }
            }
        }
        self.searchMyFriends = myFriends;
    }
}

- (BOOL)checkIsMyFriendByUserInfo:(NSDictionary *)memberDict{
    if (self.addressList) {
        BOOL haveMyFriend = NO;
        for (int i = 0; i < [self.addressList count]; i ++) {
            NSDictionary *dict = [self.addressList objectAtIndex:i];
            NSArray *list = [dict objectForKey:@"list"];
            for (int j = 0; j < [list count]; j ++) {
                NSDictionary *memberDict2 = [list objectAtIndex:j];
                NSInteger memberId = [[memberDict2 objectForKey:@"userid"] integerValue];
                NSInteger myUserId = [[memberDict objectForKey:@"userid"] integerValue];
                if (memberId == myUserId) {
                    haveMyFriend = YES;
                    break;
                }
            }
        }
        return haveMyFriend;
    }else{
        return NO;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
}

#pragma mark - MessageDelegate
- (void)didDealMessageVC:(MessagesViewController *)messageVC withMessages:(NSMutableDictionary *)messages{
    NSLog(@"message:%@",messages);
}

@end
