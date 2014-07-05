//
//  SquareNoPicCell.h
//  QXH
//
//  Created by ZhaoLilong on 7/2/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SquareNoPicCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *portraitView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (void)setCellData:(SquareInfo *)model;

@end
