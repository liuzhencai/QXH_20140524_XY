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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (_info.type) {
            /**
             *  广场文章
             */
        case 1:
        {
            
        }
            break;
            /**
             *  转发到广场的咨询
             */
        case 2:
        {
            
        }
            break;
            /**
             *  转发到广场的活动
             */
        case 3:
        {
            
        }
            break;
            /**
             *  每日一问
             */
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
