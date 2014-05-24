//
//  CityViewController.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-8.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "CityViewController.h"
#import "CitySearchController.h"

@interface CityViewController ()
{
    NSArray *titleArr;
}
@end

@implementation CityViewController

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
    
    self.title = @"城市";
    
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    label.backgroundColor = RGBCOLOR(236, 245, 229);
    
    _cityTable.tableHeaderView = label;
    
    titleArr = @[@"常住地", @"常来往", @"籍贯"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 13.5, 100, 21)];
        statusLabel.textAlignment = kTextAlignmentRight;
        statusLabel.textColor = [UIColor grayColor];
        statusLabel.tag = 3;
        
        UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(300, 17, 7.5, 12.5)];
        arrowImage.image = [UIImage imageNamed:@"list_arrow_right_green"];
        
        [cell.contentView addSubview:statusLabel];
        [cell.contentView addSubview:arrowImage];
    }
    UILabel *statusLabel_ = (UILabel *)[cell.contentView viewWithTag:3];
    statusLabel_.text = @"北京市";
    cell.textLabel.text = titleArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CitySearchController *controller = [[ CitySearchController alloc] initWithNibName:@"CitySearchController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
