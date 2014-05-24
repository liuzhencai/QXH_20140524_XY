//
//  CityCell.h
//  ExpansionTableView
//
//  Created by XUE on 14-5-19.
//  Copyright (c) 2014年 JianYe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

- (void)changeArrowWithUp:(BOOL)up;
@end
