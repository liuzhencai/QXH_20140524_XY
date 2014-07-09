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
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 40)];
        _title.backgroundColor = [UIColor clearColor];
        _title.text = @"系统消息";
        _title.textColor = GREEN_FONT_COLOR;
        [self.contentView addSubview:_title];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, _title.bottom, UI_SCREEN_WIDTH, 1)];
        line1.backgroundColor = GREEN_FONT_COLOR;
        [self.contentView addSubview:line1];
        
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, line1.bottom + 2, 56, 56)];
        _headImageView.image = [UIImage imageNamed:@"img_portrait96"];
        [_headImageView setRound:YES];
        [self.contentView addSubview:_headImageView];
        
        _textDes = [[UILabel alloc] initWithFrame:CGRectMake(_headImageView.right + 10, line1.bottom + 10, 210, 40)];
        _textDes.text = @"\"xxx\" 添加你为好友";
        [self.contentView addSubview:_textDes];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 100, UI_SCREEN_WIDTH, 1)];
        line2.backgroundColor = GREEN_FONT_COLOR;
        [self.contentView addSubview:line2];
        
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeBtn.frame = CGRectMake(20, line2.bottom + 5, 130, 40);
        [_agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_agreeBtn setBackgroundImage:[self stretchiOS6:@"btn_enroll_normal.png"] forState:UIControlStateNormal];
        [_agreeBtn setBackgroundImage:[self stretchiOS6:@"btn_enroll_highlight.png"] forState:UIControlStateHighlighted];
        [self.contentView addSubview:_agreeBtn];
        
        _refuseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _refuseBtn.frame = CGRectMake(170, line2.bottom + 5, 130, 40);
        [_refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [_refuseBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_refuseBtn setBackgroundImage:[self stretchiOS6:@"btn_share_normal.png"] forState:UIControlStateNormal];
        [_refuseBtn setBackgroundImage:[self stretchiOS6:@"btn_share_highlight.png"] forState:UIControlStateHighlighted];
        [self.contentView addSubview:_refuseBtn];
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
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


@end
