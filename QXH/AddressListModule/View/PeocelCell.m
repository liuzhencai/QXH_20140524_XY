//
//  PeocelCell.m
//  QXH
//
//  Created by XueYong on 5/19/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "PeocelCell.h"
#import "UIImageView+WebCache.h"

@implementation PeocelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGFloat height = self.frame.size.height;
        CGFloat lableHeight = 25;
        
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (height - 48)/2.0, 48, 48)];
        [_headImgView setRound:YES];
        _headImgView.image = [UIImage imageNamed:@"img_portrait96"];
        [self.contentView addSubview:_headImgView];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right + 10, (height - 2 * lableHeight)/2.0, 200, lableHeight)];
        _name.text = @"";
        _name.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_name];
        
        _authflagView = [[UIImageView alloc] initWithFrame:CGRectMake(_name.right, 16, 12, 12)];
        [self.contentView addSubview:_authflagView];
        
        _duty = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right + 10, _name.bottom, 200, lableHeight)];
        _duty.text = @"";
        _duty.textColor = [UIColor lightGrayColor];
        _duty.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_duty];
        
        _arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(290, (height - 12) / 2.0, 8, 12)];
        _arrowImgView.image = [UIImage imageNamed:@"list_arrow_right_gray"];
        [self.contentView addSubview:_arrowImgView];
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)layoutSubviews{
    CGFloat height = self.frame.size.height;
    CGFloat lableHeight = 25;
    
    _headImgView.frame = CGRectMake(10, (height - 48)/2.0, 48, 48);
    _headImgView.backgroundColor = [UIColor redColor];
    _name.frame = CGRectMake(_headImgView.right + 10, (height - 2 * lableHeight)/2.0, 200, lableHeight);
    _duty.frame = CGRectMake(_headImgView.right + 10, _name.bottom, 200, lableHeight);
    _arrowImgView.frame = CGRectMake(290, (height - 12) / 2.0, 8, 12);
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height - 0.5, UI_SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetCellParamDict:(id)objt{
    NSDictionary *params = (NSDictionary *)objt;

    NSString *imageUrlStr = [params objectForKey:@"photo"];
    [self.headImgView setImageWithURL:IMGURL(imageUrlStr) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
    
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
    
    NSString *schoolname = [params objectForKey:@"schoolname"];
    if (schoolname == nil) {
        schoolname = @"";
    }
    NSString *title = [params objectForKey:@"title"];
    if (title == nil) {
        title = @"";
    }
    NSString *dutyString = [NSString stringWithFormat:@"%@ %@",schoolname,title];//[params objectForKey:@"signature"];
    self.duty.text = dutyString;
}

- (CGFloat)widthOfString:(NSString *)string{
    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(500, 30) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat width = size.width;
    return width + 5;
}
@end
