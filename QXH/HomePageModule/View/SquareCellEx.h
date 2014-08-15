//
//  SquareCellEx.h
//  QXH
//
//  Created by ZhaoLilong on 5/20/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquareInfo.h"

@interface SquareCellEx : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *portraitView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *subImageView;

@property (weak, nonatomic) IBOutlet UIView *bomView;
- (IBAction)tap:(id)sender;
- (void)setCellData:(SquareInfo *)model withFlag:(NSInteger)flag;
+ (float)height:(SquareInfo *)model;
@end
