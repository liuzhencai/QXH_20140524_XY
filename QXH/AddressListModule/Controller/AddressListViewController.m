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
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //登陆
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.hidesBottomBarWhenPushed = NO;
    // Do any additional setup after loading the view from its nib.
    self.title = @"通讯录";
    
    //test
//    NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:0];
//    for (int j = 0; j < 3; j ++) {
//        NSMutableArray *tmp2 = [NSMutableArray arrayWithArray:0];
//        for (int i = 0; i < 20; i ++) {
//            [tmp2 addObject:@{@"name":@"李某某",@"duty":@"xxxxxxxx校长",@"imgUrl":@""}];
//        }
//        NSString *name = @"A";
//        if (j == 0) {
//            name = @"A";
//        }else if(j == 1){
//            name = @"B";
//        }else{
//            name = @"C";
//        }
//        NSDictionary *dict = @{@"name":name,@"type":@"1",@"list":tmp2};
//        [tmpArr addObject:dict];
//    }
//    self.addressList = [NSArray arrayWithArray:tmpArr];
//    
//    NSMutableArray *tmpMyMessage = [NSMutableArray arrayWithCapacity:0];
//    for (int i = 0; i < 20; i ++) {
//        [tmpMyMessage addObject:@{@"name":@"李某某",@"duty":@"xxxxxxxx校长",@"imgUrl":@""}];
//    }
//    self.myMessageList = [NSArray arrayWithArray:tmpMyMessage];
    
    
    //segment
    CustomSegmentControl *segment = [[CustomSegmentControl alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 32) andTitles:@[@"通讯录",@"我的消息"]];
    segment.delegate = self;
    [self.view addSubview:segment];
    
    //table
    UITableView *myMessageTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_TAB_BAR_HEIGHT - 32) style:UITableViewStylePlain];
    myMessageTable.tag = MY_MESSAGE_LIST_TABLE_TAG;
    myMessageTable.delegate = self;
    myMessageTable.dataSource = self;
    [self.view addSubview:myMessageTable];
    
    UITableView *addressListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_TAB_BAR_HEIGHT - 32) style:UITableViewStylePlain];
    addressListTable.tag = ADDRESS_LIST_TABLE_TAG;
    addressListTable.delegate = self;
    addressListTable.dataSource = self;
    [self.view addSubview:addressListTable];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, UI_SCREEN_WIDTH, 44.0f)];
    self.searchBar.placeholder = @"输入名字查找朋友";
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    addressListTable.tableHeaderView = self.searchBar;
    
    // Create the search display controller
    //    self.searchDC = [[[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self] autorelease];
    //    self.searchDC.searchResultsDataSource = self;
    //    self.searchDC.searchResultsDelegate = self;
    
    [self getAddressList];
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
    
    [DataInterface getFriendInfo:@"2"
                         address:@""
                        domicile:@""
                     displayname:@""
                        usertype:@""
                           start:@"0"
                           count:@"20"
           withCompletionHandler:^(NSMutableDictionary *dict){
               NSLog(@"通讯录列表返回数据：%@",dict);
               self.addressList = [dict objectForKey:@"lists"];
               UITableView *table = (UITableView *)[self.view viewWithTag:ADDRESS_LIST_TABLE_TAG];
               [table reloadData];
               [self showAlert:[dict objectForKey:@"info"]];
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
    if (index == 1 && [self.myMessageList count] == 0) {
        [DataInterface getFriendInfo:@"1"
                             address:@""
                            domicile:@""
                         displayname:@""
                            usertype:@""
                               start:@"0"
                               count:@"20"
               withCompletionHandler:^(NSMutableDictionary *dict){
                   NSLog(@"通讯录列表返回数据：%@",dict);
                   self.myMessageList = [dict objectForKey:@"lists"];
                   [table reloadData];
                   [self showAlert:[dict objectForKey:@"info"]];
               }];
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
    return 1;
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
//    return 10;
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

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString *sectionTitle = nil;
//    if (tableView.tag == ADDRESS_LIST_TABLE_TAG ) {
//        switch (section) {
//            case 0:
//            {
//                sectionTitle = @"A";
//            }
//                break;
//            case 1:
//            {
//                sectionTitle = @"B";
//            }
//                break;
//            case 2:
//            {
//                sectionTitle = @"C";
//            }
//                break;
//            default:
//                break;
//        }
//    }
//    return sectionTitle;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (tableView.tag == MY_MESSAGE_LIST_TABLE_TAG) {
        static NSString *myMsgIdentifier = @"myMsgIdentifier";
        MyMessageCell *myMsgCell = nil;
        myMsgCell = [tableView dequeueReusableCellWithIdentifier:myMsgIdentifier];
        if (!myMsgCell) {
            myMsgCell = [[MyMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myMsgIdentifier];
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
        }
        if (self.addressList) {
            NSDictionary *dict = [self.addressList objectAtIndex:indexPath.section];
            NSArray *list = [dict objectForKey:@"list"];
            NSDictionary *address = [list objectAtIndex:indexPath.row];
            [addrListCell resetCellParamDict:address];
        }
//        [addrListCell resetCellParamDict:nil];
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
        NSDictionary *member = [list objectAtIndex:indexPath.row];
        if (self.addressListBlock) {
            self.addressListBlock(member);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NameCardViewController *nameCard = [[NameCardViewController alloc] init];
            nameCard.memberInfo = member;
            [self.navigationController pushViewController:nameCard animated:YES];
        }
    }else if(tableView.tag == MY_MESSAGE_LIST_TABLE_TAG){
        NSLog(@"点击我的消息第%d行", indexPath.row);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
}

@end
