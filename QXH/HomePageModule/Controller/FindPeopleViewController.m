//
//  FindPeopleViewController.m
//  ExpansionTableView
//
//  Created by XUE on 14-5-19.
//  Copyright (c) 2014年 JianYe. All rights reserved.
//

#import "FindPeopleViewController.h"
#import "CityCell.h"
#import "DistrictCell.h"

#import "FindResultViewController.h"

@interface FindPeopleViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@end

@implementation FindPeopleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isOpen = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:TYPE_LOOK_SEARCH_USER];
    [MobClick beginEvent:TYPE_LOOK_SEARCH_USER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:TYPE_LOOK_SEARCH_USER];
    [MobClick endEvent:TYPE_LOOK_SEARCH_USER];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"人脉";
    // Do any additional setup after loading the view.
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"provincesAndCitys" ofType:@"plist"];
    _dataList = [[NSArray alloc] initWithContentsOfFile:path];
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    [self.view addSubview:_mainTable];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_NAVIGATION_BAR_HEIGHT)];
    _searchBar.placeholder = @"找人";
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.delegate = self;
    _mainTable.tableHeaderView = _searchBar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)screening:(UIButton *)sender{
    NSLog(@"筛选");
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

- (void)buttonAction:(UIButton *)sender{
    NSLog(@"button action");
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isOpen) {
        if (_selectIndexPath.section == section) {
            return [[[_dataList objectAtIndex:section] objectForKey:@"citysList"] count] + 1;
        }
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 30;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
        bgView.image = [UIImage imageNamed:@"bar_transition"];
        bgView.userInteractionEnabled = YES;
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
        title.text = @"按地域查找";
        title.font = [UIFont systemFontOfSize:18];
        title.backgroundColor = [UIColor clearColor];
        title.textColor = COLOR_WITH_ARGB(49, 109, 33, 1.0);
        [bgView addSubview:title];
        
//        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(290, 9, 8, 12)];
//        arrow.image = [UIImage imageNamed:@"list_arrow_right_green"];
//        [bgView addSubview:arrow];
        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(0, 0, tableView.width, 30);
//        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [bgView addSubview:btn];
        return bgView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isOpen && _selectIndexPath.section == indexPath.section && 0 != indexPath.row) {
        static NSString *identifier1 = @"cellId1";
        DistrictCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell) {
            cell = [[DistrictCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
        }
        
        NSDictionary *dict = [_dataList objectAtIndex:indexPath.section];
        NSArray *list = [dict objectForKey:@"citysList"];
        NSDictionary *cityDict = [list objectAtIndex:indexPath.row - 1];
        cell.titleLabel.text = [cityDict objectForKey:@"city"];
        return cell;
    }else{
        static NSString *identifier2 = @"cellId2";
        CityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (!cell) {
            cell = [[CityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
        }
        
        NSDictionary *dict = [_dataList objectAtIndex:indexPath.section];
        cell.titleLabel.text = [dict objectForKey:@"province"];
        [cell changeArrowWithUp:([indexPath isEqual:_selectIndexPath] ? YES : NO)];
        return cell;
    }
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        if ([indexPath isEqual:self.selectIndexPath]) {//重新选择
            self.isOpen = NO;
            self.selectIndexPath = nil;
        }else{
            self.isOpen = YES;
            self.selectIndexPath = indexPath;
        }
        [_mainTable reloadData];
    }else{
        NSArray *list = [[_dataList objectAtIndex:indexPath.section] objectForKey:@"citysList"];
        NSDictionary *cityDict = [list objectAtIndex:indexPath.row - 1];
        NSLog(@"%@",cityDict);
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
                             address:[cityDict objectForKey:@"cityid"]
                            domicile:@""
                         displayname:@""
                            usertype:@""
                               start:@"0"
                               count:@"20"
               withCompletionHandler:^(NSMutableDictionary *dict){
                   NSLog(@"通讯录列表返回数据：%@",dict);
                   if (dict) {
                       NSArray *findList = [dict objectForKey:@"lists"];
                       BOOL isHavePeople = NO;
                       for ( int i = 0; i < [findList count]; i ++) {
                           NSDictionary *dict = [findList objectAtIndex:i];
                           NSArray *arr = [dict objectForKey:@"list"];
                           if ([arr count]) {
                               isHavePeople = YES;
                               break;
                           }
                       }
                       if (isHavePeople) {
                           FindResultViewController *findResult = [[FindResultViewController alloc] init];
                           findResult.findPeopleResults = findList;
                           [self.navigationController pushViewController:findResult animated:YES];
                       }else{
                           [self showAlert:@"没有找到相关人员"];
                       }
                   }
               }];
    }
}

- (void)didSelectCellFirst:(BOOL)isFirstInsert orNext:(BOOL)isNextInsert{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"搜索");
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
                               count:@"20"
               withCompletionHandler:^(NSMutableDictionary *dict){
                   NSLog(@"通讯录列表返回数据：%@",dict);
                   if (dict) {
                       NSArray *findList = [dict objectForKey:@"lists"];
                       BOOL isHavePeople = NO;
                       for ( int i = 0; i < [findList count]; i ++) {
                           NSDictionary *dict = [findList objectAtIndex:i];
                           NSArray *arr = [dict objectForKey:@"list"];
                           if ([arr count]) {
                               isHavePeople = YES;
                               break;
                           }
                       }
                       if (isHavePeople) {
                           FindResultViewController *findResult = [[FindResultViewController alloc] init];
                           findResult.findPeopleResults = findList;
                           [self.navigationController pushViewController:findResult animated:YES];
                       }else{
                           [self showAlert:@"没有找到相关人员"];
                       }
                   }
               }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
}

@end
