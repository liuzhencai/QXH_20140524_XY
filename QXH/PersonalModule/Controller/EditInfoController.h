//
//  EditInfoController.h
//  QXH
//
//  Created by ZhaoLilong on 6/28/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "MyViewController.h"

@protocol ChangeUserInfoDelgate <NSObject>

- (void)changeValue:(NSString *)value WithIndex:(NSInteger)index;

@end

@interface EditInfoController : MyViewController<UIAlertViewDelegate>
{
    NSString *defaultValue;
}

@property (nonatomic, weak) id<ChangeUserInfoDelgate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *infoField;

@property (nonatomic, assign) NSInteger selectedIndex;

- (IBAction)save:(id)sender;

@end
