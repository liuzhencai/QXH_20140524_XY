//
//  NameCardViewController.m
//  QXH
//
//  Created by XueYong on 5/16/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "NameCardViewController.h"
#import "ChatViewController.h"
#import "NameCardTitleCell.h"

@interface NameCardViewController ()<UITableViewDataSource, UITableViewDelegate,NameCardTitleDelegate>
@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSArray *items;
@end
#define WIDTH_TO_LEFT 15
#define HEIGHT_TO_TOP 15
#define HEIGHT_TITLE 120
@implementation NameCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _items = @[@"单位职务",@"所在城市",@"学位/职称",@"曾获荣誉",@"个人动态"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"个人名片";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    [self.view addSubview:_mainTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return [_items count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 180;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 30;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
        bgImgView.image = [UIImage imageNamed:@"bar_transition"];
        
        //59,140,77//3,93,0
        UILabel *title = [self addLabelWithFrame:CGRectMake(20, 0, 200, 30)
                                            text:@"详细个人信息"
                                           color:COLOR_WITH_ARGB(3, 93, 0, 1.0)
                                            font:[UIFont systemFontOfSize:14]];
        title.backgroundColor = [UIColor clearColor];
        [bgImgView addSubview:title];
        return bgImgView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *identifierTitle = @"identitierTitle";
        NameCardTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierTitle];
        if (!cell) {
            cell = [[NameCardTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierTitle];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            
//            UIButton *_addFriend = [UIButton buttonWithType:UIButtonTypeCustom];
//            _addFriend.frame = CGRectMake(20, 125, 130, 44);
//            _addFriend.tag = 300;
//            [_addFriend setTitle:@"加为好友" forState:UIControlStateNormal];
//            [_addFriend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [_addFriend setBackgroundImage:[UIImage imageNamed:@"btn_enroll_normal"] forState:UIControlStateNormal];
//            [_addFriend setBackgroundImage:[UIImage imageNamed:@"btn_enroll_highlight"] forState:UIControlStateHighlighted];
//            [_addFriend addTarget:self action:@selector(addFriendOrForwardCard:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.contentView addSubview:_addFriend];
//            
//            UIButton *_forwardCard = [UIButton buttonWithType:UIButtonTypeCustom];
//            _forwardCard.frame = CGRectMake(170, 125, 130, 44);
//            _forwardCard.tag = 101;
//            [_forwardCard setTitle:@"转发名片" forState:UIControlStateNormal];
//            [_forwardCard setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [_forwardCard setBackgroundImage:[UIImage imageNamed:@"btn_share_normal"] forState:UIControlStateNormal];
//            [_forwardCard setBackgroundImage:[UIImage imageNamed:@"btn_share_highlight"] forState:UIControlStateHighlighted];
//            [_forwardCard addTarget:self action:@selector(addFriendOrForwardCard:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.contentView addSubview:_forwardCard];
        }
        return cell;
    }else{
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            UILabel *title = [self addLabelWithFrame:CGRectMake(20, (cell.height - 30)/2.0, 80, 30)
                                                text:@""
                                               color:[UIColor blackColor]
                                                font:[UIFont systemFontOfSize:14]];
            title.tag = 200;
            [cell.contentView addSubview:title];
            
            UILabel *value = [self addLabelWithFrame:CGRectMake(title.right, (cell.height - 30)/2.0, 180, 30)
                                                text:@""
                                               color:[UIColor lightGrayColor]
                                                font:[UIFont systemFontOfSize:14]];
            value.tag = 201;
            [cell.contentView addSubview:value];
        }
        UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:200];
        UILabel *valueLabel = (UILabel *)[cell.contentView viewWithTag:201];
        titleLabel.text = [_items objectAtIndex:indexPath.row];
        NSString *value = @"";
        switch (indexPath.row) {
            case 0:
                value = @"北京市教育局局长";
                break;
            case 1:
                value = @"北京";
                break;
            case 2:
                value = @"教授";
                break;
            case 3:
                value = @"国家级科技成就奖";
                break;
            case 4:
                value = @"不知道";
                break;
                
            default:
                break;
        }
        valueLabel.text = value;
        return cell;
    }
}

- (void)addFriendOrForwardCard:(UIButton *)sender{
    NSLog(@"add friend or forward card");
}

#pragma mark - NameCardTitleDelegate
- (void)didSelectButtonWithIndex:(int)index{
    NSLog(@"选择： %d",index);
    if (index == 1) {
        [self showAlert:@"已发出好友申请"];
    }else{
        [self showAlert:@"转发名片"];
    }
    
}

- (void)buttonAction:(UIButton *)btn{
    NSLog(@"button action");
    int tag = btn.tag - 1000;
    if (0 == tag) {//加为好友/聊天
        ChatViewController *chat = [[ChatViewController alloc] init];
        [self.navigationController pushViewController:chat animated:YES];
    }else{//转发名片
        
    }
}

- (UILabel *)addLabelWithFrame:(CGRect)frame
                          text:(NSString *)text
                         color:(UIColor *)color
                          font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.text = text;
    if (color) {
        label.textColor = color;
    }
    return label;
}

@end
