//
//  PersonalCollectionController.m
//  QXH
//
//  Created by ZhaoLilong on 5/14/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "PersonalCollectionController.h"
#import "SquareViewController.h"

@interface PersonalCollectionController ()

@end

@implementation PersonalCollectionController

- (void)getInfoList
{
    [DataInterface getInfoList:@"0" detailtype:@"" tag:@"" arttype:@"" contentlength:@"30" start:@"0" count:@"20" withCompletionHandler:^(NSMutableDictionary *dict) {
        [self showAlert:[dict description]];
    }];
}

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
    self.title = @"我的收藏";
    [self getInfoList];
    
    _collectionTable.frame = CGRectMake(0, 0, 320, SCREEN_H-49);
    
    _toolbarView.frame = CGRectMake(0, SCREEN_H - 49 - 64, 320, 49);
    [self.view addSubview:_toolbarView];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"collectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CollectionCell" owner:nil options:nil] objectAtIndex:0];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SquareViewController *controller = [[SquareViewController alloc] initWithNibName:@"SquareViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)btnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收藏" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
        }
            break;
        case 2:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"赞" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
        }
            break;
        case 3:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"评论" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
        }
            break;
        case 4:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"举报" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}

@end
