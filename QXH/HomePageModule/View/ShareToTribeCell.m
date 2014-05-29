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
        
        CGFloat height = 80;
        CGFloat lableHeight = 20;
        
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (height - 48)/2.0, 48, 48)];
        _headImgView.image = [UIImage imageNamed:@"img_portrait96"];
        [self.contentView addSubview:_headImgView];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right + 10, (height - 3 * lableHeight)/2.0, 200, lableHeight)];
        _name.text = @"北约 （50人）";
        _name.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_name];
        
        _dynamic = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right + 10, _name.bottom, 200, lableHeight)];
        _dynamic.text = @"最新发言内容最新发言内容最新发言内容最新发言内容";
        _dynamic.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_dynamic];
        
        _creatMan = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right + 10, _dynamic.bottom, 100, lableHeight)];
        _creatMan.text = @"创建人：zyj";
        _creatMan.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_creatMan];
        
        _perpelCount = [[UILabel alloc] initWithFrame:CGRectMake(_creatMan.right , _dynamic.bottom, 100, lableHeight)];
        _perpelCount.text = @"29人已加入";
        _perpelCount.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_perpelCount];
        
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetCellParamDict:(id)objt{
//    @property (nonatomic, strong) UIImageView *headImgView;//头像
//    @property (nonatomic, strong) UILabel *name;//名称
//    @property (nonatomic, strong) UILabel *dynamic;//动态
//    @property (nonatomic, strong) UILabel *creatMan;//创建人
//    @property (nonatomic, strong) UILabel *perpelCount;//加入人数
//    @property (nonatomic, strong) UIImageView *arrowImgView;
    [self.headImgView setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
    self.name.text = @"北约 （50人）";
    self.dynamic.text = @"最新发言内容最新发言内容最新发言内容最新发言内容";
    self.creatMan.text = [NSString stringWithFormat:@"创建人：%@",@"ABC"];
    self.perpelCount.text = [NSString stringWithFormat:@"%d人已经加入",30];
}

@end
