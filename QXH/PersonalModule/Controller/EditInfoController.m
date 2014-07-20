//
//  EditInfoController.m
//  QXH
//
//  Created by ZhaoLilong on 6/28/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "EditInfoController.h"
#import "EditCardController.h"

@interface EditInfoController ()

@end

@implementation EditInfoController

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
    
    NSString *tmpValue = [((EditCardController *)self.delegate).valueArr objectAtIndex:self.selectedIndex-1];
    
    _infoField.text =  tmpValue;
    
    defaultValue = tmpValue;
    
    switch (self.selectedIndex-1) {
        case 0:
            self.title = @"真实姓名";
            break;
        case 1:
            self.title = @"个性签名";
            break;
        case 2:
            self.title = @"工作单位";
            break;
        case 3:
            self.title = @"城市信息";
            break;
        case 4:
            self.title = @"单位职务";
            break;
        case 5:
            self.title = @"兴趣爱好";
            break;
        case 6:
            self.title = @"毕业院校";
            break;
        case 7:
            self.title = @"手机号";
            break;
        case 8:
            self.title = @"曾获荣誉";
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _saveBtn.userInteractionEnabled = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showMsg:(NSDictionary *)dict
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"info"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (IBAction)save:(id)sender {
    
    // 如果文本域的值与默认值相等，则直接返回
    if ([defaultValue isEqualToString:_infoField.text]) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(changeValue:WithIndex:)]) {
        [self.delegate changeValue:_infoField.text WithIndex:_selectedIndex-1];
    }
    
    _saveBtn.userInteractionEnabled = NO;
    switch (self.selectedIndex-1) {
        case 0:
        {
            [DataInterface modifyUserInfo:_infoField.text
                                   oldpwd:ORIGIN_VAL
                                   newpwd:ORIGIN_VAL
                                signature:ORIGIN_VAL
                                    title:ORIGIN_VAL
                                   degree:ORIGIN_VAL
                                  address:ORIGIN_VAL
                                 domicile:ORIGIN_VAL
                                introduce:ORIGIN_VAL
                                  comname:ORIGIN_VAL
                                  comdesc:ORIGIN_VAL
                               comaddress:ORIGIN_VAL
                                   comurl:ORIGIN_VAL
                                 induname:ORIGIN_VAL
                                 indudesc:ORIGIN_VAL
                               schoolname:ORIGIN_VAL
                               schooltype:ORIGIN_VAL
                                      sex:ORIGIN_VAL
                                    photo:ORIGIN_VAL
                                    email:ORIGIN_VAL
                                     tags:ORIGIN_VAL
                            attentiontags:ORIGIN_VAL
                                  hobbies:ORIGIN_VAL
                               educations:ORIGIN_VAL
                                  honours:ORIGIN_VAL
                                 usertype:ORIGIN_VAL
                                     gold:ORIGIN_VAL
                                    level:ORIGIN_VAL
                                configure:ORIGIN_VAL
                    withCompletionHandler:^(NSMutableDictionary *dict) {
                        [self showMsg:dict];
                    }];
        }
            break;
        case 1:
        {
            [DataInterface modifyUserInfo:ORIGIN_VAL
                                   oldpwd:ORIGIN_VAL
                                   newpwd:ORIGIN_VAL
                                signature:_infoField.text
                                    title:ORIGIN_VAL
                                   degree:ORIGIN_VAL
                                  address:ORIGIN_VAL
                                 domicile:ORIGIN_VAL
                                introduce:ORIGIN_VAL
                                  comname:ORIGIN_VAL
                                  comdesc:ORIGIN_VAL
                               comaddress:ORIGIN_VAL
                                   comurl:ORIGIN_VAL
                                 induname:ORIGIN_VAL
                                 indudesc:ORIGIN_VAL
                               schoolname:ORIGIN_VAL
                               schooltype:ORIGIN_VAL
                                      sex:ORIGIN_VAL
                                    photo:ORIGIN_VAL
                                    email:ORIGIN_VAL
                                     tags:ORIGIN_VAL
                            attentiontags:ORIGIN_VAL
                                  hobbies:ORIGIN_VAL
                               educations:ORIGIN_VAL
                                  honours:ORIGIN_VAL
                                 usertype:ORIGIN_VAL
                                     gold:ORIGIN_VAL
                                    level:ORIGIN_VAL
                                configure:ORIGIN_VAL
                    withCompletionHandler:^(NSMutableDictionary *dict) {
                        [self showMsg:dict];
                    }];
        }
            break;
        case 2:
        {
            [DataInterface modifyUserInfo:ORIGIN_VAL
                                   oldpwd:ORIGIN_VAL
                                   newpwd:ORIGIN_VAL
                                signature:ORIGIN_VAL
                                    title:ORIGIN_VAL
                                   degree:ORIGIN_VAL
                                  address:ORIGIN_VAL
                                 domicile:ORIGIN_VAL
                                introduce:ORIGIN_VAL
                                  comname:_infoField.text
                                  comdesc:ORIGIN_VAL
                               comaddress:ORIGIN_VAL
                                   comurl:ORIGIN_VAL
                                 induname:ORIGIN_VAL
                                 indudesc:ORIGIN_VAL
                               schoolname:ORIGIN_VAL
                               schooltype:ORIGIN_VAL
                                      sex:ORIGIN_VAL
                                    photo:ORIGIN_VAL
                                    email:ORIGIN_VAL
                                     tags:ORIGIN_VAL
                            attentiontags:ORIGIN_VAL
                                  hobbies:ORIGIN_VAL
                               educations:ORIGIN_VAL
                                  honours:ORIGIN_VAL
                                 usertype:ORIGIN_VAL
                                     gold:ORIGIN_VAL
                                    level:ORIGIN_VAL
                                configure:ORIGIN_VAL
                    withCompletionHandler:^(NSMutableDictionary *dict) {
                        [self showMsg:dict];
                    }];
        }
            break;
        case 3:
        {
            [DataInterface modifyUserInfo:ORIGIN_VAL
                                   oldpwd:ORIGIN_VAL
                                   newpwd:ORIGIN_VAL
                                signature:ORIGIN_VAL
                                    title:ORIGIN_VAL
                                   degree:ORIGIN_VAL
                                  address:_infoField.text
                                 domicile:_infoField.text
                                introduce:ORIGIN_VAL
                                  comname:ORIGIN_VAL
                                  comdesc:ORIGIN_VAL
                               comaddress:ORIGIN_VAL
                                   comurl:ORIGIN_VAL
                                 induname:ORIGIN_VAL
                                 indudesc:ORIGIN_VAL
                               schoolname:ORIGIN_VAL
                               schooltype:ORIGIN_VAL
                                      sex:ORIGIN_VAL
                                    photo:ORIGIN_VAL
                                    email:ORIGIN_VAL
                                     tags:ORIGIN_VAL
                            attentiontags:ORIGIN_VAL
                                  hobbies:ORIGIN_VAL
                               educations:ORIGIN_VAL
                                  honours:ORIGIN_VAL
                                 usertype:ORIGIN_VAL
                                     gold:ORIGIN_VAL
                                    level:ORIGIN_VAL
                                configure:ORIGIN_VAL
                    withCompletionHandler:^(NSMutableDictionary *dict) {
                        [self showMsg:dict];
                    }];
        }
            break;
        case 4:
        {
            [DataInterface modifyUserInfo:ORIGIN_VAL
                                   oldpwd:ORIGIN_VAL
                                   newpwd:ORIGIN_VAL
                                signature:ORIGIN_VAL
                                    title:_infoField.text
                                   degree:ORIGIN_VAL
                                  address:ORIGIN_VAL
                                 domicile:ORIGIN_VAL
                                introduce:ORIGIN_VAL
                                  comname:ORIGIN_VAL
                                  comdesc:ORIGIN_VAL
                               comaddress:ORIGIN_VAL
                                   comurl:ORIGIN_VAL
                                 induname:ORIGIN_VAL
                                 indudesc:ORIGIN_VAL
                               schoolname:ORIGIN_VAL
                               schooltype:ORIGIN_VAL
                                      sex:ORIGIN_VAL
                                    photo:ORIGIN_VAL
                                    email:ORIGIN_VAL
                                     tags:ORIGIN_VAL
                            attentiontags:ORIGIN_VAL
                                  hobbies:ORIGIN_VAL
                               educations:ORIGIN_VAL
                                  honours:ORIGIN_VAL
                                 usertype:ORIGIN_VAL
                                     gold:ORIGIN_VAL
                                    level:ORIGIN_VAL
                                configure:ORIGIN_VAL
                    withCompletionHandler:^(NSMutableDictionary *dict) {
                        [self showMsg:dict];
                    }];
        }
            break;
        case 5:
        {
            [DataInterface modifyUserInfo:ORIGIN_VAL
                                   oldpwd:ORIGIN_VAL
                                   newpwd:ORIGIN_VAL
                                signature:ORIGIN_VAL
                                    title:ORIGIN_VAL
                                   degree:ORIGIN_VAL
                                  address:ORIGIN_VAL
                                 domicile:ORIGIN_VAL
                                introduce:ORIGIN_VAL
                                  comname:ORIGIN_VAL
                                  comdesc:ORIGIN_VAL
                               comaddress:ORIGIN_VAL
                                   comurl:ORIGIN_VAL
                                 induname:ORIGIN_VAL
                                 indudesc:ORIGIN_VAL
                               schoolname:ORIGIN_VAL
                               schooltype:ORIGIN_VAL
                                      sex:ORIGIN_VAL
                                    photo:ORIGIN_VAL
                                    email:ORIGIN_VAL
                                     tags:ORIGIN_VAL
                            attentiontags:ORIGIN_VAL
                                  hobbies:_infoField.text
                               educations:ORIGIN_VAL
                                  honours:ORIGIN_VAL
                                 usertype:ORIGIN_VAL
                                     gold:ORIGIN_VAL
                                    level:ORIGIN_VAL
                                configure:ORIGIN_VAL
                    withCompletionHandler:^(NSMutableDictionary *dict) {
                        [self showMsg:dict];
                    }];
        }
            break;
        case 6:
        {
            [DataInterface modifyUserInfo:ORIGIN_VAL
                                   oldpwd:ORIGIN_VAL
                                   newpwd:ORIGIN_VAL
                                signature:ORIGIN_VAL
                                    title:ORIGIN_VAL
                                   degree:ORIGIN_VAL
                                  address:ORIGIN_VAL
                                 domicile:ORIGIN_VAL
                                introduce:ORIGIN_VAL
                                  comname:ORIGIN_VAL
                                  comdesc:ORIGIN_VAL
                               comaddress:ORIGIN_VAL
                                   comurl:ORIGIN_VAL
                                 induname:ORIGIN_VAL
                                 indudesc:ORIGIN_VAL
                               schoolname:ORIGIN_VAL
                               schooltype:ORIGIN_VAL
                                      sex:ORIGIN_VAL
                                    photo:ORIGIN_VAL
                                    email:ORIGIN_VAL
                                     tags:ORIGIN_VAL
                            attentiontags:ORIGIN_VAL
                                  hobbies:ORIGIN_VAL
                               educations:_infoField.text
                                  honours:ORIGIN_VAL
                                 usertype:ORIGIN_VAL
                                     gold:ORIGIN_VAL
                                    level:ORIGIN_VAL
                                configure:ORIGIN_VAL
                    withCompletionHandler:^(NSMutableDictionary *dict) {
                        [self showMsg:dict];
                    }];

        }
            break;
        case 7:
        {
            [DataInterface modifyUserInfo:ORIGIN_VAL
                                   oldpwd:ORIGIN_VAL
                                   newpwd:ORIGIN_VAL
                                signature:ORIGIN_VAL
                                    title:ORIGIN_VAL
                                   degree:ORIGIN_VAL
                                  address:ORIGIN_VAL
                                 domicile:ORIGIN_VAL
                                introduce:ORIGIN_VAL
                                  comname:ORIGIN_VAL
                                  comdesc:ORIGIN_VAL
                               comaddress:ORIGIN_VAL
                                   comurl:ORIGIN_VAL
                                 induname:ORIGIN_VAL
                                 indudesc:ORIGIN_VAL
                               schoolname:ORIGIN_VAL
                               schooltype:ORIGIN_VAL
                                      sex:ORIGIN_VAL
                                    photo:ORIGIN_VAL
                                    email:ORIGIN_VAL
                                     tags:ORIGIN_VAL
                            attentiontags:ORIGIN_VAL
                                  hobbies:ORIGIN_VAL
                               educations:ORIGIN_VAL
                                  honours:ORIGIN_VAL
                                 usertype:ORIGIN_VAL
                                     gold:ORIGIN_VAL
                                    level:ORIGIN_VAL
                                configure:ORIGIN_VAL
                    withCompletionHandler:^(NSMutableDictionary *dict) {
                        [self showMsg:dict];
                    }];
        }
            break;
        case 8:
        {
            [DataInterface modifyUserInfo:ORIGIN_VAL
                                   oldpwd:ORIGIN_VAL
                                   newpwd:ORIGIN_VAL
                                signature:ORIGIN_VAL
                                    title:ORIGIN_VAL
                                   degree:ORIGIN_VAL
                                  address:ORIGIN_VAL
                                 domicile:ORIGIN_VAL
                                introduce:ORIGIN_VAL
                                  comname:ORIGIN_VAL
                                  comdesc:ORIGIN_VAL
                               comaddress:ORIGIN_VAL
                                   comurl:ORIGIN_VAL
                                 induname:ORIGIN_VAL
                                 indudesc:ORIGIN_VAL
                               schoolname:ORIGIN_VAL
                               schooltype:ORIGIN_VAL
                                      sex:ORIGIN_VAL
                                    photo:ORIGIN_VAL
                                    email:ORIGIN_VAL
                                     tags:ORIGIN_VAL
                            attentiontags:ORIGIN_VAL
                                  hobbies:ORIGIN_VAL
                               educations:ORIGIN_VAL
                                  honours:_infoField.text
                                 usertype:ORIGIN_VAL
                                     gold:ORIGIN_VAL
                                    level:ORIGIN_VAL
                                configure:ORIGIN_VAL
                    withCompletionHandler:^(NSMutableDictionary *dict) {
                        [self showMsg:dict];
                    }];
        }
            break;
    }
}

@end
