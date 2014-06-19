//
//  MyVisitorCell.h
//  QXH
//
//  Created by ZhaoLilong on 5/19/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VistorModel.h"

@interface MyVisitorCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *portraitView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
- (void)setVistor:(VistorModel *)vistor;
@end
