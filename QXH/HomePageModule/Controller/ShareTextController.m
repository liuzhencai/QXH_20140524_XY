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
    
    self.title = @"详情";

    _contentTable.frame = CGRectMake(0, 0, 320, SCREEN_H-49);
    _toolbarView.frame = CGRectMake(0, SCREEN_H - 49-64, 320, 49);
    [self.view addSubview:_toolbarView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
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
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (_info.type) {
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
        default:
            break;
    }
    return cell;
}
 
- (IBAction)click:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            NSLog(@"点击了收藏");

            [self showAlert:@"点击了收藏"];

        }
            break;
        case 2:
        {
            NSLog(@"点击了赞");

            [self showAlert:@"点击了赞"];

        }
            break;
        case 3:
        {
            NSLog(@"点击了评论");

            [self showAlert:@"点击了评论"];

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
