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
#import "CustomSegmentControl.h"
#import "ChatRoomController.h"
#import "FindTribeResultViewController.h"
#import "MJRefresh.h"

#import "ChineseToPinyin.h"

@interface TribeController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,CustomSegmentControlDelegate>
@property (nonatomic, strong) UITableView *myTribesTable;
@property (nonatomic, strong) UITableView *allTribesTable;
@property (nonatomic, assign) int selectIndex;

@property (nonatomic, strong) NSMutableArray *tribeList;//我的部落
@property (nonatomic, strong) NSMutableArray *allTribeList;//所有部落

@property (nonatomic, assign) NSInteger curIndex;//当前下标


//排序
//我的部落
@property (nonatomic, strong) NSArray *myTribesIndexSortArray;
@property (nonatomic, strong) NSMutableDictionary *myTribesDict;
//推荐部落
@property (nonatomic, strong) NSArray *allIndexSortArray;
@property (nonatomic, strong) NSMutableDictionary *allDict;
@end

#define MY_TRIBE_TABLE_TAG 2330
#define ALL_TRIBE_TABLE_TAG 2331

#define CELL_HEIGHT 80

@implementation TribeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _tribeList = [[NSMutableArray alloc] initWithCapacity:0];
        _allTribeList = [[NSMutableArray alloc] initWithCapacity:0];
        _selectIndex = 1;
        _curIndex = 0;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:TYPE_LOOK_GROUP];
    [MobClick beginEvent:TYPE_LOOK_GROUP];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:TYPE_LOOK_GROUP];
    [MobClick endEvent:TYPE_LOOK_GROUP];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"部落";
    
    UIButton *righttbuttonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    righttbuttonItem.frame = CGRectMake(0, 0,80, 30);
    [righttbuttonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [righttbuttonItem setTitle:@"创建部落" forState:UIControlStateNormal];
    righttbuttonItem.titleLabel.font = [UIFont systemFontOfSize:17];
    [righttbuttonItem addTarget:self action:@selector(createTribe:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *righttItem = [[UIBarButtonItem alloc] initWithCustomView:righttbuttonItem];
    self.navigationItem.rightBarButtonItem = righttItem;
    
    //segment
    CustomSegmentControl *segment = [[CustomSegmentControl alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, MENU_HEIGHT) andTitles:@[@"我的部落",@"推荐部落"]];
    segment.delegate = self;
    [self.view addSubview:segment];
    
    //table
    UITableView *allTribeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, segment.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - segment.height) style:UITableViewStylePlain];
    allTribeTable.tag = ALL_TRIBE_TABLE_TAG;
    self.allTribesTable = allTribeTable;
    allTribeTable.hidden = YES;
    allTribeTable.delegate = self;
    allTribeTable.dataSource = self;
    allTribeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupRefresh:allTribeTable];
    [self.view addSubview:allTribeTable];
    
    UITableView *myTribeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, segment.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - segment.height) style:UITableViewStylePlain];
    myTribeTable.tag = MY_TRIBE_TABLE_TAG;
    self.myTribesTable = myTribeTable;
    myTribeTable.delegate = self;
    myTribeTable.dataSource = self;
    myTribeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupRefresh:myTribeTable];
    [self.view addSubview:myTribeTable];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, UI_SCREEN_WIDTH, 44.0f)];
    self.searchBar.placeholder = @"输入名字查找部落";
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.delegate = self;
    allTribeTable.tableHeaderView = self.searchBar;
    
    [self.myTribesTable headerBeginRefreshing];
    
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
    table.hidden = NO;
    [self.view bringSubviewToFront:table];
    
    NSInteger lastTag = (tag + 1) % 2 + MY_TRIBE_TABLE_TAG;
    UITableView *lastTable = (UITableView *)[self.view viewWithTag:lastTag];
    lastTable.hidden = YES;
    _curIndex = index;
    if (_curIndex == 0) {
        if ([self.tribeList count] == 0) {
            [self.myTribesTable headerBeginRefreshing];
        }
    }else{
        if ([self.allTribeList count] == 0) {
            [self.allTribesTable headerBeginRefreshing];
        }
    }
}

- (void)createTribe:(UIButton *)sender{
    NSLog(@"创建部落");
    CreatTribeViewController *creatTribe = [[CreatTribeViewController alloc] init];
    [self.navigationController pushViewController:creatTribe animated:YES];
}

