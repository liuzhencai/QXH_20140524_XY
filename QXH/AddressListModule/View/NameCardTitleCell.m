//
//  NameCardTitleCell.m
//  QXH
//
//  Created by XUE on 14-5-20.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "NameCardTitleCell.h"

@implementation NameCardTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 180)];
//        [self.contentView addSubview:bgView];
        CGFloat widthToLeft = 20;
        CGFloat headHight = 70;
        CGFloat labelHight = 20;
        CGFloat labelWidth = 200;
        CGFloat btnWidth = 130;
        CGFloat btnHight = 44;

        UIFont *font = [UIFont systemFontOfSize:14];
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _headImgView.image = [UIImage imageNamed:@"img_portrait72"];
        [self.contentView addSubview:_headImgView];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _name.font = font;
        _name.text = @"李某某";
        _name.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_name];
        
        _duty = [[UILabel alloc] init];
        _duty.font = font;
        _duty.text = @"职务";
        _duty.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_duty];
        
        _phone = [[UILabel alloc] init];
        _phone.font = font;
        _phone.text = @"电话";
        _phone.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_phone];
        
        _email = [[UILabel alloc] init];
        _email.font = font;
        _email.text = @"邮箱";
        _email.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_email];
        
        _addFriend = [UIButton buttonWithType:UIButtonTypeCustom];
        _addFriend.frame = CGRectMake(20, 0 + 10, 130, 44);
        [_addFriend setTitle:@"加为好友" forState:UIControlStateNormal];
        [_addFriend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addFriend setBackgroundImage:[UIImage imageNamed:@"btn_enroll_normal"] forState:UIControlStateNormal];
        [_addFriend setBackgroundImage:[UIImage imageNamed:@"btn_enroll_highlight"] forState:UIControlStateHighlighted];
        [_addFriend addTarget:self action:@selector(buttonActionxx:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addFriend];
        
        _forwardCard = [UIButton buttonWithType:UIButtonTypeCustom];
        _forwardCard.frame = CGRectMake(self.width - 20 - 130, 0 + 10, 130, 44);
        [_forwardCard setTitle:@"转发名片" forState:UIControlStateNormal];
        [_forwardCard setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_forwardCard setBackgroundImage:[UIImage imageNamed:@"btn_share_normal"] forState:UIControlStateNormal];
        [_forwardCard setBackgroundImage:[UIImage imageNamed:@"btn_share_highlight"] forState:UIControlStateHighlighted];
        [_forwardCard addTarget:self action:@selector(buttonActionxx:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_forwardCard];
        
        _headImgView.frame = CGRectMake(widthToLeft, widthToLeft, headHight, headHight);
        _name.frame = CGRectMake(_headImgView.right + 10, widthToLeft, labelWidth, labelHight);
        _duty.frame = CGRectMake(_headImgView.right + 10, _name.bottom + 5, labelWidth, labelHight);
        _phone.frame = CGRectMake(_headImgView.right + 10, _duty.bottom + 5, labelWidth, labelHight);
        _email.frame = CGRectMake(_headImgView.right + 10, _phone.bottom + 5, labelWidth, labelHight);
        _addFriend.frame = CGRectMake(widthToLeft, _email.bottom + 10, btnWidth, btnHight);
        _forwardCard.frame = CGRectMake(self.width - widthToLeft - btnWidth, _email.bottom + 10, btnWidth, btnHight);
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

//- (void)layoutSubviews{
//    CGFloat widthToLeft = 20;
//    CGFloat headHight = 70;
//    CGFloat labelHight = 20;
//    CGFloat labelWidth = 200;
//    CGFloat btnWidth = 130;
//    CGFloat btnHight = 44;
//    _headImgView.frame = CGRectMake(widthToLeft, widthToLeft, headHight, headHight);
//    _name.frame = CGRectMake(_headImgView.right + 10, widthToLeft, labelWidth, labelHight);
//    _duty.frame = CGRectMake(_headImgView.right + 10, _name.bottom + 5, labelWidth, labelHight);
//    _phone.frame = CGRectMake(_headImgView.right + 10, _duty.bottom + 5, labelWidth, labelHight);
//    _email.frame = CGRectMake(_headImgView.right + 10, _phone.bottom + 5, labelWidth, labelHight);
//    
//    _addFriend.frame = CGRectMake(widthToLeft, _email.bottom + 10, btnWidth, btnHight);
//    _forwardCard.frame = CGRectMake(self.width - widthToLeft - btnWidth, _email.bottom + 10, btnWidth, btnHight);
//    NSLog(@"kkkkk:%@,%@",NSStringFromCGRect(_addFriend.frame),NSStringFromCGRect(_forwardCard.frame));
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)buttonActionxx:(UIButton *)sender{
    NSLog(@"button action");
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectButtonWithIndex:)]) {
        if (sender == _addFriend) {
            [self.delegate didSelectButtonWithIndex:1];
        }else{
            [self.delegate didSelectButtonWithIndex:2];
        }
    }
}

@end
