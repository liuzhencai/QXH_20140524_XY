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
        _addItems = [[NSMutableArray alloc] initWithCapacity:0];
        _selectIndexPaths = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"创建部落";
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - 70) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    [self.view addSubview:_mainTable];
    
    [self addFooter];
    
    //    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, _mainTable.bottom, UI_SCREEN_WIDTH, 70)];
    //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 20, 100, 30)];
    //    label.text = @"foot 待添加";
    //    [footerView addSubview:label];
    //    //添加阴影
    //    footerView.backgroundColor = [UIColor clearColor];
    //    CGPathRef path = [UIBezierPath bezierPathWithRect:footerView.bounds].CGPath;
    //    [footerView.layer setShadowPath:path];
    //    footerView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    //    footerView.layer.shadowOffset = CGSizeMake(0, 1);
    //    footerView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    //    footerView.layer.shadowOpacity = 0.5f;
    //    [self.view addSubview:footerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    MyTribeDetailViewController *myTribeDetail = [[MyTribeDetailViewController alloc] init];
    myTribeDetail.isCreatDetail = YES;
    [self.navigationController pushViewController:myTribeDetail animated:YES];
}

- (void)addItem:(UIButton *)sender{
    NSLog(@"添加");
    [self showAlert:@"成功添加"];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
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
    NSString *titleStr = nil;
    if (section == 0) {
        titleStr = @"A";
    }else if (section == 1){
        titleStr = @"B";
    }else {
        titleStr = @"C";
    }
    title.text = titleStr;
    title.backgroundColor = [UIColor clearColor];
    [bgView addSubview:title];
    
    return bgView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = nil;
    switch (section) {
        case 0:
        {
            sectionTitle = @"A";
        }
            break;
        case 1:
        {
            sectionTitle = @"B";
        }
            break;
        case 2:
        {
            sectionTitle = @"C";
        }
            break;
        default:
            break;
    }
    return sectionTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *identifier = @"identifier";
//    CreatTribeCell *allListCell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!allListCell) {
//        allListCell = [[CreatTribeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        allListCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        allListCell.delegate = self;
//        [allListCell.selectBtn addTarget:self action:@selector(didselect:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    
//    [allListCell.selectBtn setBackgroundImage:[UIImage imageNamed:@"choice_box"] forState:UIControlStateNormal];
//    for (int i = 0; i < [_selectIndexPaths count]; i ++) {
//        NSIndexPath *index = [_selectIndexPaths objectAtIndex:i];
//        if ([indexPath isEqual:index]) {
//            [allListCell.selectBtn setBackgroundImage:[UIImage imageNamed:@"tribe_icon_establish_highlight"] forState:UIControlStateNormal];
//        }
//    }
    
    static NSString *identifier = @"identifier";
    MultSelectPeopleCell *allListCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!allListCell) {
        allListCell = [[MultSelectPeopleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        allListCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        allListCell.delegate = self;
//        [allListCell.selectBtn addTarget:self action:@selector(didselect:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [allListCell.selectBtn setBackgroundImage:[UIImage imageNamed:@"choice_box"] forState:UIControlStateNormal];
    for (int i = 0; i < [_selectIndexPaths count]; i ++) {
        NSIndexPath *index = [_selectIndexPaths objectAtIndex:i];
        if ([indexPath isEqual:index]) {
            [allListCell.selectBtn setBackgroundImage:[UIImage imageNamed:@"tribe_icon_establish_highlight"] forState:UIControlStateNormal];
        }
    }
    
    [allListCell resetCellParamDict:nil];
    
    return allListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击通讯录第%d部分第%d行", indexPath.section, indexPath.row);
    //    UITableViewCell *cell = nil;
    //    NSIndexPath *index = [cell ];
    MultSelectPeopleCell *cell = (MultSelectPeopleCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([_selectIndexPaths containsObject:indexPath]) {
        [_selectIndexPaths removeObject:indexPath];
        [_addItems removeObject:indexPath];
        [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"choice_box"] forState:UIControlStateNormal];
    }else{
        [_selectIndexPaths addObject:indexPath];
        [_addItems addObject:indexPath];
        [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"tribe_icon_establish_highlight"] forState:UIControlStateNormal];
    }
}


- (void)didselect:(UIButton *)sender{
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    if (IS_OS_7_OR_LATER) {
        cell = (UITableViewCell *)[[[sender superview] superview] superview];
    }
    
    //    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"choice_box"] forState:UIControlStateNormal];
    //    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"tribe_btn_nextstep_normal"]
    
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
