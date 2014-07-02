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
//    [self.headImgView setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
    [self.headImgView setImageWithURL:IMGURL(imageUrlString) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];

    NSString *nameString = [params objectForKey:@"tribename"];
    NSString *count = [params objectForKey:@"maxcount"];
    self.name.text = [NSString stringWithFormat:@"%@ (%@人)",nameString,count];//@"北约 （50人）";
    NSString *dynamicString = [params objectForKey:@"signature"];
    self.dynamic.text = dynamicString;
    NSString *createrName = [params objectForKey:@"creatername"];
    self.creatMan.text = [NSString stringWithFormat:@"创建人：%@",createrName];
}

@end
