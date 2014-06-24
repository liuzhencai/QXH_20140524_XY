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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex--->%d",buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            /**
             *  拍照
             */
        }
            break;
        case 2:
        {
            /**
             *  相册
             */
        }
            break;
        default:
            break;
    }
}

- (IBAction)distribute:(id)sender {
//  [DataInterface distributeInfo:<#(NSString *)#> tags:<#(NSString *)#> type:<#(NSString *)#> arttype:<#(NSString *)#> content:<#(NSString *)#> withCompletionHandler:<#^(NSMutableDictionary *dict)callback#>]
}

- (IBAction)selectImage:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择取图片路径" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [actionSheet showInView:self.view];
}

@end
