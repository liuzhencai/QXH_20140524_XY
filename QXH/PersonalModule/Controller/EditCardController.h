//
//  EditCardController.h
//  QXH
//
//  Created by ZhaoLilong on 14-5-8.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditCardController : MyViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *editTable;
@property (nonatomic,  strong) NSMutableArray *valueArr;

/*定义是从注册界面跳转过来的*/
@property (nonatomic,assign)BOOL UserRegisterState;

- (IBAction)click:(id)sender;

@end