- (void)requestInfoList:(NSString *)type start:(NSString *)start withCompletionHandler:(ListCallback)callback{
    NSString *autuflag = @"0";
    if ([type isEqualToString:@"2"]) {
        autuflag = @"2";
    }
    [DataInterface requestTribeList:type
                          tribename:@""
                           authflag:autuflag
                             status:@"0"
                          tribetype:@"1"
                                tag:@""
                           district:@""
                              start:start
                              count:@"20"
              withCompletionHandler:^(NSMutableDictionary *dict){
                  NSLog(@"部落列表返回值：%@",dict);
                  
                  NSMutableArray *list = (NSMutableArray *)[dict objectForKey:@"list"];
                  callback(list);
              }];
    
}

#pragma mark - sort
- (NSMutableDictionary *)sortArrayWithArray:(NSArray *)list{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < [list count]; i ++) {
        NSDictionary *cityDict = list[i];
        //得到拼音首字母
        NSString *letter = [ChineseToPinyin firstPinyinCharacter:cityDict[@"tribename"]];
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

- (NSArray *)getIndexesByTribes:(NSMutableDictionary *)dict{
    NSArray *sortIndexArray = [dict allKeys];
    sortIndexArray = [sortIndexArray sortedArrayUsingSelector:@selector(compare:)];
//    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:sortIndexArray];
//    [tmpArray replaceObjectAtIndex:0 withObject:@""];
//    sortIndexArray = tmpArray;
    return sortIndexArray;
}

//type 1:我的部落  2:推荐部落
-(NSArray *)sortWithSection:(NSInteger)section withType:(int)type {
    NSArray *array;
    if (type == 1) {//我的部落
        array = _myTribesIndexSortArray;
        if(section != -1){
            NSString *key = [_myTribesIndexSortArray objectAtIndex:section];
            //        if ([key isEqualToString:HOT_CITY_NOASTR]) {
            //            key = HOT_CITY_STR;
            //        }
            array = [_myTribesDict objectForKey:key];
        }
    }
    else {//推荐部落
        array = _allIndexSortArray;
        if(section != -1){
            NSString *key = [_allIndexSortArray objectAtIndex:section];
            array = [_allDict objectForKey:key];
        }
    }
    return array;
}

//- (NSArray *)sortWithSection:(NSInteger)section
//{
//    NSArray *array;
//    array = _myTribesIndexSortArray;
//    if(section != -1)
//    {
//        NSString *key = [_myTribesIndexSortArray objectAtIndex:section];
//        //        if ([key isEqualToString:HOT_CITY_NOASTR]) {
//        //            key = HOT_CITY_STR;
//        //        }
//        array = [_myTribesDict objectForKey:key];
//    }
//    return array;
//}


#pragma mark - Refresh
/**
 *  集成刷新控件
 */
- (void)setupRefresh:(UITableView *)tableView
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    NSString *type = _curIndex == 0 ? @"1":@"2";
    [self requestInfoList:type start:@"0" withCompletionHandler:^(NSMutableArray *list) {
        // 1.添加数据
        if (_curIndex == 0) {
            [self.tribeList removeAllObjects];
            [self.tribeList addObjectsFromArray:list];
            
            self.myTribesDict = [self sortArrayWithArray:self.tribeList];
            self.myTribesIndexSortArray = [self getIndexesByTribes:self.myTribesDict];
            
            [self.myTribesTable reloadData];
            [self.myTribesTable headerEndRefreshing];
        }else{
            [self.allTribeList removeAllObjects];
            [self.allTribeList addObjectsFromArray:list];
            
            self.allDict = [self sortArrayWithArray:self.allTribeList];
            self.allIndexSortArray = [self getIndexesByTribes:self.allDict];
            
            [self.allTribesTable reloadData];
            [self.allTribesTable headerEndRefreshing];
        }
    }];
}

