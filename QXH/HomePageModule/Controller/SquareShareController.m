//
//  SquareShareController.m
//  QXH
//
//  Created by ZhaoLilong on 5/18/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "SquareShareController.h"

@interface SquareShareController ()

- (void)distributeInfoWithArtType:(NSString *)arttype;

@end

@implementation SquareShareController

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
    self.title = @"发分享";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)distribute:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [alert show];
}

- (void)distributeInfoWithArtType:(NSString *)arttype
{
    NSString *userid = @"123456";
    NSString *token = @"ab123456789";
    NSString *string = @"content";
    NSDictionary *param = @{@"opercode": @"0120",@"userid":userid,@"token":token, @"type":@"1",  @"tag":@"标签", @"arttype":arttype, @"content":string};
    [HttpRequest requestWithParams:param andCompletionHandler:^(NSMutableDictionary *dict) {
        
    }];

}

@end
