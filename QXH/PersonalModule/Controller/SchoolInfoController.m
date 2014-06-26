//
//  SchoolInfoController.m
//  QXH
//
//  Created by ZhaoLilong on 5/19/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "SchoolInfoController.h"

@interface SchoolInfoController ()

@end

@implementation SchoolInfoController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"学校信息";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender {
    NSLog(@"保存");
    NSString *schoolname = [_schoolname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (schoolname.length == 0) {
        [self showAlert:@"请输入学校名称"];
    }
    NSString *job = [_schooljob.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (job.length == 0) {
        [self showAlert:@"请输入学校职务"];
    }
    [DataInterface modifyUserInfo:ORIGIN_VAL oldpwd:ORIGIN_VAL newpwd:ORIGIN_VAL signature:ORIGIN_VAL title:job degree:ORIGIN_VAL address:ORIGIN_VAL domicile:ORIGIN_VAL introduce:ORIGIN_VAL comname:ORIGIN_VAL comdesc:ORIGIN_VAL comaddress:ORIGIN_VAL comurl:ORIGIN_VAL induname:ORIGIN_VAL indudesc:ORIGIN_VAL schoolname:schoolname schooltype:ORIGIN_VAL sex:ORIGIN_VAL photo:ORIGIN_VAL email:ORIGIN_VAL tags:ORIGIN_VAL attentiontags:ORIGIN_VAL hobbies:ORIGIN_VAL educations:ORIGIN_VAL honours:ORIGIN_VAL usertype:ORIGIN_VAL gold:ORIGIN_VAL level:ORIGIN_VAL configure:ORIGIN_VAL withCompletionHandler:^(NSMutableDictionary *dict) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
@end
