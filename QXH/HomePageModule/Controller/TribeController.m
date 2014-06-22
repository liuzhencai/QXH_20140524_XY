//
//  TribeController.m
//  QXH
//
//  Created by XueYong on 5/20/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "TribeController.h"
#import "MyTribeListCell.h"
#import "CreatTribeViewController.h"
#import "TribeDynamicViewController.h"
#import "TribeDetailViewController.h"
#import "CustomSegmentView.h"
#import "CustomSegmentControl.h"

@interface TribeController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,CustomSegmentControlDelegate>
@property (nonatomic, assign) int selectIndex;
@property (nonatomic, strong) NSMutableArray *tribeList;//我的部落
@property (nonatomic, strong) NSMutableArray *allTribeList;//所有部落

@end

#define MY_TRIBE_TABLE_TAG 2330
#define ALL_TRIBE_TABLE_TAG 2331

@implementation TribeController

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view from its nib.
    self.title = @"部落";
    
//    NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:0];
//    for (int j = 0; j < 3; j ++) {
//        NSMutableArray *tmp2 = [NSMutableArray arrayWithArray:0];
//        for (int i = 0; i < 20; i ++) {
//            [tmp2 addObject:@{@"name":@"北约",@"des":@"最新发言内容",@"creater":@"ABC",@"imgUrl":@""}];
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
//    self.tribeList = [NSArray arrayWithArray:tmpArr];
//    
//    NSMutableArray *tmpMyMessage = [NSMutableArray arrayWithCapacity:0];
//    for (int i = 0; i < 20; i ++) {
//        [tmpMyMessage addObject:@{@"name":@"李某某",@"duty":@"xxxxxxxx校长",@"imgUrl":@""}];
//    }
//    self.allTribeList = [NSArray arrayWithArray:tmpMyMessage];
    
    UIButton *righttbuttonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    righttbuttonItem.frame = CGRectMake(0, 0,80, 30);
    [righttbuttonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [righttbuttonItem setTitle:@"创建部落" forState:UIControlStateNormal];
    [righttbuttonItem addTarget:self action:@selector(createTribe:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *righttItem = [[UIBarButtonItem alloc] initWithCustomView:righttbuttonItem];
    self.navigationItem.rightBarButtonItem = righttItem;
    
    //segment
    CustomSegmentControl *segment = [[CustomSegmentControl alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 32) andTitles:@[@"我的部落",@"所有部落"]];
    segment.delegate = self;
    [self.view addSubview:segment];
    
    //table
    UITableView *allTribeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - segment.height) style:UITableViewStylePlain];
    allTribeTable.tag = ALL_TRIBE_TABLE_TAG;
    allTribeTable.delegate = self;
    allTribeTable.dataSource = self;
    [self.view addSubview:allTribeTable];
    
    UITableView *myTribeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - segment.height) style:UITableViewStylePlain];
    myTribeTable.tag = MY_TRIBE_TABLE_TAG;
    myTribeTable.delegate = self;
    myTribeTable.dataSource = self;
    [self.view addSubview:myTribeTable];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, UI_SCREEN_WIDTH, 44.0f)];
    self.searchBar.placeholder = @"输入名字查找部落";
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    myTribeTable.tableHeaderView = self.searchBar;
    
    // Create the search display controller
    //    self.searchDC = [[[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self] autorelease];
    //    self.searchDC.searchResultsDataSource = self;
    //    self.searchDC.searchResultsDelegate = self;
    
    [self getTribeList];
}

