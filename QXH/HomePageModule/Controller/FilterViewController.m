//
//  FilterViewController.m
//  QXH
//
//  Created by XueYong on 5/20/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterTimeViewController.h"

@interface FilterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) NSArray *items;

@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _items = @[@"活动类型",@"活动区域",@"活动时间"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"筛选";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44 * 3 + 20) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.scrollEnabled = NO;
    [self.view addSubview:_mainTable];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake((UI_SCREEN_WIDTH - 267)/2.0, _mainTable.bottom + 30, 267, 40);
    [selectBtn setTitle:@"添加您要关注的频道" forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"btn_screening_normal"] forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"btn_screening_highlight"] forState:UIControlStateHighlighted];
    [selectBtn addTarget:self action:@selector(addAttention:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
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

- (void)addAttention:(UIButton *)sender{
    NSLog(@"添加关注");
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 20)];
    bgImage.image = [UIImage imageNamed:@"bar_transition"];
    return bgImage;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        CGRect btnFrame = CGRectMake(cell.contentView.frame.size.width-30-20, 12,20,20);
//        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        selectBtn.frame = btnFrame;
//        selectBtn.tag = 200;
//        [selectBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
//        selectBtn.backgroundColor = [UIColor greenColor];
//        [cell.contentView addSubview:selectBtn];
    }
    
    cell.textLabel.text = [_items objectAtIndex:indexPath.row];
    
    //    UIButton *btn = (UIButton *)[cell.contentView viewWithTag:200];
    //    btn.hidden = NO;
    //    if (indexPath.row == 3) {
    //        btn.hidden = YES;
    //    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
    if (indexPath.row == 2) {
        FilterTimeViewController *filterTime = [[FilterTimeViewController alloc] init];
        [self.navigationController pushViewController:filterTime animated:YES];
    }
}


@end
