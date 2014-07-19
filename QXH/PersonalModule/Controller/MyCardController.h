//
//  MyCardController.h
//  QXH
//
//  Created by ZhaoLilong on 14-5-8.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCardController : MyViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *cardTable;
@property (weak, nonatomic) IBOutlet UIImageView *portraitView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

- (IBAction)btnClicked:(id)sender;

- (void)transmitNameCard:(NSString *)tribeid;

@end
