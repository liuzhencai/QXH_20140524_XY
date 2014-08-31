//
//  RecInformationCell.h
//  QXH
//
//  Created by ZhaoLilong on 6/17/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoModel.h"

@interface RecInformationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *portraitImg;
@property (weak, nonatomic) IBOutlet UILabel *recPersonname;
@property (weak, nonatomic) IBOutlet UILabel *recPerson;
@property (weak, nonatomic) IBOutlet UILabel *artTitle;
@property (weak, nonatomic) IBOutlet UILabel *artDate;
@property (weak, nonatomic) IBOutlet UIImageView *artImg;

- (void)setCellData:(InfoModel *)data;

@end