- (void)getTribeList{
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

    [DataInterface requestTribeList:@"2"
                          tribename:@""
                           authflag:@"0"
                             status:@"0"
                          tribetype:@"1"
                                tag:@""
                           district:@""
                              start:@"0"
                              count:@"20"
              withCompletionHandler:^(NSMutableDictionary *dict){
                  NSLog(@"部落列表返回值：%@",dict);

                  if (dict) {
                      NSArray *list = [dict objectForKey:@"list"];
                      self.tribeList = [NSMutableArray arrayWithArray:list];
                      UITableView *table = (UITableView *)[self.view viewWithTag:MY_TRIBE_TABLE_TAG];
                      [table reloadData];
                  }
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
    NSLog(@"%d",index);
    NSInteger tag = MY_TRIBE_TABLE_TAG + index;
    UITableView *table = (UITableView *)[self.view viewWithTag:tag];
    [self.view bringSubviewToFront:table];

    if (index == 1) {
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
        [DataInterface requestTribeList:@"2"
                              tribename:@""
                               authflag:@"0"
                                 status:@"0"
                              tribetype:@"1"
                                    tag:@""
                               district:@""
                                  start:@"0"
                                  count:@"20"
                  withCompletionHandler:^(NSMutableDictionary *dict){
                      NSLog(@"部落列表返回值：%@",dict);

                      NSArray *list = [dict objectForKey:@"list"];
                      self.allTribeList = [NSMutableArray arrayWithArray:list];
                      [table reloadData];
//                      [self showAlert:[dict objectForKey:@"info"]];
                  }];
    }
}

- (void)createTribe:(UIButton *)sender{
    NSLog(@"创建部落");
    CreatTribeViewController *creatTribe = [[CreatTribeViewController alloc] init];
    [self.navigationController pushViewController:creatTribe animated:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (tableView.tag == MY_TRIBE_TABLE_TAG) {
//        return 1;
//    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == MY_TRIBE_TABLE_TAG) {
//        NSDictionary *dict = [self.tribeList objectAtIndex:section];
//        NSArray *list = [dict objectForKey:@"list"];
//        return [list count];
        return [self.tribeList count];
    }else{
        return [self.allTribeList count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (tableView.tag == MY_TRIBE_TABLE_TAG) {
//        return 20;
//    }else{
//        return 0;
//    }
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (tableView.tag == MY_TRIBE_TABLE_TAG) {
//        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
//        bgView.image = [UIImage imageNamed:@"bar_transition"];
//        
//        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 20)];
//        NSDictionary *dict = [self.tribeList objectAtIndex:section];
//        NSString *titleStr = [dict objectForKey:@"name"];
//
//        title.text = titleStr;
//        title.backgroundColor = [UIColor clearColor];
//        [bgView addSubview:title];
//        
//        return bgView;
//    }
//    return nil;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (tableView.tag == MY_TRIBE_TABLE_TAG) {
//        return 20;
//    }else{
//        return 0;
//    }
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (tableView.tag == MY_TRIBE_TABLE_TAG) {
//        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
//        bgView.image = [UIImage imageNamed:@"bar_transition"];
//        
//        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 20)];
//        NSDictionary *dict = [self.tribeList objectAtIndex:section];
//        NSString *titleStr = [dict objectForKey:@"name"];
////        if (section == 0) {
////            titleStr = @"A";
////        }else if (section == 1){
////            titleStr = @"B";
////        }else {
////            titleStr = @"C";
////        }
//        title.text = titleStr;
//        title.backgroundColor = [UIColor clearColor];
//        [bgView addSubview:title];
//        
//        return bgView;
//    }
//    return nil;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (tableView.tag == ALL_TRIBE_TABLE_TAG) {
        static NSString *myMsgIdentifier = @"myMsgIdentifier";
        MyTribeListCell *allListCell = nil;
        allListCell = [tableView dequeueReusableCellWithIdentifier:myMsgIdentifier];
        if (!allListCell) {
            allListCell = [[MyTribeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myMsgIdentifier];
            allListCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSDictionary *memberDict = [self.allTribeList objectAtIndex:indexPath.row];
        if (memberDict) {
            [allListCell resetCellParamDict:memberDict];
        }
        cell = allListCell;
    }else if(tableView.tag == MY_TRIBE_TABLE_TAG){
        static NSString *addrIdentifier = @"addrListIdentifier";
        MyTribeListCell *addrListCell = nil;
        addrListCell = [tableView dequeueReusableCellWithIdentifier:addrIdentifier];
        if (!addrListCell) {
            addrListCell = [[MyTribeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addrIdentifier];
            addrListCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.tribeList) {
            NSDictionary *myTribeDict = [self.tribeList objectAtIndex:indexPath.row];
            [addrListCell resetCellParamDict:myTribeDict];
        }
        cell = addrListCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == MY_TRIBE_TABLE_TAG) {
        NSLog(@"点击通讯录第%d部分第%d行", indexPath.section, indexPath.row);
        NSDictionary *tribeDict = [self.tribeList objectAtIndex:indexPath.row];
        TribeDynamicViewController *tribeDynamic = [[TribeDynamicViewController alloc] init];
        tribeDynamic.tribeInfoDict = tribeDict;
        [self.navigationController pushViewController:tribeDynamic animated:YES];
    }else if(tableView.tag == ALL_TRIBE_TABLE_TAG){
        NSLog(@"点击我的消息第%d行", indexPath.row);

        NSDictionary *tribeDict = [self.allTribeList objectAtIndex:indexPath.row];
        TribeDetailViewController *detail = [[TribeDetailViewController alloc] init];
        detail.tribeDict = tribeDict;
        [self.navigationController pushViewController:detail animated:YES];
    }
}
//83,170,97
- (void)btnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == self.selectIndex) {
        return;
    }
    self.selectIndex = btn.tag;
    
    [btn setTitleColor:COLOR_WITH_ARGB(83, 170, 97, 1.0) forState:UIControlStateNormal];
    UIButton *otherBtn = (UIButton *)[self.view viewWithTag:btn.tag%2 + 1];
    [otherBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    NSInteger tag = btn.tag + 99;
    UIImageView *slippag1 = (UIImageView *)[self.view viewWithTag:1000];
    UIImageView *slippag2 = (UIImageView *)[self.view viewWithTag:1001];
    [UIView animateWithDuration:0.1 animations:^{
        slippag1.hidden = !slippag1.hidden;
        slippag2.hidden = !slippag2.hidden;
    } completion:nil];
    [self.view bringSubviewToFront:[self.view viewWithTag:tag]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
}

@end
