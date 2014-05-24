//
//  HobbyViewController.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-8.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "HobbyViewController.h"

@interface HobbyViewController ()
{
    NSArray *titleArr;
}

@end

@implementation HobbyViewController

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
    self.title = @"兴趣爱好";
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    textField.placeholder = @"填写兴趣";
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 50)];
    label.backgroundColor = [UIColor clearColor];
    [textField setLeftView:label];
    textField.leftViewMode = UITextFieldViewModeAlways;
    _myHobbyTable.tableHeaderView = textField;
    
    titleArr = @[@"高尔夫", @"羽毛球", @"跑步"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0.f;
    switch (indexPath.row) {
        case 0:
            rowHeight = 20;
            break;
        default:
            rowHeight = 44;
            break;
    }
    return rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"firstCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
            label.backgroundColor = RGBCOLOR(236, 245, 229);
            [cell.contentView addSubview:label];
        }
    }else{
        static NSString *cellIdentifier = @"otherCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(300, 16, 12, 12);
            [btn setImage:[UIImage imageNamed:@"choice_box"] forState:UIControlStateNormal];
            [cell.contentView addSubview:btn];
            
        }
        cell.textLabel.text = titleArr[indexPath.row-1];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

@end