- (void)footerRereshing{
    NSString *type = _curIndex == 0 ? @"1":@"2";
    NSString *startId = @"0";
    if (_curIndex == 0) {
        if ([self.tribeList count]) {
            NSDictionary *dict = [self.tribeList lastObject];
            startId = [[dict objectForKey:@"tribeid"] stringValue];
        }
    }else{
        if ([self.allTribeList count]) {
            NSDictionary *dict = [self.allTribeList lastObject];
            startId = [[dict objectForKey:@"tribeid"] stringValue];
        }
    }
    [self requestInfoList:type start:startId withCompletionHandler:^(NSMutableArray *list) {
        // 1.添加数据
        if (_curIndex == 0) {
            [self.tribeList addObjectsFromArray:list];
            
            self.myTribesDict = [self sortArrayWithArray:self.tribeList];
            self.myTribesIndexSortArray = [self getIndexesByTribes:self.myTribesDict];
            
            [self.myTribesTable reloadData];
            [self.myTribesTable footerEndRefreshing];
        }else{
            [self.allTribeList addObjectsFromArray:list];
            
            self.allDict = [self sortArrayWithArray:self.allTribeList];
            self.allIndexSortArray = [self getIndexesByTribes:self.allDict];
            
            [self.allTribesTable reloadData];
            [self.allTribesTable footerEndRefreshing];
        }
    }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == MY_TRIBE_TABLE_TAG) {
        return [self.myTribesDict count];
    }
    else {
        return [self.allDict count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == MY_TRIBE_TABLE_TAG) {
        return [[self sortWithSection:section withType:1] count];
//        return [self.tribeList count];
    }else{
        return [[self sortWithSection:section withType:2] count];
//        return [self.allTribeList count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 22)];
    bgView.image = [UIImage imageNamed:@"bar_transition"];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 22)];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont systemFontOfSize:16];
    title.textColor = GREEN_FONT_COLOR;
    if (tableView.tag == MY_TRIBE_TABLE_TAG) {
        title.text = [[self sortWithSection:-1 withType:1] objectAtIndex:section];
    }else{
        title.text = [[self sortWithSection:-1 withType:2] objectAtIndex:section];
    }
    [bgView addSubview:title];
    return bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == ALL_TRIBE_TABLE_TAG) {
        static NSString *myMsgIdentifier = @"myMsgIdentifier";
        MyTribeListCell *allListCell = nil;
        allListCell = [tableView dequeueReusableCellWithIdentifier:myMsgIdentifier];
        if (!allListCell) {
            allListCell = [[MyTribeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myMsgIdentifier];
            allListCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (self.allDict) {
            NSDictionary *memberDict = [[self sortWithSection:indexPath.section withType:2] objectAtIndex:indexPath.row];
            [allListCell resetCellParamDict:memberDict];
        }
        
//        NSDictionary *memberDict = [self.allTribeList objectAtIndex:indexPath.row];
//        if (memberDict) {
//            [allListCell resetCellParamDict:memberDict];
//        }
       
        return allListCell;
    }else if(tableView.tag == MY_TRIBE_TABLE_TAG){
        static NSString *addrIdentifier = @"addrListIdentifier";
        MyTribeListCell *addrListCell = nil;
        addrListCell = [tableView dequeueReusableCellWithIdentifier:addrIdentifier];
        if (!addrListCell) {
            addrListCell = [[MyTribeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addrIdentifier];
            addrListCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
//        if (self.tribeList) {
//            NSDictionary *myTribeDict = [self.tribeList objectAtIndex:indexPath.row];
//            [addrListCell resetCellParamDict:myTribeDict];
//        }
        if (self.myTribesDict) {
            NSDictionary *myTribeDict = [[self sortWithSection:indexPath.section withType:1] objectAtIndex:indexPath.row];
            [addrListCell resetCellParamDict:myTribeDict];
        }
        
        return addrListCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == MY_TRIBE_TABLE_TAG) {
        NSLog(@"点击我的部落第%d部分第%d行", indexPath.section, indexPath.row);
//        NSDictionary *tribeDict = [self.tribeList objectAtIndex:indexPath.row];
        NSDictionary *tribeDict = [[self sortWithSection:indexPath.section withType:1] objectAtIndex:indexPath.row];
        
        chatview =[[ChatRoomController alloc]init];
        chatview.tribeInfoDict = tribeDict;
        [self.navigationController pushViewController:chatview animated:NO];
        chatview = nil;
    }else if(tableView.tag == ALL_TRIBE_TABLE_TAG){
        NSLog(@"点击我的消息第%d行", indexPath.row);
//        NSDictionary *tribeDict = [self.allTribeList objectAtIndex:indexPath.row];
        NSDictionary *tribeDict = [[self sortWithSection:indexPath.section withType:2] objectAtIndex:indexPath.row];
        TribeDetailViewController *detail = [[TribeDetailViewController alloc] init];
        detail.tribeDict = tribeDict;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"搜索");

    [DataInterface requestTribeList:@"2"
                          tribename:searchBar.text
                           authflag:@"0"
                             status:@"0"
                          tribetype:@""
                                tag:@""
                           district:@""
                              start:@"0"
                              count:@"20"
              withCompletionHandler:^(NSMutableDictionary *dict){
                  NSLog(@"部落列表返回值：%@",dict);
                  NSArray *list = [dict objectForKey:@"list"];
                  if ([list count]) {
                      //跳到下一页
                      FindTribeResultViewController *tribeResult = [[FindTribeResultViewController alloc] init];
                      tribeResult.allTribeList = [[NSMutableArray alloc] initWithArray:list];
                      [self.navigationController pushViewController:tribeResult animated:YES];
                  }else{
                      [self showAlert:@"没有找到相关部落"];
                  }
              }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
}

@end
