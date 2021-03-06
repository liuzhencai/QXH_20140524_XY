//
//  SquareShareController.m
//  QXH
//
//  Created by ZhaoLilong on 5/18/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "SquareShareController.h"
#import "MJRefresh.h"
#import "SelectPeopleController.h"
#import "NameCardViewController.h"
#import "MyCardController.h"

@interface SquareShareController ()
@property (nonatomic, strong) SNImagePickerNC *imagePickerNavigationController;
@property (nonatomic, strong) UIImagePickerController *cameraPicker;
@property (nonatomic, strong) NSMutableArray *imgs;
@property (nonatomic, strong) NSArray *atPersonList;
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
    _addPicBtn.frame = CGRectMake(14.f, 14.f, 47, 47);
    [_picView addSubview:_addPicBtn];
    _atPersonScroll.frame = CGRectMake(138, 209, 164, 48);
    [self.view addSubview:_atPersonScroll];
    _imgs = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImagePickerController *) cameraPicker{
    if(!_cameraPicker){
        _cameraPicker = [[UIImagePickerController alloc] init];
        _cameraPicker.delegate = self;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            _cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else{
            _cameraPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    return _cameraPicker;
}

- (void)callCamera
{
    if (IOS7_OR_LATER) {
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
            if ([self cameraPicker]) {
                [self presentViewController:_cameraPicker animated:YES completion:^{
                    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
                    [self.navigationController setNavigationBarHidden:YES];
                }];
            }
        }else if(authStatus == AVAuthorizationStatusNotDetermined){
            // Explicit user permission is required for media capture, but the user has not yet granted or denied such permission.
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                if(granted){//点击允许访问时调用
                    //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                    NSLog(@"Granted access to %@", mediaType);
                    if ([self cameraPicker]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self presentViewController:_cameraPicker animated:YES completion:^{}];
                        });
                    }
                }
                else {
                    NSLog(@"Not granted access to %@", mediaType);
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"请在设备的'设置-隐私-相机'中允许访问相机"
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            }];
        }else {
            NSLog(@"Unknown authorization status");
        }
    }else{
        if ([self cameraPicker]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:_cameraPicker animated:YES completion:^{}];
            });
        }
    }
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
            [self callCamera];
        }
            break;
        case 1:
        {
            /**
             *  相册
             */
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SNPicker" bundle:nil];
            self.imagePickerNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"ImagePickerNC"];
            [self.imagePickerNavigationController setModalPresentationStyle:UIModalPresentationFullScreen];
            self.imagePickerNavigationController.imagePickerDelegate = self;
            self.imagePickerNavigationController.pickerType = kPickerTypePhoto;
            [self presentViewController:self.imagePickerNavigationController animated:YES completion:^{
            
            }];
        }
            break;
        default:
            break;
    }
}

