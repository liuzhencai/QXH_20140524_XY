//
//  PhoneViewController.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-8.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "PhoneViewController.h"

@interface PhoneViewController ()

@end

@implementation PhoneViewController

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
    self.title = @"手机号码";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row != 3) {
        static NSString *cellIdentifier = @"cellIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 21)];
            titleLabel.tag = 1;
            
            UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(300, 17, 7.5, 12.5)];
            arrowImage.image = [UIImage imageNamed:@"list_arrow_right_green"];
            
            [cell.contentView addSubview:titleLabel];
            [cell.contentView addSubview:arrowImage];
        }
        
        UILabel *titleLabel_ = (UILabel *)[cell.contentView viewWithTag:1];
        titleLabel_.text = @"13412341234";
    }else{
        static NSString *cellIdentifier = @"lastCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(26.5, 1.75, 267, 40.5);
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_screening_normal"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_screening_highlight"] forState:UIControlStateHighlighted];
            [btn setTitle:@"添加" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
        }
    }
    return cell;
}

- (void)add:(id)sender
{
    NSLog(@"添加");
}

@end
