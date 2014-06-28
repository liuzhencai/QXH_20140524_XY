//
//  SquareViewController.h
//  QXH
//
//  Created by ZhaoLilong on 14-5-4.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SquareViewController : MyViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *everyDayAskContentLbl;
@property (weak, nonatomic) IBOutlet UILabel *everyDayAskDateLbl;
@property (weak, nonatomic) IBOutlet UIImageView *everyDayAskImg;
@property (weak, nonatomic) IBOutlet UIButton *lastestBtn;
@property (weak, nonatomic) IBOutlet UIButton *hotBtn;
@property (weak, nonatomic) IBOutlet UITableView *squareTable;
@property (weak, nonatomic) IBOutlet UIImageView *slipbar;
@property (strong, nonatomic) IBOutlet UIView *everydayAskView;
- (IBAction)btnClick:(id)sender;
- (IBAction)history:(id)sender;

@end
