//
//  AddOrDeleteMemberViewController.m
//  QXH
//
//  Created by XueYong on 6/18/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "AddOrDeleteMemberViewController.h"
#import "MultSelectPeopleCell.h"

@interface AddOrDeleteMemberViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *tribeMembers;//部落成员
@property (nonatomic, strong) NSMutableArray *addressList;//成员列表
@property (nonatomic, strong) NSMutableArray *addItems;//添加数组
@property (nonatomic, strong) NSMutableArray *selectIndexPaths;//选中的indexPath
@end

@implementation AddOrDeleteMemberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _addItems = [[NSMutableArray alloc] initWithCapacity:0];
        _selectIndexPaths = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    [self.view addSubview:_mainTable];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(addOrDeleteMembers:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    if (_type == addTribeMemberType) {
        [self getAllMembers];
        [button setTitle:@"添加" forState:UIControlStateNormal];
    }else{
        [self getTribeMembers];
        [button setTitle:@"删除" forState:UIControlStateNormal];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addOrDeleteMembers:(UIButton *)sender{
    NSLog(@"添加 or 删除 member");
    if (self.type == deleteTribeMemberType) {//删除
        
    }else{//添加
        
    }
}

- (void)getTribeMembers{
    if (self.tribeDict) {
        /**
         *  获取部落成员列表
         *
         *  @param tribeid  部落id
         *  @param callback 回调
         */
        if (self.tribeDict) {
            [DataInterface getTribeMembers:[self.tribeDict objectForKey:@"tribeid"] withCompletionHandler:^(NSMutableDictionary *dict){
                NSLog(@"获取部落成员列表返回值:%@",dict);
                NSArray *list = [dict objectForKey:@"list"];
                self.tribeMembers = [NSMutableArray arrayWithArray:list];
                [_mainTable reloadData];
                [self showAlert:[dict objectForKey:@"info"]];
            }];
        }
    }
}

- (void)getAllMembers{
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
               
               if (dict) {
                   NSArray *list = [dict objectForKey:@"lists"];
                   self.addressList = [NSMutableArray arrayWithArray:list];
                   [_mainTable reloadData];
               }
               [self showAlert:[dict objectForKey:@"info"]];
           }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_type == deleteTribeMemberType) {
        return 1;
    }else{
        return [self.addressList count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_type == deleteTribeMemberType) {
        return [self.tribeMembers count];
    }else{
        NSDictionary *dict = [self.addressList objectAtIndex:section];
        NSArray *list = [dict objectForKey:@"list"];
        return [list count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_type == deleteTribeMemberType) {
        return nil;
    }else{
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
        bgView.image = [UIImage imageNamed:@"bar_transition"];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 20)];
        NSDictionary *dict = [self.addressList objectAtIndex:section];
        NSString *titleStr = [dict objectForKey:@"name"];
        title.text = titleStr;
        title.backgroundColor = [UIColor clearColor];
        [bgView addSubview:title];
        
        return bgView;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    MultSelectPeopleCell *allListCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!allListCell) {
        allListCell = [[MultSelectPeopleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        allListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [allListCell.selectBtn setBackgroundImage:[UIImage imageNamed:@"choice_box"] forState:UIControlStateNormal];
    for (int i = 0; i < [_selectIndexPaths count]; i ++) {
        NSIndexPath *index = [_selectIndexPaths objectAtIndex:i];
        if ([indexPath isEqual:index]) {
            [allListCell.selectBtn setBackgroundImage:[UIImage imageNamed:@"tribe_icon_establish_highlight"] forState:UIControlStateNormal];
        }
    }
    if (_type == deleteTribeMemberType) {
        NSDictionary *item = [self.tribeMembers objectAtIndex:indexPath.row];
        if (item) {
            [allListCell resetCellParamDict:item];
        }
    }else{
        NSDictionary *dict = [self.addressList objectAtIndex:indexPath.section];
        NSArray *list = [dict objectForKey:@"list"];
        NSDictionary *item = [list objectAtIndex:indexPath.row];
        if (item) {
            [allListCell resetCellParamDict:item];
        }
    }
    
    return allListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击通讯录第%d部分第%d行", indexPath.section, indexPath.row);
    
    NSDictionary *item = nil;
    if (_type == deleteTribeMemberType) {
        item = [self.tribeMembers objectAtIndex:indexPath.row];
    }else{
        NSDictionary *dict = [self.addressList objectAtIndex:indexPath.section];
        NSArray *list = [dict objectForKey:@"list"];
        item = [list objectAtIndex:indexPath.row];
    }
    
    MultSelectPeopleCell *cell = (MultSelectPeopleCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([_selectIndexPaths containsObject:indexPath]) {
        [_selectIndexPaths removeObject:indexPath];
        [_addItems removeObject:item];
        [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"choice_box"] forState:UIControlStateNormal];
    }else{
        [_selectIndexPaths addObject:indexPath];
        [_addItems addObject:item];
        [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"tribe_icon_establish_highlight"] forState:UIControlStateNormal];
    }
}


@end
