//
//  MessageDetailCell.m
//  QXH
//
//  Created by XueYong on 7/9/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "MessageDetailCell.h"
#import "JSONKit.h"

@implementation MessageDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGFloat height = 150;
        CGFloat heightLine1 = 30;
        CGFloat heightLine2 = 100;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, UI_SCREEN_WIDTH - 20, height)];
        self.bgView = bgView;
        bgView.backgroundColor = COLOR_WITH_ARGB(230, 230, 230, 1.0);
        [self.contentView addSubview:bgView];
        _title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, bgView.width - 30, 30)];
        _title.backgroundColor = [UIColor clearColor];
        _title.text = @"系统消息";
        _title.textColor = GREEN_FONT_COLOR;
//        [self.contentView addSubview:_title];
        [bgView addSubview:_title];

        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, heightLine1, bgView.width, 1)];
        line1.backgroundColor = GREEN_FONT_COLOR;
//        [self.contentView addSubview:line1];
        [bgView addSubview:line1];
        
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, line1.bottom + 7, 56, 56)];
        _headImageView.image = [UIImage imageNamed:@"img_portrait96"];
        [_headImageView setRound:YES];
//        [self.contentView addSubview:_headImageView];
        [bgView addSubview:_headImageView];

        
        _textDes = [[UILabel alloc] initWithFrame:CGRectMake(_headImageView.right + 10, line1.bottom, 210, 70)];
        _textDes.backgroundColor = [UIColor clearColor];
        _textDes.text = @"\"xxx\" 添加你为好友";
        _textDes.font = [UIFont systemFontOfSize:16];
        _textDes.numberOfLines = 0;
        [bgView addSubview:_textDes];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, heightLine2, bgView.width, 1)];
        line2.backgroundColor = [UIColor lightGrayColor];
        [bgView addSubview:line2];
        
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeBtn.frame = CGRectMake(10, line2.bottom + 5, 130, 35);
        [_agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_agreeBtn setBackgroundImage:[self stretchiOS6:@"btn_enroll_normal.png"] forState:UIControlStateNormal];
        [_agreeBtn setBackgroundImage:[self stretchiOS6:@"btn_enroll_highlight.png"] forState:UIControlStateHighlighted];
        [_agreeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:_agreeBtn];
        
        _refuseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _refuseBtn.frame = CGRectMake(160, line2.bottom + 5, 130, 35);
        [_refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [_refuseBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_refuseBtn setBackgroundImage:[self stretchiOS6:@"btn_share_normal.png"] forState:UIControlStateNormal];
        [_refuseBtn setBackgroundImage:[self stretchiOS6:@"btn_share_highlight.png"] forState:UIControlStateHighlighted];
        [_refuseBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:_refuseBtn];

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)buttonAction:(UIButton *)sender{
    int index = 0;
    if (sender == _agreeBtn) {
        NSLog(@"同意");
        index = 0;
    }else{
        NSLog(@"拒绝");
        index = 1;
    }
    if (self.delegate) {
        [self.delegate selectButtonWithCell:self atIndex:index];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImage *) stretchiOS6:(NSString *)icon {
    UIImage *image = [UIImage imageNamed:icon];
    CGFloat normalLeftCap = image.size.width * 0.5f;
    CGFloat normalTopCap = image.size.height * 0.5f;
    // 13 * 34
    // 指定不需要拉伸的区域
    UIEdgeInsets insets = UIEdgeInsetsMake(normalTopCap, normalLeftCap, normalTopCap - 1, normalLeftCap - 1);
    
    // ios6.0的拉伸方式只不过比iOS5.0多了一个拉伸模式参数
    return [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
}

- (void)resetCellParamDict:(id)objt{
    NSDictionary *params = (NSDictionary *)objt;
    NSLog(@"参数：%@",params);

    NSString *imageUrlStr = [params objectForKey:@"senderphoto"];
    [self.headImageView setImageWithURL:IMGURL(imageUrlStr) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
    self.textDes.text = [NSString stringWithFormat:@"%@",[params objectForKey:@"mess"]];
    
    int status = [[params objectForKey:@"sendtype"] intValue];
    if (status == 0 || status == 4 || status == 6 || status == 7 || status == 13) {
        self.title.text = @"系统消息";
        self.bgView.frame = CGRectMake(self.bgView.left, self.bgView.top, self.bgView.width, 100);
        self.agreeBtn.hidden = YES;
        self.refuseBtn.hidden = YES;
    }else if(status == 3) {
        BOOL isAgreeDeal = [self isAgreeListHaveMessage:params];//是否已经同意处理
        BOOL isRefuseDeal = [self isRefuseListHaveMessage:params];//是否已经拒绝处理
        
        if (isAgreeDeal) {//已同意
            self.bgView.frame = CGRectMake(self.bgView.left, self.bgView.top, self.bgView.width, 100);
            self.agreeBtn.hidden = YES;
            self.refuseBtn.hidden = YES;
            self.textDes.text = [NSString stringWithFormat:@"你已经同意了\"%@\"的好友请求",[params objectForKey:@"sendername"]];
        }else if(isRefuseDeal){//已拒绝
            self.bgView.frame = CGRectMake(self.bgView.left, self.bgView.top, self.bgView.width, 100);
            self.agreeBtn.hidden = YES;
            self.refuseBtn.hidden = YES;
            self.textDes.text = [NSString stringWithFormat:@"你已经拒绝了\"%@\"的好友请求",[params objectForKey:@"sendername"]];
        }else {
            self.bgView.frame = CGRectMake(self.bgView.left, self.bgView.top, self.bgView.width, 150);
            self.agreeBtn.hidden = NO;
            self.refuseBtn.hidden = NO;
        }
        self.title.text = @"好友申请";
        
    }else if (status == 5){
        BOOL isAgreeDeal = [self isAgreeListHaveMessage:params];//是否已经同意处理
        BOOL isRefuseDeal = [self isRefuseListHaveMessage:params];//是否已经拒绝处理
        
        if (isAgreeDeal) {//已同意
            self.bgView.frame = CGRectMake(self.bgView.left, self.bgView.top, self.bgView.width, 100);
            self.agreeBtn.hidden = YES;
            self.refuseBtn.hidden = YES;
            self.textDes.text = [NSString stringWithFormat:@"你已经同意\"%@\"加入%@部落",[params objectForKey:@"sendername"],[params objectForKey:@"tribename"]];
        }else if(isRefuseDeal){//已拒绝
            self.bgView.frame = CGRectMake(self.bgView.left, self.bgView.top, self.bgView.width, 100);
            self.agreeBtn.hidden = YES;
            self.refuseBtn.hidden = YES;
            self.textDes.text = [NSString stringWithFormat:@"你已经拒绝\"%@\"加入%@部落",[params objectForKey:@"sendername"],[params objectForKey:@"tribename"]];
        }else{
            self.bgView.frame = CGRectMake(self.bgView.left, self.bgView.top, self.bgView.width, 150);
            self.agreeBtn.hidden = NO;
            self.refuseBtn.hidden = NO;
        }
        self.title.text = @"部落申请";
    }else if (status == 12){
        NSString *message = [params objectForKey:@"mess"];
        NSDictionary *messages = [message objectFromJSONString];
        self.textDes.text = [NSString stringWithFormat:@"%@ 分享了动态“%@”",[params objectForKey:@"sendername"],[messages objectForKey:@"content"]];
        self.bgView.frame = CGRectMake(self.bgView.left, self.bgView.top, self.bgView.width, 100);
        self.agreeBtn.hidden = YES;
        self.refuseBtn.hidden = YES;
    }
}

//检查消息是否在同意列表里
- (BOOL)isAgreeListHaveMessage:(NSDictionary *)message{
    BOOL isAgreeDeal = NO;
    NSMutableArray *agreeList = [self.dealMessages objectForKey:@"agreeList"];
    NSInteger oldMessid = [[message objectForKey:@"messid"] integerValue];
    for (int i = 0; i < [agreeList count]; i ++) {//先检查同意列表信息
        NSDictionary *newDict = [agreeList objectAtIndex:i];
        NSInteger newMessid = [[newDict objectForKey:@"messid"] integerValue];
        if (newMessid == oldMessid) {
            isAgreeDeal = YES;//如果处理过的列表里面有此消息，就不在处理
            break;
        }
    }
    return isAgreeDeal;
}

//检查消息是否在拒绝列表里
- (BOOL)isRefuseListHaveMessage:(NSDictionary *)message{
    BOOL isRefuseDeal = NO;
    NSMutableArray *agreeList = [self.dealMessages objectForKey:@"refuseList"];
    NSInteger oldMessid = [[message objectForKey:@"messid"] integerValue];
    for (int i = 0; i < [agreeList count]; i ++) {//检查拒绝列表信息
        NSDictionary *newDict = [agreeList objectAtIndex:i];
        NSInteger newMessid = [[newDict objectForKey:@"messid"] integerValue];
        if (newMessid == oldMessid) {
            isRefuseDeal = YES;//如果处理过的列表里面有此消息，就不在处理
            break;
        }
    }
    return isRefuseDeal;
}

@end
