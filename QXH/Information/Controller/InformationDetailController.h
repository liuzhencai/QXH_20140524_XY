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

@interface InformationDetailController : MyViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) InfomationType type;

@property (strong, nonatomic) IBOutlet UIView *toolbarView;
@property (strong, nonatomic) IBOutlet UIView *recommendView;
@property (strong, nonatomic) IBOutlet UIView *informationDetailView;
- (IBAction)click:(id)sender;
- (IBAction)showAll:(id)sender;

@end
