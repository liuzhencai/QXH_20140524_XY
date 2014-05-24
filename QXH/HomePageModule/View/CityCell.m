//
//  CityCell.m
//  ExpansionTableView
//
//  Created by XUE on 14-5-19.
//  Copyright (c) 2014年 JianYe. All rights reserved.
//

#import "CityCell.h"

@implementation CityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (self.frame.size.height - 20)/2.0, 200, 20)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_titleLabel];
        
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(290, (self.frame.size.height - 12)/2.0, 8, 12)];
//        _arrowImageView.backgroundColor = [UIColor greenColor];
        _arrowImageView.image = [UIImage imageNamed:@"list_arrow_right_gray"];
        [self.contentView addSubview:_arrowImageView];

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

- (void)changeArrowWithUp:(BOOL)up
{
    if (up) {
        self.arrowImageView.image = [UIImage imageNamed:@"list_arrow_down_green"];
        self.arrowImageView.frame = CGRectMake(290, (self.frame.size.height - 8)/2.0, 12, 8);
//        self.arrowImageView.backgroundColor = [UIColor redColor];
    }else
    {
        self.arrowImageView.image = [UIImage imageNamed:@"list_arrow_right_gray"];
        self.arrowImageView.frame = CGRectMake(290, (self.frame.size.height - 12)/2.0, 8, 12);
//        self.arrowImageView.backgroundColor = [UIColor greenColor];
    }
}

@end
