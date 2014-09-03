//
//  ShareToTribeCell.m
//  QXH
//
//  Created by XueYong on 5/22/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "ShareToTribeCell.h"
#import "UIImageView+WebCache.h"

@implementation ShareToTribeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGFloat height = 120;
        CGFloat lableHeight = 30;
        
//        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (height - 48)/2.0, 48, 48)];
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (height - 72)/2.0, 72, 72)];
        [_headImgView setRound:YES];
        _headImgView.image = [UIImage imageNamed:@"img_portrait96"];
        [self.contentView addSubview:_headImgView];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right + 10, (height - 3 * lableHeight)/2.0, 200, lableHeight)];
        _name.text = @"北约 （50人）";
        _name.textColor = GREEN_FONT_COLOR;
        _name.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_name];
        
        _dynamic = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right + 10, _name.bottom, 200, lableHeight)];
        _dynamic.text = @"最新发言内容最新发言内容最新发言内容最新发言内容";
        _dynamic.textColor = [UIColor lightGrayColor];
        _dynamic.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_dynamic];
        
        _creatMan = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right + 10, _dynamic.bottom, 120, lableHeight)];
        _creatMan.text = @"创建人：zyj";
        _creatMan.textColor = GREEN_FONT_COLOR;
        _creatMan.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_creatMan];
        
        _perpelCount = [[UILabel alloc] initWithFrame:CGRectMake(_creatMan.right , _dynamic.bottom, 100, lableHeight)];
        _perpelCount.text = @"29人已加入";
        _perpelCount.textColor = GREEN_FONT_COLOR;
        _perpelCount.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_perpelCount];
        
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
    NSString *headImageString = [params objectForKey:@"photo"];
    [self.headImgView setImageWithURL:IMGURL(headImageString) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
    NSString *tribeName = [params objectForKey:@"tribename"];
    NSInteger count = [[params objectForKey:@"nowcount"] integerValue];
    self.name.text = [NSString stringWithFormat:@"%@ (%d)",tribeName,count];
    self.dynamic.text = [params objectForKey:@"signature"];
    NSString *createrName = [params objectForKey:@"creatername"];
    self.creatMan.text = [NSString stringWithFormat:@"创建人：%@",createrName];
    NSInteger nowCount = [[params objectForKey:@"nowcount"] integerValue];
    self.perpelCount.text = [NSString stringWithFormat:@"%d人已经加入",nowCount];
}

@end
