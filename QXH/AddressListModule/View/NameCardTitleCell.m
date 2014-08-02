//
//  NameCardTitleCell.m
//  QXH
//
//  Created by XUE on 14-5-20.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "NameCardTitleCell.h"
#import "UIImageView+WebCache.h"

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
        [_headImgView setRound:YES];
        [self.contentView addSubview:_headImgView];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _name.font = font;
        _name.text = @"";
        _name.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_name];
        
        _authflagView = [[UIImageView alloc] initWithFrame:CGRectMake(_name.right, 25, 12, 12)];
        [self.contentView addSubview:_authflagView];
        
        _duty = [[UILabel alloc] init];
        _duty.font = font;
        _duty.text = @"";
        _duty.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_duty];
        
        UILabel *phoneTitle = [[UILabel alloc] init];
        phoneTitle.text = @"电话:";
        phoneTitle.font = font;
        phoneTitle.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:phoneTitle];
        _phone = [[UILabel alloc] init];
        _phone.font = font;
        _phone.text = @"电话";
        _phone.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_phone];
        
        UILabel *emailTitle = [[UILabel alloc] init];
        emailTitle.text = @"邮箱:";
        emailTitle.font = font;
        emailTitle.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:emailTitle];
        _email = [[UILabel alloc] init];
        _email.font = font;
        _email.text = @"邮箱";
        _email.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_email];
        
        _addFriend = [UIButton buttonWithType:UIButtonTypeCustom];
        _addFriend.frame = CGRectMake(20, 0 + 10, 130, 30);
        [_addFriend setTitle:@"加为好友" forState:UIControlStateNormal];
        _addFriend.titleLabel.font = [UIFont systemFontOfSize:16];
        [_addFriend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIImage *headImageNormal = [UIImage imageNamed:@"btn_enroll_normal"];
        headImageNormal = [headImageNormal resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        UIImage *headImageHighlight = [UIImage imageNamed:@"btn_enroll_highlight"];
        headImageHighlight = [headImageHighlight resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [_addFriend setBackgroundImage:headImageNormal forState:UIControlStateNormal];
        [_addFriend setBackgroundImage:headImageHighlight forState:UIControlStateHighlighted];
        [_addFriend addTarget:self action:@selector(buttonActionxx:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addFriend];
        
        _forwardCard = [UIButton buttonWithType:UIButtonTypeCustom];
        _forwardCard.frame = CGRectMake(self.width - 20 - 130, 0 + 10, 130, 44);
        [_forwardCard setTitle:@"拒绝" forState:UIControlStateNormal];
        _forwardCard.titleLabel.font = [UIFont systemFontOfSize:16];
        [_forwardCard setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _forwardCard.hidden = YES;
        [_forwardCard setBackgroundImage:[UIImage imageNamed:@"btn_share_normal"] forState:UIControlStateNormal];
        [_forwardCard setBackgroundImage:[UIImage imageNamed:@"btn_share_highlight"] forState:UIControlStateHighlighted];
        [_forwardCard addTarget:self action:@selector(buttonActionxx:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_forwardCard];
        
        _headImgView.frame = CGRectMake(widthToLeft, widthToLeft + 10, headHight, headHight);
        _headImgView.layer.cornerRadius = headHight / 2.0;
        _name.frame = CGRectMake(_headImgView.right + 10, widthToLeft, labelWidth, labelHight);
        _duty.frame = CGRectMake(_headImgView.right + 10, _name.bottom + 5, labelWidth, labelHight);
        phoneTitle.frame = CGRectMake(_headImgView.right + 10, _duty.bottom + 5, 40, labelHight);
        _phone.frame = CGRectMake(phoneTitle.right, _duty.bottom + 5, labelWidth, labelHight);
        emailTitle.frame = CGRectMake(_headImgView.right + 10, _phone.bottom + 5, 40, labelHight);
        _email.frame = CGRectMake(emailTitle.right, _phone.bottom + 5, labelWidth, labelHight);
        _addFriend.frame = CGRectMake(widthToLeft, _email.bottom + 10 + 5, btnWidth * 2 + 20, btnHight - 10);
    }
    return self;
}

- (void)setIsMyFriend:(BOOL)isMyFriend{
    if (isMyFriend) {
//        _addFriend.frame = CGRectMake(20, _addFriend.top, 130, 30);
        [_addFriend setTitle:@"和TA聊天" forState:UIControlStateNormal];
    }
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

- (void)resetCellParamDict:(id)objt{
    NSDictionary *params = (NSDictionary *)objt;
    NSString *headUrlString = [params objectForKey:@"photo"];
    [self.headImgView setImageWithURL:IMGURL(headUrlString) placeholderImage:[UIImage imageNamed:@"img_portrait72"]];
    
    NSString *nameStr = [params objectForKey:@"displayname"];
    CGFloat nameWidth = [self widthOfString:nameStr];
    nameWidth = nameWidth < 180 ? nameWidth : 180;
    self.name.frame = CGRectMake(_name.left, _name.top, nameWidth, _name.height);
    self.name.text = [NSString stringWithFormat:@"%@",nameStr];
    int userType = [[params objectForKey:@"usertype"] intValue];
    self.authflagView.frame = CGRectMake(_name.right, _authflagView.top, _authflagView.width, _authflagView.height);
    switch (userType) {
        case 0:{//试用会员
            //此时隐藏
            self.authflagView.frame = CGRectMake(_name.right, _authflagView.top, 0, _authflagView.height);
        }
            break;
        case 1:{//付费会员
            self.authflagView.image = [UIImage imageNamed:@"member_icon"];
        }
            break;
        case 2:{//专家学者
            self.authflagView.image = [UIImage imageNamed:@"experts_icon"];
        }
            break;
        case 3:{//校工助理
            self.authflagView.image = [UIImage imageNamed:@"assistant_icon"];
        }
            break;
        default://默认隐藏
            self.authflagView.frame = CGRectMake(_name.right, _authflagView.top, _authflagView.width, _authflagView.height);
            break;
    }

    
    self.duty.text = [params objectForKey:@"title"];
    self.phone.text = [params objectForKey:@"phone"];
    self.email.text = [params objectForKey:@"email"];
}

- (CGFloat)widthOfString:(NSString *)string{
    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(500, 30) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat width = size.width;
    return width + 5;
}

@end
