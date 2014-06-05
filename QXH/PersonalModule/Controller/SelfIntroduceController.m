//
//  SelfIntroduceController.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-8.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "SelfIntroduceController.h"

@interface SelfIntroduceController ()

@end

@implementation SelfIntroduceController

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
    self.title = @"自我介绍";
    
    _introduceView.layer.masksToBounds = YES;
    _introduceView.layer.borderWidth = 1.f;
    _introduceView.layer.borderColor = [UIColor grayColor].CGColor;
    _introduceView.layer.cornerRadius = 3.f;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
