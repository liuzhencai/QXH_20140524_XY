//
//  TribeDetailViewController.m
//  QXH
//
//  Created by XUE on 14-5-21.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "TribeDetailViewController.h"

@interface TribeDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) NSArray *items;

@end

@implementation TribeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        _items = @[@"",@"部落秘书长",@"部落标签",@"部落地域",@"介绍",@"当前部落成员   28"];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)applyJoinTribe:(UIButton *)sender{
    NSLog(@"申请加入部落");
    /**
     *  申请加入部落
     *
     *  @param tribeid  部落id
     *  @param callback 回调
     */
    NSString *tribeId = @"";
    [DataInterface requestAddTribe:tribeId withCompletionHandler:^(NSMutableDictionary *dict){
        NSLog(@"申请加入部落:%@",dict);
//        [self showAlert:[dict objectForKey:@"info"]];
    }];
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
            headImgView.tag = 100;
            [cell.contentView addSubview:headImgView];
            
            UILabel *title = [self addLabelWithFrame:CGRectMake(headImgView.right + 20, 20, 190, 30)
                                                text:@""
                                               color:GREEN_FONT_COLOR
                                                font:[UIFont systemFontOfSize:16]];
//            title.backgroundColor = [UIColor greenColor];
            title.tag = 101;
            [cell.contentView addSubview:title];
            
            UILabel *tribeManager = [self addLabelWithFrame:CGRectMake(headImgView.right + 20, title.bottom, 190, 30)
                                                text:@""
                                               color:[UIColor lightGrayColor]
                                                font:[UIFont systemFontOfSize:14]];
//            tribeManager.backgroundColor = [UIColor redColor];
            tribeManager.tag = 102;
            [cell.contentView addSubview:tribeManager];
        }
        UIImageView *headImgView = (UIImageView *)[cell.contentView viewWithTag:100];
        UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:101];
        UILabel *tribeManager = (UILabel *)[cell.contentView viewWithTag:102];
        headImgView.image = [UIImage imageNamed:@"img_portrait72"];
        titleLabel.text = @"部落名称";
        tribeManager.text = @"部落酋长";
        return cell;
    }else{
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *title = [self addLabelWithFrame:CGRectMake(20, (cell.height - 30)/2.0, 280, 30)
                                                text:@""
                                               color:[UIColor blackColor]
                                                font:[UIFont systemFontOfSize:14]];
            title.tag = 200;
//            title.backgroundColor = [UIColor greenColor];
            [cell.contentView addSubview:title];
        }
        UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:200];
        titleLabel.text = [_items objectAtIndex:indexPath.row];
        return cell;
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
