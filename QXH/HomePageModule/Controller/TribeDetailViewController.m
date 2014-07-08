//
//  TribeDetailViewController.m
//  QXH
//
//  Created by XUE on 14-5-21.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "TribeDetailViewController.h"
#import "TribeMembersViewController.h"

@interface TribeDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) NSDictionary *tribeDetailInfo;
@end

@implementation TribeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        _items = @[@"",@"部落秘书长",@"部落标签",@"部落地域",@"介绍",@"当前部落成员"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"详细资料";
    
    CGFloat tableHeight = 100 + ([_items count] - 1) * 44;
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, tableHeight) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.scrollEnabled = NO;
    [self.view addSubview:_mainTable];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake((UI_SCREEN_WIDTH - 267)/2.0, _mainTable.bottom + 30, 267, 40);
    [selectBtn setTitle:@"申请加入" forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"btn_screening_normal"] forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"btn_screening_highlight"] forState:UIControlStateHighlighted];
    [selectBtn addTarget:self action:@selector(applyJoinTribe:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBtn];
    
    [self getTribeInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getTribeInfo{
    /**
     *  获取部落信息
     *
     *  @param tribeid  部落id
     *  @param callback 回调
     */

    NSString *tribeId = @"";
    tribeId = [self.tribeDict objectForKey:@"tribeid"];
    [DataInterface getTribeInfo:tribeId withCompletionHandler:^(NSMutableDictionary *dict){
        NSLog(@"部落信息返回值：%@",dict);
        self.tribeDetailInfo = dict;
        [_mainTable reloadData];
    }];
}

- (void)applyJoinTribe:(UIButton *)sender{
    NSLog(@"申请加入部落");
    /**
     *  申请加入部落
     *
     *  @param tribeid  部落id
     *  @param callback 回调
     */
    if (self.tribeDict) {
        NSString *tribeId = [self.tribeDict objectForKey:@"tribeid"];
        [DataInterface requestAddTribe:tribeId withCompletionHandler:^(NSMutableDictionary *dict){
            NSLog(@"申请加入部落:%@",dict);
            [self showAlert:[dict objectForKey:@"info"]];
        }];
    }
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 100;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString *identifierTitle = @"identitierTitle";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierTitle];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierTitle];
            UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 100)];
            bgImgView.image = [UIImage imageNamed:@"title_bar_bg"];
            cell.backgroundView = bgImgView;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 70, 70)];
            [headImgView setRound:YES];
            headImgView.tag = 100;
            [cell.contentView addSubview:headImgView];
            
            UILabel *title = [self addLabelWithFrame:CGRectMake(headImgView.right + 20, 20, 190, 30)
                                                text:@""
                                               color:GREEN_FONT_COLOR
                                                font:[UIFont systemFontOfSize:16]];
            title.tag = 101;
            [cell.contentView addSubview:title];
            
            UILabel *tribeManager = [self addLabelWithFrame:CGRectMake(headImgView.right + 20, title.bottom, 190, 30)
                                                text:@""
                                               color:[UIColor lightGrayColor]
                                                font:[UIFont systemFontOfSize:14]];
            tribeManager.tag = 102;
            [cell.contentView addSubview:tribeManager];
        }
        UIImageView *headImgView = (UIImageView *)[cell.contentView viewWithTag:100];
        UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:101];
        UILabel *tribeManager = (UILabel *)[cell.contentView viewWithTag:102];

        if (self.tribeDetailInfo) {
            NSString *headImgUrlString = [self.tribeDetailInfo objectForKey:@"photo"];
//            [headImgView setImageWithURL:[NSURL URLWithString:headImgUrlString] placeholderImage:[UIImage imageNamed:@"img_portrait72"]];
            [headImgView setImageWithURL:IMGURL(headImgUrlString) placeholderImage:[UIImage imageNamed:@"img_portrait72"]];

            titleLabel.text = [self.tribeDetailInfo objectForKey:@"tribename"];
            tribeManager.text = [self.tribeDetailInfo objectForKey:@"creatername"];
        }
        
        return cell;
    }else{
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *title = [self addLabelWithFrame:CGRectMake(20, (cell.height - 30)/2.0, 100, 30)
                                                text:@""
                                               color:[UIColor blackColor]
                                                font:[UIFont systemFontOfSize:14]];
            title.tag = 200;
//            title.backgroundColor = [UIColor greenColor];
            [cell.contentView addSubview:title];
            

            UILabel *titleValue = [self addLabelWithFrame:CGRectMake(title.right, (cell.height - 30)/2.0, 160, 30)
                                                text:@""
                                               color:[UIColor blackColor]
                                                font:[UIFont systemFontOfSize:14]];
            titleValue.tag = 201;

//            titleValue.backgroundColor = [UIColor greenColor];
            [cell.contentView addSubview:titleValue];
        }
        UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:200];
        titleLabel.text = [_items objectAtIndex:indexPath.row];
        UILabel *titleValue = (UILabel *)[cell.contentView viewWithTag:201];

        titleValue.text = @"test";
        if (self.tribeDetailInfo) {
            switch (indexPath.row) {
                case 1:{//部落秘书长
                    NSString *secretaryName = [self.tribeDetailInfo objectForKey:@"secretaryname"];
                    titleValue.text = secretaryName;
                }
                    break;
                case 2:{//部落标签
                    titleValue.text = [self.tribeDetailInfo objectForKey:@"signature"];
                }
                    break;
                case 3:{//部落地域
                    titleValue.text = [self.tribeDetailInfo objectForKey:@"district"];
                }
                    break;

                case 4:{//介绍
                    titleValue.text = [self.tribeDetailInfo objectForKey:@"desc"];
                }
                    break;
                case 5:{//当前部落成员
                    NSInteger newCount = [[self.tribeDetailInfo objectForKey:@"nowcount"] integerValue];
                    titleValue.text = [NSString stringWithFormat:@"%d",newCount];
                }
                    break;
                    
                default:
                    break;
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
    if (indexPath.row == 5) {
        TribeMembersViewController *members = [[TribeMembersViewController alloc] init];
        members.tribeId = [[self.tribeDict objectForKey:@"tribeid"] stringValue];
        [self.navigationController pushViewController:members animated:YES];
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
