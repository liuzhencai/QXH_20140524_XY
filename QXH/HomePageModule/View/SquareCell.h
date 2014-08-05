//
//  SquareCell.h
//  QXH
//
//  Created by ZhaoLilong on 14-5-5.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquareInfo.h"

@interface SquareCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *portraitView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (void)setCellData:(SquareInfo *)model;

@end
