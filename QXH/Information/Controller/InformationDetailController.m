//
//  InformationDetailController.m
//  QXH
//
//  Created by ZhaoLilong on 5/18/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "InformationDetailController.h"
#import "InformationCommentController.h"

@interface InformationDetailController ()

@end

@implementation InformationDetailController

@synthesize type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"智谷";
  
    UIButton *righttbuttonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    righttbuttonItem.frame = CGRectMake(0, 0,74, 31);
    [righttbuttonItem setTitle:@"分享" forState:UIControlStateNormal];
    [righttbuttonItem addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *righttItem = [[UIBarButtonItem alloc] initWithCustomView:righttbuttonItem];
    self.navigationItem.rightBarButtonItem = righttItem;
    
    _toolbarView.frame = CGRectMake(0, SCREEN_H - 49 - 64, 320, 49);
    [self.view addSubview:_toolbarView];
}

- (void)share:(id)sender
{
    NSLog(@"分享");
    [self showAlert:@"分享"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)click:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            NSLog(@"点击收藏");
            [self showAlert:@"点击收藏"];
        }
            break;
        case 2:
        {
            NSLog(@"点击赞");
            [self showAlert:@"点击赞"];
        }
            break;
        case 3:
        {
            NSLog(@"点击转发");
            [self showAlert:@"点击转发"];
        }
            break;
        case 4:
        {
            NSLog(@"点击评论");
            InformationCommentController *controller = [[InformationCommentController alloc]initWithNibName:@"InformationCommentController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 5:
        {
            NSLog(@"点击举报");
            [self showAlert:@"点击举报"];
        }
            break;
        default:
            break;
    }
}

- (IBAction)showAll:(id)sender {
    NSLog(@"查看全部");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == InfomationTypeNormal) {
        return 2;
    }else{
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0.f;
    if (self.type == InfomationTypeNormal) {
        switch (indexPath.row) {
            case 0:
            {
                rowHeight = 195.f;
            }
                break;
            case 1:
            {
                rowHeight = 44.f;
            }
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
            {
                rowHeight = 90;
            }
                break;
            case 1:
            {
                rowHeight = 195;
            }
                break;
            case 2:
            {
                rowHeight = 44;
            }
                break;
            default:
                break;
        }
    }
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (self.type == InfomationTypeNormal) {
        switch (indexPath.row) {
            case 0:
            {
                static NSString *cellIdentifier = @"detailCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    [cell.contentView addSubview:_informationDetailView];
                }
            }
                break;
            case 1:
            {
                static NSString *cellIdentifier = @"descCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.textLabel.text = @"资讯内容";
                }
            }
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
            {
                static NSString *cellIdentifier = @"recommendCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    [cell.contentView addSubview:_recommendView];
                }
            }
                break;
            case 1:
            {
                static NSString *cellIdentifier = @"detailCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    [cell.contentView addSubview:_informationDetailView];
                }
            }
                break;
            case 2:
            {
                static NSString *cellIdentifier = @"descCell";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.textLabel.text = @"资讯内容";
                }
            }
                break;
            default:
                break;
        }
    }
    return cell;
}



@end
