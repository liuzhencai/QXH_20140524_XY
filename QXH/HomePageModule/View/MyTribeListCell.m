//
//  MyTribeCell.m
//  QXH
//
//  Created by XueYong on 5/20/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "MyTribeListCell.h"
#import "UIImageView+WebCache.h"

@implementation MyTribeListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGFloat height = 120;
        CGFloat lableHeight = 30;
        
//        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (height - 52)/2.0, 56, 56)];
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (height - 72)/2.0, 72, 72)];
        [_headImgView setRound:YES];
        _headImgView.image = [UIImage imageNamed:@"img_portrait96"];
        [self.contentView addSubview:_headImgView];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right + 10, (height - 3 * lableHeight)/2.0, 200, lableHeight)];
        _name.text = @"北约 （50人）";
        _name.textColor = GREEN_FONT_COLOR;
        _name.font = [UIFont systemFontOfSize:16];
        _name.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_name];
        
        _authflagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [self.contentView addSubview:_authflagView];
        
        _nowCount = [[UILabel alloc] initWithFrame:CGRectMake(_authflagView.right, _name.top, 30, lableHeight)];
        _nowCount.textColor = GREEN_FONT_COLOR;
        _nowCount.font = [UIFont systemFontOfSize:16];
        _nowCount.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nowCount];
        
        _dynamic = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right + 10, _name.bottom, 200, lableHeight)];
        _dynamic.text = @"最新发言内容最新发言内容最新发言内容最新发言内容";
        _dynamic.textColor = [UIColor lightGrayColor];
        _dynamic.font = [UIFont systemFontOfSize:16];
        _dynamic.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_dynamic];
        
        _creatMan = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right + 10, _dynamic.bottom, 200, lableHeight)];
        _creatMan.text = @"创建人：zyj";
        _creatMan.textColor = GREEN_FONT_COLOR;
        _creatMan.font = [UIFont systemFontOfSize:16];
        _creatMan.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_creatMan];
        
        _arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(290, (height - 12) / 2.0, 8, 12)];
        _arrowImgView.image = [UIImage imageNamed:@"list_arrow_right_gray"];
        [self.contentView addSubview:_arrowImgView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height - 0.5, UI_SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:line];
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

- (void)resetCellParamDict:(id)objt{
    NSDictionary *params = (NSDictionary *)objt;
    NSString *imageUrlString = [params objectForKey:@"photo"];
    [self.headImgView setImageWithURL:IMGURL(imageUrlString) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];

    NSString *nameString = [params objectForKey:@"tribename"];
    CGFloat nameWidth = [self widthOfString:nameString];
    nameWidth = nameWidth < 180 ? nameWidth : 180;
    self.name.frame = CGRectMake(_name.left, _name.top, nameWidth, _name.height);
    self.name.text = [NSString stringWithFormat:@"%@",nameString];//@"北约 （50人）";
    int authflag = [[params objectForKey:@"authflag"] intValue];
    if (authflag == 2) {
        self.authflagView.frame = CGRectMake(_name.right, _name.top + 8, 14, 14);
        self.authflagView.image = [UIImage imageNamed:@"tribe_authflog"];
    }else{
        self.authflagView.frame = CGRectMake(_name.right, _name.top, 0, 30);
    }
    int nowMembersCount = [[params objectForKey:@"nowcount"] intValue];
    self.nowCount.text = [NSString stringWithFormat:@"(%d人)",nowMembersCount];
    self.nowCount.frame = CGRectMake(_authflagView.right, _name.top, 45, _name.height);
    
    NSString *dynamicString = [params objectForKey:@"signature"];
    self.dynamic.text = dynamicString;
    NSString *createrName = [params objectForKey:@"creatername"];
    self.creatMan.text = [NSString stringWithFormat:@"创建人：%@",createrName];
}

- (CGFloat)widthOfString:(NSString *)string{
    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(500, 30) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat width = size.width;
    return width + 5;
}

@end
