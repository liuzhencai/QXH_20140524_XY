//
//  CreatTribeViewController.m
//  QXH
//
//  Created by XueYong on 5/20/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "CreatTribeViewController.h"
#import "CreatTribeCell.h"
//#import "TribeDetailViewController.h"
#import "MyTribeDetailViewController.h"
#import "MultSelectPeopleCell.h"

@interface CreatTribeViewController ()<UITableViewDataSource,UITableViewDelegate,CreatTribeCellDelegate>
@property (nonatomic, strong) UITableView *mainTable;

@property (nonatomic, strong) NSMutableArray *addressList;

@property (nonatomic, strong) NSMutableArray *addItems;//添加数组
@property (nonatomic, strong) NSMutableArray *selectIndexPaths;//选中的indexPath
@end

@implementation CreatTribeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        _addressList = [[NSMutableArray alloc] initWithCapacity:0];
        _addItems = [[NSMutableArray alloc] initWithCapacity:0];
        _selectIndexPaths = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"创建部落";
    
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
//    self.addressList = tmpArr;
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - 70) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    [self.view addSubview:_mainTable];
    
    [self addFooter];
    
    [self getAddressList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
               if (dict) {
                   NSArray *list = [dict objectForKey:@"lists"];
                   self.addressList = [NSMutableArray arrayWithArray:list];
                   [_mainTable reloadData];
               }
//               [self showAlert:[dict objectForKey:@"info"]];
           }];
}

- (void)addFooter{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, _mainTable.bottom, UI_SCREEN_WIDTH, 70)];
    //添加阴影
    footerView.backgroundColor = [UIColor clearColor];
    CGPathRef path = [UIBezierPath bezierPathWithRect:footerView.bounds].CGPath;
    [footerView.layer setShadowPath:path];
    footerView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    footerView.layer.shadowOffset = CGSizeMake(0, 1);
    footerView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    footerView.layer.shadowOpacity = 0.5f;
    [self.view addSubview:footerView];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(footerView.width - 64 - 10, (footerView.height - 34)/2.0, 64, 34);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"tribe_btn_nextstep_normal"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"tribe_btn_nextstep_highlight"] forState:UIControlStateHighlighted];
    [nextBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:nextBtn];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(nextBtn.left - 36 - 10 , (footerView.height - 36)/2.0, 36, 36);
    [addBtn setBackgroundImage:[UIImage imageNamed:@"tribe_btn_add_normal"] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"tribe_btn_add_highlight"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addItem:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:addBtn];
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10, (footerView.height - 36)/2.0, footerView.width - addBtn.width - nextBtn.width - 40, 36)];
    for (int i = 0; i < 4; i ++) {
        UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * (36 + 10), 0, 36, 36)];
        headImgView.image = [UIImage imageNamed:@"img_portrait72"];
        [scroll addSubview:headImgView];
    }
    [footerView addSubview:scroll];
    
}

- (void)next:(UIButton *)sneder{
    NSLog(@"下一步");
    if ([self.addItems count] == 0) {
        [self showAlert:@"请选择成员"];
        return;
    }
    MyTribeDetailViewController *myTribeDetail = [[MyTribeDetailViewController alloc] init];
    myTribeDetail.isCreatDetail = YES;
    myTribeDetail.membersArray = self.addItems;
    [self.navigationController pushViewController:myTribeDetail animated:YES];
}

- (void)addItem:(UIButton *)sender{
    NSLog(@"添加");
    [self showAlert:@"成功添加"];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.addressList count];
//    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = [self.addressList objectAtIndex:section];
    NSArray *list = [dict objectForKey:@"list"];
    return [list count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
    bgView.image = [UIImage imageNamed:@"bar_transition"];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 20)];
    NSDictionary *dict = [self.addressList objectAtIndex:section];
    NSString *titleStr = [dict objectForKey:@"name"];
//    if (section == 0) {
//        titleStr = @"A";
//    }else if (section == 1){
//        titleStr = @"B";
//    }else {
//        titleStr = @"C";
//    }
    title.text = titleStr;
    title.backgroundColor = [UIColor clearColor];
    [bgView addSubview:title];
    
    return bgView;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString *sectionTitle = nil;
//    switch (section) {
//        case 0:
//        {
//            sectionTitle = @"A";
//        }
//            break;
//        case 1:
//        {
//            sectionTitle = @"B";
//        }
//            break;
//        case 2:
//        {
//            sectionTitle = @"C";
//        }
//            break;
//        default:
//            break;
//    }
//    return sectionTitle;
//}

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
    NSDictionary *dict = [self.addressList objectAtIndex:indexPath.section];
    NSArray *list = [dict objectForKey:@"list"];
    NSDictionary *item = [list objectAtIndex:indexPath.row];
    if (item) {
        [allListCell resetCellParamDict:item];
    }
    return allListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击通讯录第%d部分第%d行", indexPath.section, indexPath.row);
    
    NSDictionary *dict = [self.addressList objectAtIndex:indexPath.section];
    NSArray *list = [dict objectForKey:@"list"];
    NSDictionary *item = [list objectAtIndex:indexPath.row];
    
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

- (void)didselect:(UIButton *)sender{
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    if (IS_OS_7_OR_LATER) {
        cell = (UITableViewCell *)[[[sender superview] superview] superview];
    }
    
    NSIndexPath *indexPath = [_mainTable indexPathForCell:cell];
    if ([_selectIndexPaths containsObject:indexPath]) {
        [_selectIndexPaths removeObject:indexPath];
        [_addItems removeObject:indexPath];
        [sender setBackgroundImage:[UIImage imageNamed:@"choice_box"] forState:UIControlStateNormal];
    }else{
        [_selectIndexPaths addObject:indexPath];
        [_addItems addObject:indexPath];
        [sender setBackgroundImage:[UIImage imageNamed:@"tribe_icon_establish_highlight"] forState:UIControlStateNormal];
    }
    NSLog(@"select IndexPath:%@",_selectIndexPaths);
    NSLog(@"items:%@",_addItems);
    for (int i = 0; i < [_selectIndexPaths count]; i ++) {
        NSIndexPath *index = [_selectIndexPaths objectAtIndex:i];
        NSLog(@"section:%d,row:%d",index.section,index.row);
    }
}

#pragma mark - CreatTribeCellDelegate
- (void)didSelectWithIndexPath:(NSIndexPath *)indexPath{
    
}

@end
