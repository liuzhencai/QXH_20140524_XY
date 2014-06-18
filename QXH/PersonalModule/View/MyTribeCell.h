//
//  MyTribeCell.h
//  QXH
//
//  Created by ZhaoLilong on 5/14/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTribeModel.h"

@interface MyTribeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *portraitView;
@property (weak, nonatomic) IBOutlet UILabel *tribeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *creator;
- (void)setModel:(MyTribeModel *)model;
@end
