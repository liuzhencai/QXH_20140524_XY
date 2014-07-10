//
//  MessageDetailCell.m
//  QXH
//
//  Created by XueYong on 7/9/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "MessageDetailCell.h"

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
//        E_Message_Type_System = 0,//系统消息
//        E_Message_Type_AddFriend = 3,//加好友申请
//        E_Message_Type_AddFriendResult = 4,//处理请求好友申请
//        E_Message_Type_AddTribe = 5,//加入部落申请
//        E_Message_Type_AddTribeResult = 6,//处理部落加入申请
//        E_Message_Type_OutTribe = 7,//完全退出部落
//        E_Message_Type_InformSb = 12,//@某人，@某部落
    
    int status = [[params objectForKey:@"sendtype"] intValue];
    if (status == 0 || status == 4 || status == 6 || status == 7 || status == 12 || status == 13) {
        self.bgView.frame = CGRectMake(self.bgView.left, self.bgView.top, self.width, 100);
        self.agreeBtn.hidden = YES;
        self.refuseBtn.hidden = YES;
    }else if(status == 3 || status == 5) {
        self.bgView.frame = CGRectMake(self.bgView.left, self.bgView.top, self.width, 150);
        self.agreeBtn.hidden = NO;
        self.refuseBtn.hidden = NO;
    }
    NSString *imageUrlStr = [params objectForKey:@"senderphoto"];
    [self.headImageView setImageWithURL:IMGURL(imageUrlStr) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
    self.textDes.text = [NSString stringWithFormat:@"\"%@\" %@",[params objectForKey:@"sendername"],[params objectForKey:@"mess"]];
}
@end
