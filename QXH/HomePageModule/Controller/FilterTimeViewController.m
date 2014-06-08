//
//  FilterTimeViewController.m
//  QXH
//
//  Created by XueYong on 5/17/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "FilterTimeViewController.h"

@interface FilterTimeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) NSMutableArray *addItems;//添加数组
@property (nonatomic, strong) NSMutableArray *selectIndexPaths;//选中的indexPath
@end

@implementation FilterTimeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _items = @[@"近期活动",@"未来一周",@"未来一月",@"未来一年"];
        _addItems = [[NSMutableArray alloc] initWithCapacity:0];
        _selectIndexPaths = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择活动时间";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44 * [_items count] + 20) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.scrollEnabled = NO;
    [self.view addSubview:_mainTable];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake((UI_SCREEN_WIDTH - 267)/2.0, _mainTable.bottom + 30, 267, 40);
    [selectBtn setTitle:@"开始筛选" forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"btn_screening_normal"] forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"btn_screening_highlight"] forState:UIControlStateHighlighted];
    [selectBtn addTarget:self action:@selector(beginSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)beginSelect:(UIButton *)sender{
    NSLog(@"开始筛选");
    if (self.filterTimeCallBack) {
        self.filterTimeCallBack(self.addItems);
    }
    [self.navigationController popViewControllerAnimated:YES];
//    NSArray *controllers = self.navigationController.viewControllers;
//    [self.navigationController popToViewController:[controllers objectAtIndex:[controllers count] - 3] animated:YES];
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
        
        CGRect btnFrame = CGRectMake(cell.contentView.frame.size.width-30-12, 16,12,12);
        UIImageView *selectImgView = [[UIImageView alloc] initWithFrame:btnFrame];
        selectImgView.image = [UIImage imageNamed:@"choice_box"];
        selectImgView.tag = 220;
        [cell.contentView addSubview:selectImgView];
        
    }
    
    cell.textLabel.text = [_items objectAtIndex:indexPath.row];
    UIImageView *selectImgView = (UIImageView *)[cell.contentView viewWithTag:220];
    for (int i = 0; i < [_selectIndexPaths count]; i ++) {
        NSIndexPath *index = [_selectIndexPaths objectAtIndex:i];
        if ([indexPath isEqual:index]) {
            selectImgView.image = [UIImage imageNamed:@"tribe_icon_establish_highlight"];
        }
    }
    
    return cell;
}

//- (void)selectTime:(UIButton *)sender{
//    sender.selected = !sender.selected;
//    if (sender.selected) {
//        [sender setBackgroundImage:[UIImage imageNamed:@"tribe_icon_establish_highlight"] forState:UIControlStateNormal];
//    }else{
//        [sender setBackgroundImage:[UIImage imageNamed:@"choice_box"] forState:UIControlStateNormal];
//    }
//    NSLog(@"button action");
//}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
    
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:220];
    if ([_selectIndexPaths containsObject:indexPath]) {
        [_selectIndexPaths removeObject:indexPath];
        [_addItems removeObject:indexPath];
        imgView.image = [UIImage imageNamed:@"choice_box"];
    }else{
        [_selectIndexPaths addObject:indexPath];
        [_addItems addObject:indexPath];
        imgView.image = [UIImage imageNamed:@"tribe_icon_establish_highlight"];
    }
}

@end
