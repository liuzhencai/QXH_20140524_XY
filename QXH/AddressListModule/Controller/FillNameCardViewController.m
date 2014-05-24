//
//  FileNameCardViewController.m
//  QXH
//
//  Created by XUE on 14-5-16.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "FillNameCardViewController.h"

@interface FillNameCardViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) NSArray *items;//填写项
@property (nonatomic, strong) UIImageView *headImgView;//头像
@end
#define FONT  16
@implementation FillNameCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _items = @[@[@{@"title":@"头像",@"isMust":@NO}],
                   @[@{@"title":@"学校信息",@"subTitle":@"您的学校",@"isMust":@YES},
                     @{@"title":@"城市",@"subTitle":@"您所在城市",@"isMust":@YES},
                     @{@"title":@"自我介绍",@"subTitle":@"您的详细介绍",@"isMust":@NO},
                     @{@"title":@"兴趣爱好",@"subTitle":@"您的兴趣爱好",@"isMust":@NO},
                     @{@"title":@"学习经历",@"subTitle":@"您的教育经历",@"isMust":@NO},
                     @{@"title":@"手机号码",@"subTitle":@"您的手机号",@"isMust":@NO}]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"注册";
    // Do any additional setup after loading the view.
    
    CGFloat tableHeight = 30 + 7 * 44;
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, tableHeight) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.scrollEnabled = NO;
    [self.view addSubview:_mainTable];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame = CGRectMake((UI_SCREEN_WIDTH - 220)/2.0, _mainTable.bottom + 20, 220, 40);
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submit.titleLabel.font = [UIFont systemFontOfSize:18];
    submit.backgroundColor = [UIColor greenColor];
    [submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submit:(UIButton *)sender{
    NSLog(@"提交");
    [self showAlert:@"提交"];
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

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_items count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_items objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 30;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
        bgView.backgroundColor = COLOR_WITH_ARGB(231, 242, 222, 1.0);
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, tableView.width - 20 * 2, bgView.height)];
        title.text = @"详细个人信息";
        title.font = [UIFont systemFontOfSize:FONT];
        title.backgroundColor = [UIColor clearColor];
        [bgView addSubview:title];
        return bgView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {//19.22,-18.57,-94.87
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor blackColor];
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = COLOR_WITH_ARGB(49, 109, 33, 1.0);
        
        UILabel *status = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 30 - 60, (cell.contentView.height - 30)/2.0, 60, 30)];
        status.backgroundColor = [UIColor clearColor];
        status.tag = 100;
        status.font = [UIFont systemFontOfSize:14];
        status.textColor = [UIColor lightGrayColor];
        status.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:status];
        
    }
    NSDictionary *item = [[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    BOOL isMust = [[item objectForKey:@"isMust"] boolValue];
    NSString *title = [item objectForKey:@"title"];
    if (isMust) {
        title = [NSString stringWithFormat:@"%@ (必填)",title];
    }
    cell.textLabel.text = title;
    UIImageView *head = (UIImageView *)[cell.contentView viewWithTag:101];
    [head removeFromSuperview];
    UILabel *status = (UILabel *)[cell.contentView viewWithTag:100];
    if (indexPath.section == 1) {
        cell.detailTextLabel.text = [item objectForKey:@"subTitle"];
        status.hidden = NO;
        status.text = @"未填写";
    }else{
        status.hidden = YES;
        UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 30 - 40, 2, 40, 40)];
        headImageView.tag = 101;
        headImageView.backgroundColor = [UIColor greenColor];
        [cell.contentView addSubview:headImageView];
    }
    
    return cell;
}

@end
