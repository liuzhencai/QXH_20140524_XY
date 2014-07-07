//
//  SelectCityViewController.m
//  QXH
//
//  Created by XueYong on 7/8/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "SelectCityViewController.h"
#import "DistrictCell.h"
#import "CityCell.h"

@interface SelectCityViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@end

@implementation SelectCityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isOpen = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择城市";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"provincesAndCitys" ofType:@"plist"];
    _dataList = [[NSArray alloc] initWithContentsOfFile:path];
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    [self.view addSubview:_mainTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        //省份名称
        NSDictionary *provinceDict = [_dataList objectAtIndex:indexPath.section];
        NSString *provinceName = [provinceDict objectForKey:@"province"];
        //城市信息
        NSArray *list = [[_dataList objectAtIndex:indexPath.section] objectForKey:@"citysList"];
        NSDictionary *cityDict = [list objectAtIndex:indexPath.row - 1];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:cityDict];
        [params setObject:provinceName forKey:@"province"];
        NSLog(@"%@",params);
        if (self.selectCityCallBack) {
            self.selectCityCallBack(params);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
