//
//  EditCardController.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-8.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "EditCardController.h"
#import "SchoolInfoController.h"
#import "CityViewController.h"
#import "SelfIntroduceController.h"
#import "HobbyViewController.h"
#import "StudyExperienceController.h"
#import "PhoneViewController.h"
#import "EverGloryController.h"

@interface EditCardController ()
{
    NSArray *titleArr;
    NSDictionary *userinfo;
}

@property (strong, nonatomic) SNImagePickerNC *imagePickerNavigationController;

@end

@implementation EditCardController
@synthesize UserRegisterState;

@synthesize valueArr;

- (void)viewWillAppear:(BOOL)animated
{
    if(UserRegisterState)
    {
        
    }else{
        [self loadData];
    }

}

- (void)loadData
{
    [DataInterface getUserInfo:[defaults objectForKey:@"userid"] withCompletionHandler:^(NSMutableDictionary *dict) {
        userinfo = dict;
        NSString *phone = [userinfo objectForKey:@"phone"];
        if ([phone isEqualToString:@""]) {
            phone = @"无手机号";
        }
        valueArr = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%@ %@",[userinfo objectForKey:@"schoolname"],[userinfo objectForKey:@"title"]], [NSString stringWithFormat:@"%@",[userinfo objectForKey:@"domicile"]], [userinfo objectForKey:@"introduce"], [userinfo objectForKey:@"hobbies"], [userinfo objectForKey:@"educations"], phone, [userinfo objectForKey:@"honours"], nil];
        [_portraitView circular];
        [_portraitView setImageWithURL:IMGURL([userinfo objectForKey:@"photo"]) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
        [_editTable reloadData];
    }];
}

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
    if (!self.title) {
        self.title = @"编辑名片";
    }

    _editTable.tableHeaderView = _topView;
    
    titleArr = @[@"学校信息（必填）", @"城市（必填）", @"自我介绍", @"兴趣爱好", @"学习经历", @"手机号", @"曾获荣誉"];
    
//    valueArr = [[NSMutableArray alloc] initWithObjects:@"北京市智障二中 校长", @"北京", @"您的详细介绍", @"您的兴趣爱好", @"您的教育经历", @"您的手机号", @"曾经获得的社会荣誉", nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArr count]+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0.f;
    if (indexPath.row == 0) {
        rowHeight = 30;
    }else{
        rowHeight = 48;
    }
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"firstCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
            label.backgroundColor = RGBCOLOR(236, 245, 229);
            label.text = @"详细个人信息";
            label.textColor = GREEN_FONT_COLOR;
            [cell.contentView addSubview:label];
        }
    }else{
        static NSString *cellIdentifier = @"otherCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 21)];
            titleLabel.tag = 1;
            
            UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 22, 200, 21)];
            descLabel.font = [UIFont systemFontOfSize:14.f];
            descLabel.textColor = [UIColor grayColor];
            descLabel.tag = 2;
            
            UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 13.5, 100, 21)];
            statusLabel.textColor = [UIColor grayColor];
            statusLabel.tag = 3;
            
            UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(300, 17, 7.5, 12.5)];
            arrowImage.image = [UIImage imageNamed:@"list_arrow_right_green"];
            
            [cell.contentView addSubview:titleLabel];
            [cell.contentView addSubview:descLabel];
            [cell.contentView addSubview:statusLabel];
            [cell.contentView addSubview:arrowImage];
        }
        
        UILabel *titleLabel_ = (UILabel *)[cell.contentView viewWithTag:1];
        UILabel *descLabel_ = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *statusLabel_ = (UILabel *)[cell.contentView viewWithTag:3];

        titleLabel_.text = [titleArr objectAtIndex:indexPath.row-1];
        descLabel_.text = [valueArr objectAtIndex:indexPath.row-1];
        statusLabel_.text = @"已填写";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    switch (row) {
        case 1:
        {
            SchoolInfoController *controller = [[SchoolInfoController alloc] initWithNibName:@"SchoolInfoController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 2:
        {
            CityViewController *controller = [[CityViewController alloc] initWithNibName:@"CityViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 3:
        {
            SelfIntroduceController *controller = [[SelfIntroduceController alloc]initWithNibName:@"SelfIntroduceController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 4:
        {
            HobbyViewController *controller = [[HobbyViewController alloc] initWithNibName:@"HobbyViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 5:
        {
            StudyExperienceController *controller = [[StudyExperienceController alloc] initWithNibName:@"StudyExperienceController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 6:
        {
            PhoneViewController *controller = [[PhoneViewController alloc] initWithNibName:@"PhoneViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 7:
        {
            EverGloryController *controller = [[EverGloryController alloc] initWithNibName:@"EverGloryController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}

- (IBAction)click:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"拍照");
        }
            break;
        case 1:
        {
            NSLog(@"从相册选取");
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SNPicker" bundle:nil];
            self.imagePickerNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"ImagePickerNC"];
            [self.imagePickerNavigationController setModalPresentationStyle:UIModalPresentationFullScreen];
            self.imagePickerNavigationController.imagePickerDelegate = self;
            self.imagePickerNavigationController.pickerType = kPickerTypePhoto;
            [self presentViewController:self.imagePickerNavigationController animated:YES completion:^{ }];
        }
            break;
        default:
            break;
    }
}

- (void)callCamera
{
    NSString *mediaType = AVMediaTypeVideo;// Or AVMediaTypeAudio
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    NSLog(@"---cui--authStatus--------%d",authStatus);
    // This status is normally not visible—the AVCaptureDevice class methods for discovering devices do not return devices the user is restricted from accessing.
    if(authStatus ==AVAuthorizationStatusRestricted){
        NSLog(@"Restricted");
    }else if(authStatus == AVAuthorizationStatusDenied){
        // The user has explicitly denied permission for media capture.
        NSLog(@"Denied");     //应该是这个，如果不允许的话
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请在设备的\"设置-隐私-相机\"中允许访问相机。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if(authStatus == AVAuthorizationStatusAuthorized){//允许访问
        // The user has explicitly granted permission for media capture, or explicit user permission is not necessary for the media type in question.
        NSLog(@"Authorized");
        
    }else if(authStatus == AVAuthorizationStatusNotDetermined){
        // Explicit user permission is required for media capture, but the user has not yet granted or denied such permission.
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted){//点击允许访问时调用
                //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                NSLog(@"Granted access to %@", mediaType);
            }
            else {
                NSLog(@"Not granted access to %@", mediaType);
            }
            
        }];
    }else {
        NSLog(@"Unknown authorization status");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self modifyUserPortrait:image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)modifyUserPortrait:(UIImage *)image
{
    [DataInterface fileUpload:image type:@"1" withCompletionHandler:^(NSMutableDictionary *dict) {
        [DataInterface modifyUserInfo:ORIGIN_VAL oldpwd:ORIGIN_VAL newpwd:ORIGIN_VAL signature:ORIGIN_VAL title:ORIGIN_VAL degree:ORIGIN_VAL address:ORIGIN_VAL domicile:ORIGIN_VAL introduce:ORIGIN_VAL comname:ORIGIN_VAL comdesc:ORIGIN_VAL comaddress:ORIGIN_VAL comurl:ORIGIN_VAL induname:ORIGIN_VAL indudesc:ORIGIN_VAL schoolname:ORIGIN_VAL schooltype:ORIGIN_VAL sex:ORIGIN_VAL photo:[dict objectForKey:@"filename"] email:ORIGIN_VAL tags:ORIGIN_VAL attentiontags:ORIGIN_VAL hobbies:ORIGIN_VAL educations:ORIGIN_VAL honours:ORIGIN_VAL usertype:ORIGIN_VAL gold:ORIGIN_VAL level:ORIGIN_VAL configure:ORIGIN_VAL withCompletionHandler:^(NSMutableDictionary *dict) {
            [self loadData];
        }];
    } errorBlock:^(NSString *desc) {
        
    }];
}

#pragma mark - SNImagePickerDelegate

- (void)imagePicker:(SNImagePickerNC *)imagePicker didFinishPickingWithMediaInfo:(NSMutableArray *)info
{
     ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
     [assetLibrary assetForURL:[info lastObject] resultBlock:^(ALAsset *asset) {
         UIImage *image = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
         [self modifyUserPortrait:image];
     } failureBlock:^(NSError *error) {}];
}

- (void)imagePickerDidCancel:(SNImagePickerNC *)imagePicker
{
    
}


@end
