//
//  ShareTextController.m
//  QXH
//
//  Created by ZhaoLilong on 5/18/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "ShareTextController.h"
#import "CommentCell.h"

@interface ShareTextController ()

@end

@implementation ShareTextController

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
    
    self.title = @"分享正文";
    
    UIButton *righttbuttonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    righttbuttonItem.frame = CGRectMake(0, 0,74, 31);
    [righttbuttonItem setTitle:@"分享" forState:UIControlStateNormal];
    [righttbuttonItem addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *righttItem = [[UIBarButtonItem alloc] initWithCustomView:righttbuttonItem];
    self.navigationItem.rightBarButtonItem = righttItem;

    _contentTable.frame = CGRectMake(0, 0, 320, SCREEN_H-49);
//    [self.view addSubview:_toolbarView];
    
    _toolbarView.frame = CGRectMake(0, SCREEN_H - 49-64, 320, 49);
    [self.view addSubview:_toolbarView];
}

- (void)share:(id)sender
{
    NSLog(@"点击了分享");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 220;
    }
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"firstIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            [cell.contentView addSubview:_topView];
        }
    }else{
        static NSString *cellIdentifier = @"commentIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:nil options:nil] objectAtIndex:0];
        }
    }
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 49;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return _toolbarView;
//}

- (IBAction)click:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            NSLog(@"点击了收藏");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收藏" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
        }
            break;
        case 2:
        {
            NSLog(@"点击了赞");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"赞" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
        }
            break;
        case 3:
        {
            NSLog(@"点击了评论");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"评论" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
        }
            break;
        case 4:
        {
            NSLog(@"点击了举报");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"举报" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}


@end
