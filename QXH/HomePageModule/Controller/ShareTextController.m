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

- (void)requestDetailInfo
{
    [DataInterface getDetailInfo:@"1" artid:_artid withCompletionHandler:^(NSMutableDictionary *dict) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取广场详细信息" message:[dict description] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"分享正文";
    
    [self requestDetailInfo];
    
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

    [self showAlert:@"点击了分享"];

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
        return 300;
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
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

//            [self showAlert:@"点击了收藏"];
            [DataInterface squareArticleCollection:@"1" artid:_artid withCompletionHandler:^(NSMutableDictionary *dict) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收藏" message:[dict description] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }];

        }
            break;
        case 2:
        {
            NSLog(@"点击了赞");

//            [self showAlert:@"点击了赞"];
            [DataInterface praiseArticle:_artid laud:@"1" comment:@"" withCompletionHandler:^(NSMutableDictionary *dict) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"赞" message:[dict description] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }];

        }
            break;
        case 3:
        {
            NSLog(@"点击了评论");

//            [self showAlert:@"点击了评论"];
            [DataInterface praiseArticle:_artid laud:@"0" comment:@"这篇文章还可以" withCompletionHandler:^(NSMutableDictionary *dict) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"评论" message:[dict description] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }];

        }
            break;
        case 4:
        {
            NSLog(@"点击了举报");

            [self showAlert:@"点击了举报"];

        }
            break;
        default:
            break;
    }
}


@end
