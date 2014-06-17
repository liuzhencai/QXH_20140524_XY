//
//  MultSelectPeopleCell.m
//  QXH
//
//  Created by XueYong on 6/7/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "MultSelectPeopleCell.h"

@implementation MultSelectPeopleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGFloat height = self.frame.size.height;
        CGFloat lableHeight = 25;
        
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = CGRectMake(10, (height - 12)/2.0, 12, 12);
//        _selectBtn.enabled = NO;
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"choice_box"] forState:UIControlStateNormal];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"tribe_btn_nextstep_normal"] forState:UIControlStateSelected];
        //        [_selectBtn addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectBtn];
        
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (height - 48)/2.0, 48, 48)];
        //    _headImgView.backgroundColor = [UIColor greenColor];
        _headImgView.image = [UIImage imageNamed:@"img_portrait96"];
        [self.contentView addSubview:_headImgView];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right + 10, (height - 2 * lableHeight)/2.0, 200, lableHeight)];
        _name.text = @"李某某";
        _name.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_name];
        
        _duty = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right + 10, _name.bottom, 200, lableHeight)];
        _duty.text = @"xxxxxxxxxxxxx校长";
        _duty.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_duty];
        
        _arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(290, (height - 12) / 2.0, 8, 12)];
        //        _arrowImgView.backgroundColor = [UIColor redColor];
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
    
    _selectBtn.frame = CGRectMake(10, (height - 12)/2.0, 12, 12);
    _headImgView.frame = CGRectMake(_selectBtn.right + 10, (height - 48)/2.0, 48, 48);
    _name.frame = CGRectMake(_headImgView.right + 10, (height - 2 * lableHeight)/2.0, 200, lableHeight);
    _duty.frame = CGRectMake(_headImgView.right + 10, _name.bottom, 200, lableHeight);
    _arrowImgView.frame = CGRectMake(290, (height - 12) / 2.0, 8, 12);
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)resetCellParamDict:(id)objt{
    [self.headImgView setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
    self.name.text = @"李某某";
    self.duty.text = @"xxxxxxxxxxxxx校长";
}
@end
