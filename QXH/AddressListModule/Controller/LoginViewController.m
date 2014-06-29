//
//  LoginViewController.m
//  QXH
//
//  Created by XueYong on 5/15/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "LoginViewController.h"
#import "UserRegisterViewController.h"
@interface LoginViewController ()

@end

#define FONT 16.0
#define TEXT_FILED_HEIGHT 30
#define HEIGHT_TO_TOP 40
#define WIDTH_TO_LEFT 20
@implementation LoginViewController

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
    self.title = @"登录";
    self.navigationController.navigationBar.translucent = NO;
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *custonButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [custonButton setTitle:@"注册" forState:UIControlStateNormal];
    [custonButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    custonButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [custonButton addTarget:self action:@selector(userRegister:) forControlEvents:UIControlEventTouchUpInside];
    custonButton.frame = CGRectMake(0, 0, 40, 30);
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:custonButton];
    self.navigationItem.rightBarButtonItem = leftButtonItem;
    // Do any additional setup after loading the view.
    
    UILabel *userName  = [[UILabel alloc] initWithFrame:CGRectMake(20, HEIGHT_TO_TOP, 70, TEXT_FILED_HEIGHT)];
    userName.text = @"用户名";
    userName.font = [UIFont systemFontOfSize:FONT];
    userName.backgroundColor = [UIColor clearColor];
    [self.view addSubview:userName];
    
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(userName.right, userName.top, 0.5, userName.height)];
    verticalLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:verticalLine];
    
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(userName.right + 20,HEIGHT_TO_TOP,180,TEXT_FILED_HEIGHT)]; // TBD
    _nameField.font = [UIFont systemFontOfSize:FONT];
    _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _nameField.placeholder = @"请输入用户名";//@"cellnumber/identifyID/email";
    _nameField.text = @"zhaolilong2012@gmail.com";
    _nameField.delegate = self;
    [self.view addSubview:_nameField];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(WIDTH_TO_LEFT, _nameField.bottom + 4, UI_SCREEN_WIDTH - 2 * WIDTH_TO_LEFT, 0.5)];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView1];
    
    UILabel *passWord  = [[UILabel alloc] initWithFrame:CGRectMake(20, HEIGHT_TO_TOP + TEXT_FILED_HEIGHT + 10, 70, TEXT_FILED_HEIGHT)];
    passWord.text = @"密码";
    passWord.font = [UIFont systemFontOfSize:FONT];
    [self.view addSubview:passWord];
    
    UIView *verticalLine2 = [[UIView alloc] initWithFrame:CGRectMake(passWord.right, passWord.top, 0.5, passWord.height)];
    verticalLine2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:verticalLine2];
    
    _pwField = [[UITextField alloc] initWithFrame:CGRectMake(passWord.right + 20, HEIGHT_TO_TOP + TEXT_FILED_HEIGHT + 10, 180, TEXT_FILED_HEIGHT)];
    _pwField.font = [UIFont systemFontOfSize:FONT];
    _pwField.placeholder = @"请输入密码";//@"password";
    _pwField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _pwField.delegate = self;
    _pwField.secureTextEntry = YES;
    _pwField.text = @"123456";
    [self.view addSubview:_pwField];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(WIDTH_TO_LEFT, _pwField.bottom + 4, UI_SCREEN_WIDTH - 2 * WIDTH_TO_LEFT, 0.5)];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView2];
    
    //登陆按钮
    UIButton *login = [UIButton buttonWithType:UIButtonTypeCustom];
    login.frame = CGRectMake((UI_SCREEN_WIDTH - 267)/2.0, HEIGHT_TO_TOP + 160, 267, 40);
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    login.titleLabel.font = [UIFont systemFontOfSize:18];
    [login setTitle:@"登录" forState:UIControlStateNormal];
    [login setBackgroundImage:[UIImage imageNamed:@"btn_login_normal"] forState:UIControlStateNormal];
    [login setBackgroundImage:[UIImage imageNamed:@"btn_login_highlight"] forState:UIControlStateHighlighted];
    [login addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
//    login.backgroundColor = [UIColor greenColor];
    [self.view addSubview:login];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)login:(id)sender{
    NSLog(@"login");
    if ([self.nameField.text length] <= 0) {
        [self showAlert:@"请输入用户名"];
        return;
    }
    if ([self.pwField.text length] <= 0) {
        [self showAlert:@"请输入密码"];
        return;
    }
    
    [DataInterface login:self.nameField.text andPswd:self.pwField.text withCompletinoHandler:^(NSMutableDictionary *dict) {
        //登录成功后保存用户名和密码
        [defaults setObject:self.nameField.text forKey:USER_NAME];
        [defaults setObject:self.pwField.text forKey:PASSWORLD];
        [defaults setObject:[dict objectForKey:@"userid"] forKey:@"userid"];
        [defaults setObject:[dict objectForKey:@"token"] forKey:@"token"];
        [defaults setObject:@NO forKey:@"isNewMember"];
        NSDate *date = [NSDate date];
        [defaults setObject:date forKey:LOGIN_DATE];
        [defaults synchronize];
        NSLog(@"登陆返回信息：%@",dict);
        [self showAlert:[dict objectForKey:@"info"]];
        if (self.delegate) {
            [self.delegate didLoginHandle:self];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)userRegister:(id)sender{
    NSLog(@"register");
    UserRegisterViewController *userRegister = [[UserRegisterViewController alloc] init];
    userRegister.registerCallBack = ^(NSMutableDictionary *dict) {
        [self.navigationController popViewControllerAnimated:NO];
        if (self.delegate) {
            [self.delegate didLoginHandle:self];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    };
    [self.navigationController pushViewController:userRegister animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _nameField) {
        [_pwField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_nameField resignFirstResponder];
    [_pwField resignFirstResponder];
}

@end