- (void)updatePicView
{
    // 移除以前添加的视图
    for (UIView *v in _picView.subviews) {
        if ([v isKindOfClass:[UIImageView class]]) {
            [v removeFromSuperview];
        }
    }
    NSInteger picMax = 0;
    if ([_imgs count] > 4) {
        picMax = 4;
    }else {
        picMax = [_imgs count];
    }
    // 添加视图
    for (int i = 0; i < picMax; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((47.f+14.f)*i+14, 14.f, 47, 47)];
        imgView.image = _imgs[i];
        [_picView addSubview:imgView];
    }
    if (picMax >= 4) {
        _addPicBtn.hidden = YES;
    }else{
        _addPicBtn.hidden = NO;
        _addPicBtn.frame = CGRectMake(picMax*(14.f+47.f)+14.f, 14.f, 47, 47);
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *tmpImage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.5)];
    [self dismissViewControllerAnimated:YES completion:^{
        [_imgs addObject:tmpImage];
        [self updatePicView];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - SNImagePickerDelegate

- (void)imagePicker:(SNImagePickerNC *)imagePicker didFinishPickingWithMediaInfo:(NSMutableArray *)info
{
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    for (int i = 0; i < [info count]; i++) {
        [assetLibrary assetForURL:info[i] resultBlock:^(ALAsset *asset) {
            UIImage *image = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
            [_imgs addObject:image];
            [self updatePicView];
        } failureBlock:^(NSError *error) {}];
    }
}

- (void)imagePickerDidCancel:(SNImagePickerNC *)imagePicker
{

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.controller.squareTable headerBeginRefreshing];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)distributeSquareInfo:(NSString *)artimgs
{
    [_contentField resignFirstResponder];
    NSString* string = _contentField.text;
    [DataInterface distributeInfo:@"" tags:@"" type:@"1" artimgs:artimgs arttype:@"" content:string withCompletionHandler:^(NSMutableDictionary *dict) {
        _distributeBtn.userInteractionEnabled = YES;
        NSString *stateCode = [NSString stringWithFormat:@"%@",[dict objectForKey:@"statecode"]];
        if ([stateCode isEqualToString:@"0200"]) {
            NSString *artid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"artid"]];//[dict objectForKey:@"artid"];
            [self shareToSomebodyByArtid:artid];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:[dict objectForKey:@"info"]
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)shareToSomebodyByArtid:(NSString *)artid{
    /**
     *  分享内容
     *  @param sourceid    广场消息的唯一标示
     *  @param sourcetype  1为广场文章，2为咨询分享，3为活动分享,4为名片分享
     *  @param sharetype   1为分享给好友，2为分享给部落
     *  @param targetid    分享给好友或部落的id，如果为多个好友或部落，中间以逗号隔开
     *  @param callback 回调
     */

    if (_atPersonList && [_atPersonList count]) {
        NSString *targetids = @"";
        for (int i = 0; i < [_atPersonList count]; i ++) {
            NSDictionary *memberDict = [_atPersonList objectAtIndex:i];
            NSString *userId = [NSString stringWithFormat:@"%@",[memberDict objectForKey:@"userid"]];//[memberDict objectForKey:@"userid"];
            targetids = [targetids stringByAppendingString:userId];
            if (i != [_atPersonList count] - 1) {
                targetids = [targetids stringByAppendingString:@","];
            }
        }
        [DataInterface shareContent:artid
                         sourcetype:@"1"
                          sharetype:@"1"
                           targetid:targetids
              withCompletionHandler:^(NSMutableDictionary *dict){
//                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:@"info"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                  [alert show];
              }];
    }
}

- (NSString *)mergeUrl:(NSArray *)urls
{
    NSMutableString *tmpStr = [[NSMutableString alloc] init];
    for (NSString *str in urls) {
        if (![str isEqualToString:[urls lastObject]]) {
            [tmpStr appendFormat:@"%@,",str];
        }else{
            [tmpStr appendString:str];
        }
    }
    return [NSString stringWithFormat:@"%@",tmpStr];
}

- (IBAction)distribute:(id)sender {
    _distributeBtn.userInteractionEnabled = NO;
    __block NSString *artimgs = @"";
    if ([_imgs count]!=0) {
        [HttpRequest uploadFiles:_imgs andType:@"1" andCompletionBlock:^(NSMutableArray *list) {
            [self distributeSquareInfo:[self mergeUrl:list]];
        }];
    }else{
        [self distributeSquareInfo:artimgs];
    }
}

- (IBAction)selectImage:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择取图片路径" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)selectPeople:(id)sender {
    SelectPeopleController *controller = [[SelectPeopleController alloc] init];
    controller.selectedPerson = [_atPersonList copy];
    controller.callback = ^(NSArray *persons){
        NSLog(@"persons--->%@",persons);
        _atPersonList = persons;
        [self updateAtPersonScroll];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)updateAtPersonScroll
{
    for (UIView *v in _atPersonScroll.subviews) {
        [v removeFromSuperview];
    }
    if ([_atPersonList count] > 0) {
        _atPersonScroll.contentSize = CGSizeMake(([_atPersonList count]+1)*(PORTRAIT_GAP+48), 48);
        for (int i = 0; i < [_atPersonList count]; i++) {
            UIImageView *personPortrait = [[UIImageView alloc] initWithFrame:CGRectMake((i+1)*PORTRAIT_GAP+48*i, 0, 48, 48)];
            [personPortrait setRound:YES];
            personPortrait.userInteractionEnabled = YES;
            NSDictionary *dict = _atPersonList[i];
            [personPortrait setImageWithURL:IMGURL([dict objectForKey:@"photo"]) placeholderImage:[UIImage imageNamed:@"img_portrait_recommend96"]];
            personPortrait.tag = 1000+i;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPortrait:)];
            [personPortrait addGestureRecognizer:tapGesture];
            [_atPersonScroll addSubview:personPortrait];
        }
    }
}

- (void)clickPortrait:(UITapGestureRecognizer *)sender
{
    UIImageView *portraitView_ = (UIImageView *)sender.view;
    NSDictionary *dict = _atPersonList[portraitView_.tag - 1000];
    if ([dict[@"userid"] integerValue] != [[defaults objectForKey:@"userid"] integerValue]) {
        NameCardViewController *controller = [[NameCardViewController alloc]init];
        NSDictionary *item = [NSDictionary dictionaryWithObject:dict[@"userid"] forKey:@"userid"];
        controller.memberDict = item;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        MyCardController *controller = [[MyCardController alloc] initWithNibName:@"MyCardController" bundle:nil];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    int lengthLimit = 140;
    if (lengthLimit && textField.text.length >= lengthLimit) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_contentField resignFirstResponder];
}
@end
