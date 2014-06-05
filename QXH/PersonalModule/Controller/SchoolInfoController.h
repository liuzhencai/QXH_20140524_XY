//
//  SchoolInfoController.h
//  QXH
//
//  Created by ZhaoLilong on 5/19/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "MyViewController.h"

@interface SchoolInfoController : MyViewController
- (IBAction)save:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *schoolname;
@property (weak, nonatomic) IBOutlet UITextField *schooljob;

@end
