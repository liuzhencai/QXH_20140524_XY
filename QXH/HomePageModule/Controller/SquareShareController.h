//
//  SquareShareController.h
//  QXH
//
//  Created by ZhaoLilong on 5/18/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNImagePickerNC.h"

@interface SquareShareController : MyViewController<UIActionSheetDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, SNImagePickerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *picView;
@property (weak, nonatomic) IBOutlet UITextField *contentField;
@property (weak, nonatomic) IBOutlet UIButton *addPicBtn;
- (IBAction)distribute:(id)sender;
- (IBAction)selectImage:(id)sender;

@end
