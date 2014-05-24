//
//  InformationCommentController.h
//  QXH
//
//  Created by ZhaoLilong on 5/18/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationCommentController : MyViewController<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *commentView;
- (IBAction)hideComment:(id)sender;

@end
