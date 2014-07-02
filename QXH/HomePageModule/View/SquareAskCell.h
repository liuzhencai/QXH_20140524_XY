//
//  SquareAskCell.h
//  QXH
//
//  Created by ZhaoLilong on 7/2/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SquareAskCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *askImg;
- (void)setCellData:(SquareInfo *)model;
@end
