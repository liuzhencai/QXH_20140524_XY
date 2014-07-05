//
//  InfluenceCell.m
//  QXH
//
//  Created by XueYong on 7/6/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "InfluenceCell.h"

@implementation InfluenceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGFloat height = self.frame.size.height;
        CGFloat lableHeight = 25;
        
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (height - 48)/2.0, 48, 48)];
        [_headImgView setRound:YES];
        //        _headImgView.layer.cornerRadius = 24;//_headImgView.width/2.0;
        //    _headImgView.backgroundColor = [UIColor greenColor];
        _headImgView.image = [UIImage imageNamed:@"img_portrait96"];
        [self.contentView addSubview:_headImgView];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right + 10, (height - 2 * lableHeight)/2.0, 200, lableHeight)];
        _name.text = @"李某某";
        _name.font = [UIFont systemFontOfSize:14];
        _name.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_name];
        
        _duty = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right + 10, _name.bottom, 200, lableHeight)];
        _duty.text = @"xxxxxxxxxxxxx校长";
        _duty.textColor = [UIColor lightGrayColor];
        _duty.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_duty];
        
        _arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(290, (height - 12) / 2.0, 8, 12)];
        _arrowImgView.image = [UIImage imageNamed:@"list_arrow_right_gray"];
        [self.contentView addSubview:_arrowImgView];
        
        _comment = [[UILabel alloc] initWithFrame:CGRectMake(_duty.right + 10, (height - 2 * lableHeight)/2.0, 100, lableHeight)];
        _comment.text = @"评论数：";
        _comment.font = [UIFont systemFontOfSize:14];
        _comment.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_comment];
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
    _duty.frame = CGRectMake(_headImgView.right + 10, _name.bottom, 200 - 50, lableHeight);
    _arrowImgView.frame = CGRectMake(290, (height - 12) / 2.0, 8, 12);
    _comment.frame = CGRectMake(_duty.right, _duty.top, 80, lableHeight);
    
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
    self.name.text = nameStr;
    NSString *dutyString = [params objectForKey:@"signature"];
    self.duty.text = dutyString;
    
    if (self.isFans) {
        self.comment.text = [NSString stringWithFormat:@"粉丝数:%d",[[params objectForKey:@"value"] intValue]];
    }else{
        self.comment.text = [NSString stringWithFormat:@"评论数:%d",[[params objectForKey:@"value"] intValue]];
    }
}

@end
