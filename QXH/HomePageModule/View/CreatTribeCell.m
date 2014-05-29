//
//  CreatTribeCell.m
//  QXH
//
//  Created by XueYong on 5/20/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "CreatTribeCell.h"
#import "UIImageView+WebCache.h"

@implementation CreatTribeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGFloat height = 80;
        CGFloat lableHeight = 20;
        
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = CGRectMake(10, (height - 12)/2.0, 12, 12);
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"choice_box"] forState:UIControlStateNormal];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"tribe_btn_nextstep_normal"] forState:UIControlStateSelected];
//        [_selectBtn addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectBtn];
        
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_selectBtn.right + 10, (height - 48)/2.0, 48, 48)];
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
        
        _creatMan = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right + 10, _dynamic.bottom, 200, lableHeight)];
        _creatMan.text = @"创建人：zyj";
        _creatMan.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_creatMan];
        
        _arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(290, (height - 12) / 2.0, 8, 12)];
        _arrowImgView.hidden = YES;
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

- (void)selected:(UIButton *)sender{
    NSLog(@"selected");
//    sender.selected = !sender.selected;
//    if (sender.selected) {
//        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"tribe_btn_nextstep_normal"] forState:UIControlStateNormal];
////        [];
//    }else{
//        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"choice_box"] forState:UIControlStateNormal];
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectWithIndexPath:)]) {
//        NSIndexPath *indexPath = [self index];
//        [self.delegate didSelectWithIndexPath:self.indexPath];
    }
}

- (void)resetCellParamDict:(id)objt{

    [self.headImgView setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
    self.name.text = @"北约 （50人）";
    self.dynamic.text = @"最新发言内容最新发言内容最新发言内容最新发言内容";
    self.creatMan.text = @"创建人：zyj";
    
}

@end
