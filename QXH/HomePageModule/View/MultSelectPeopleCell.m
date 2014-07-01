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
        [_headImgView setRound:YES];
        _headImgView.image = [UIImage imageNamed:@"img_portrait96"];
        [self.contentView addSubview:_headImgView];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right + 10, (height - 2 * lableHeight)/2.0, 200, lableHeight)];
        _name.text = @"李某某";
        _name.font = [UIFont systemFontOfSize:14];
        _name.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_name];
        
        _duty = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right + 10, _name.bottom, 200, lableHeight)];
        _duty.text = @"xxxxxxxxxxxxx校长";
        _duty.font = [UIFont systemFontOfSize:14];
        _duty.textColor = [UIColor lightGrayColor];
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
    NSDictionary *dict = (NSDictionary *)objt;
    NSString *imageUrlString = [dict objectForKey:@"photo"];
//    [self.headImgView setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
    [self.headImgView setImageWithURL:IMGURL(imageUrlString) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];

    NSString *nameString = [dict objectForKey:@"displayname"];
//    if ([nameString length] > 0) {
        self.name.text = nameString;
//    }
    NSString *dutyString = [dict objectForKey:@"signature"];
//    if ([dutyString length] > 0) {
        self.duty.text = dutyString;
//    }
}
@end
