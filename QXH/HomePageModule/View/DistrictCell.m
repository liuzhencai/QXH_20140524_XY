//
//  DistrictCell.m
//  ExpansionTableView
//
//  Created by XUE on 14-5-19.
//  Copyright (c) 2014年 JianYe. All rights reserved.
//

#import "DistrictCell.h"

@implementation DistrictCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width - 20, self.height)];
//        _titleLabel.backgroundColor = [UIColor redColor];
//        _titleLabel.backgroundColor = COLOR_WITH_ARGB(240, 240, 240, 1.0);
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_titleLabel];
        self.backgroundColor = COLOR_WITH_ARGB(240, 240, 240, 1.0);
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

@end
