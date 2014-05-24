//
//  MyCardController.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-8.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "MyCardController.h"
#import "EditCardController.h"

@interface MyCardController ()

@end

@implementation MyCardController

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
    self.title = @"个人名片";
    
    _cardTable.tableHeaderView = _topView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            NSLog(@"点击了编辑资料");
            EditCardController *controller = [[EditCardController alloc] initWithNibName:@"EditCardController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 2:
        {
            NSLog(@"点击了转发名片");
            [self showAlert:@"点击了转发名片"];
        }
            break;
        default:
            break;
    }

}

@end
