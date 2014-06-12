//
//  InformationDetailController.h
//  QXH
//
//  Created by ZhaoLilong on 5/18/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, InfomationType) {
    InfomationTypeNormal,   // 普通
    InfomationTypeRecommend // 推荐
};

@interface InformationDetailController : MyViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *articleTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *authLabel;
@property (weak, nonatomic) IBOutlet UILabel *readNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic, assign) InfomationType type;
@property (nonatomic, copy) NSString *artid;
@property (strong, nonatomic) IBOutlet UIView *toolbarView;
@property (strong, nonatomic) IBOutlet UIView *recommendView;
@property (strong, nonatomic) IBOutlet UIView *informationDetailView;
- (IBAction)click:(id)sender;
- (IBAction)showAll:(id)sender;

@end
