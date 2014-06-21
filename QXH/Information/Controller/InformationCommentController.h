//
//  InformationCommentController.h
//  QXH
//
//  Created by ZhaoLilong on 5/18/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationCommentController : MyViewController<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *commentTbl;
@property (strong, nonatomic) IBOutlet UIView *commentView;
@property (nonatomic, copy) NSString *artid;
- (IBAction)hideComment:(id)sender;

@end
