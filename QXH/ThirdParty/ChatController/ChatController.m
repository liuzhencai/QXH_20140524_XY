//
//  ChatController.m
//  LowriDev
//
//  Created by Logan Wright on 3/17/14
//  Copyright (c) 2014 Logan Wright. All rights reserved.
//


/*
 Mozilla Public License
 Version 2.0
 */


#import "ChatController.h"
#import "MessageCell.h"
#import "MyMacros.h"
#import "MyTribeDetailViewController.h"
#import "UserInfoModelManger.h"
#import "MessageBySend.h"
//#import "chatRoomActivViewController.h"
//#import "chatRoomMemberViewController.h"



#define KTopButtonHight  0
#define KAskViewHight  0

#define CONVERSATION_TABLE_TAG 2330
#define ACTIVITY_TABLE_TAG 2331
#define NEMBERS_TABLE_TAG 2332


#define KInToChatRoomErrorTag  354

static NSString * kMessageCellReuseIdentifier = @"MessageCell";
//static int connectionStatusViewTag = 1701;
static int chatInputStartingHeight = 40;

//static int scout=0;

@interface ChatController ()

{
    // Used for scroll direction
    CGFloat lastContentOffset;
    /*记录被选中置顶的消息*/
    NSDictionary* mess;
    /*记录当前展示的界面的tag值*/
    NSInteger FrontViewTag;

    /*自己信息*/
    UserInfoModel* Myuserinfo;
    
    /*是否获取历史聊天记录*/
    BOOL hisState;
}

// View Properties
@property (strong, nonatomic) TopBar * topBar;
@property (strong, nonatomic) ChatInput * chatInput;
@property (strong, nonatomic) UICollectionView * myCollectionView;
@property (strong, nonatomic) SNImagePickerNC *imagePickerNavigationController;
@property(nonatomic, strong) UIImagePickerController *cameraPicker;
@end

@implementation ChatController
@synthesize opponentImg,otherDic,offMessageDic;

#pragma mark INITIALIZATION

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCustomView:(UIView *)customView
{
    self = [super init];
    if (self) {
        _topCustomView = customView;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [self.otherDic valueForKey:@"displayname"];
    
    /*默认当前界面是聊天*/
    FrontViewTag = CONVERSATION_TABLE_TAG;
//    /*部落档案按钮*/
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(0, 0, 80, 40);
//    [rightBtn setTitle:@"部落档案" forState:UIControlStateNormal];
//    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(detail:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
	// Do any additional setup after loading the view.

    
    /*聊天view*/
    //    chatview = [[UIView alloc]initWithFrame:CGRectMake(0, KTopButtonHight, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-KTopButtonHight-64)];

    // ChatInput
    _chatInput = [[ChatInput alloc]init];
    _chatInput.backgroundColor = [UIColor yellowColor];
    _chatInput.chatOffset = KTopButtonHight;
    _chatInput.stopAutoClose = NO;
    _chatInput.placeholderLabel.text = KTextDefault;
    _chatInput.delegate = self;
    _chatInput.backgroundColor = [UIColor colorWithWhite:1 alpha:0.825f];
    /*默认访问会话*/
    _chatInput.textView.editable = YES;
    _chatInput.sendBtn.enabled = YES;
    _chatInput.AddBtn.enabled = YES;
    
    // 聊天气泡的位置
    UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc]init];
    flow.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.minimumLineSpacing = 6;
    
    // Set Up CollectionView2
    CGRect myFrame =  CGRectMake(0, KTopButtonHight, ScreenWidth(), ScreenHeight() - KTopButtonHight - height(_chatInput));
    NSLog(@"self.view.frame:%@",[NSValue valueWithCGRect:self.view.frame]);
    NSLog(@"myFrame:%@",[NSValue valueWithCGRect:myFrame]);
    _myCollectionView = [[UICollectionView alloc]initWithFrame:myFrame collectionViewLayout:flow];
    //_myCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _myCollectionView.backgroundColor = [UIColor whiteColor];
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    _myCollectionView.tag=CONVERSATION_TABLE_TAG;
    _myCollectionView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _myCollectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 2, 0, -2);
    _myCollectionView.allowsSelection = YES;
    _myCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [_myCollectionView registerClass:[MessageCell class]
          forCellWithReuseIdentifier:kMessageCellReuseIdentifier];
    
    
    
    /*添加聊天*/
    [self.view addSubview:_myCollectionView];
    
    /*获取聊天记录*/
    [self getMessagesArray];
    
    /*获取离线消息*/
    [self getOffMessageFromServer];
    
    // Register Keyboard Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadeChatView:) name:@"reloadeChatView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadeChatViewAll:) name:@"reloadeChatViewAll" object:nil];
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [self scrollToBottom];
    [self.view addSubview:_chatInput];
    // Add views here, or they will create problems when launching in landscape
    
    //    [self.view addSubview:_topBar];
    
    // Scroll CollectionView Before We Start
    
}
#pragma mark 界面消失
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self ReceiveAndSeeMessige];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark CLEAN UP

- (void) removeFromParentViewController {
    
    [_chatInput removeFromSuperview];
    _chatInput = nil;
    
    [_messagesArray removeAllObjects];
    _messagesArray = nil;
    
    [_myCollectionView removeFromSuperview];
    _myCollectionView.delegate = nil;
    _myCollectionView.dataSource = nil;
    _myCollectionView = nil;
    
    self.opponentImg = nil;
    //    _PicImg = nil;
    
    //    [_topBar removeFromSuperview];
    //    _topBar = nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [super removeFromParentViewController];
}

#pragma mark ROTATION CALLS

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // Help Animation
    [_chatInput willRotate];
}
- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [_chatInput isRotating];
    _myCollectionView.frame = CGRectMake(0, KTopButtonHight, ScreenWidth(), ScreenHeight() - chatInputStartingHeight);
    NSLog(@"_myCollectionView.frame:%@",[NSValue valueWithCGRect:_myCollectionView.frame]);
    
    [_myCollectionView reloadData];
}
- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [_chatInput didRotate];
    [self scrollToBottom];
}

#pragma mark CHAT INPUT DELEGATE

/*输入文字*/
- (void) chatInputNewMessageSent:(NSString *)messageString {
    
    NSMutableDictionary * newMessageOb = [NSMutableDictionary new];
    newMessageOb[kMessageContent] = messageString;
    newMessageOb[kMessageTimestamp] = TimeStamp();
    newMessageOb[@"messtype"] = @"1";
    [self messageSendByUser:newMessageOb];
    
}

#pragma mark 点击发送照片
- (void) chatInputPicMessageSent {
    
//    NSMutableDictionary * newMessageOb = [NSMutableDictionary new];
//    [newMessageOb setValue:messageString forKey:kPicContent ];
//    newMessageOb[kMessageTimestamp] = TimeStamp();
//    [self messageSendByUser:newMessageOb];
//    [self keyboardWillHide:nil];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    [actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"拍照");
            [self callCamera];
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
    if (IOS7_OR_LATER) {
        /*调用拍照*/
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
            [self presentViewController:_cameraPicker animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
                [self.navigationController setNavigationBarHidden:YES];
            }];
        }
    }
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"点击完成");
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *tmpImage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.5)];
    [self dismissViewControllerAnimated:YES completion:^{
        [self modifyUserPortrait:tmpImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"点击取消");
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

/*此处调用发送图片*/
- (void)modifyUserPortrait:(UIImage *)image
{
    /*此处应该让图片显示聊天框中*/
    NSMutableDictionary* date = [[NSMutableDictionary alloc]init];
    
    NSNumber* aroomid = self.otherDic[@"userid"];
    NSString* otherid = [NSString stringWithFormat:@"%d",[aroomid intValue]];
    /*字典中写入图片,因为太耗时，暂时不用*/
//    NSData* picdata = UIImagePNGRepresentation(image);
    
    [date setValue:otherid forKey:@"targetid"];
    [date setObject:aroomid forKey:@"tribeid"];
    /*2,部落聊天*/
    [date setValue:@"1" forKey:@"sendtype"];
    /*消息类型 1为文本，2为json对象，3为图片，4为录音*/
    [date setValue:@"3" forKey:@"messtype"];
    NSInteger userid = [[UserInfoModelManger sharUserInfoModelManger].MeUserId integerValue];
    NSNumber* meuserid = [NSNumber numberWithInt:userid];
    date[@"senderid"] = meuserid;
    
    /*唯一标识*/
    [date setObject:TimeStamp() forKey:@"clientsign"];
    /*发送时签名*/
    [date setObject:[SignGenerator getSign] forKey:@"sign"];
    [date setObject:TimeStamp() forKey:@"date"];
    NSString* sendphoto = [UserInfoModelManger sharUserInfoModelManger].userInfo.photo;
    if (!sendphoto) {
        [self showAlert:@"您的网络太慢，请稍后尝试!"];
        return;
    }
    [date setObject:[UserInfoModelManger sharUserInfoModelManger].userInfo.photo forKey:@"senderphoto"];

    
    if (_messagesArray == nil)
        _messagesArray = [NSMutableArray new];
    
    // preload message into array;
    [_messagesArray addObject:date];
    
  [DataInterface fileUpload:image type:@"1" withCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"图片发送==%@\n",dict);
        NSNumber* Nstatecode = dict[@"statecode"];
        NSInteger Istatecode = [Nstatecode intValue];
        if (Istatecode == 200) {
    
            NSString* messIcon = dict[@"filename"];
              [date setValue:messIcon forKey:@"mess"];
            /*另生成一个新的字典，因为原自己图片，会崩溃*/
            NSMutableDictionary* tempSendDic = [[NSMutableDictionary alloc]initWithDictionary:date];
            [tempSendDic removeObjectForKey:kPicContent];
            [DataInterface chatRoomMess:tempSendDic withCompletionHandler:^(NSMutableDictionary* dict){
                NSLog(@"dict == %@\n",dict);
//            [DataInterface chat:otherid sendtype:@"1" mess:messIcon withCompletionHandler:^(NSMutableDictionary* dict){
//                NSLog(@"dict == %@\n",dict);
                /*发送完成*/
                DebugLog(@"聊天返回==%@",dict);
                /*判断返回状态的是不是该mess*/
                NSString* Backsign = dict[@"clientsign"];
                NSString* sendsign = (NSString*)date[@"clientsign"];
                if ([sendsign isEqual:Backsign] ) {
                    /*设置状态为发送状态图片*/
                    NSString* stata = [dict valueForKey:@"statecode"];
                    if ([stata isEqualToString:@"0200"]) {
                        date[@"SendState"] = [NSNumber numberWithInt:kSentOk];
                        
                        
                    }else{
                        date[@"SendState"] = [NSNumber numberWithInt:kSentFail];
                    }
                    /*返回以后，有messid，加进去messid*/
                    date[@"messid"] = dict[@"messid"];
                    NSIndexPath* aindex =[NSIndexPath indexPathForRow:([self.messagesArray count]-1) inSection:0];
                    MessageCell* cell = (MessageCell*)[self.myCollectionView cellForItemAtIndexPath:aindex];
                    [cell showDate:date];
                }else{
                    NSMutableDictionary* Temadict = nil;
                    /*搜索返回消息是第几个*/
                    for (int i=[_messagesArray count]-1; i>=0; i--) {
                        Temadict = (NSMutableDictionary*)[_messagesArray objectAtIndex:i];
                        NSString* amesssend = Temadict[@"clientsign"];
                        if ([Backsign isEqualToString:amesssend]) {
                            
                            NSIndexPath* aindex =[NSIndexPath indexPathForRow:i inSection:0];
                            MessageCell* acell = (MessageCell*)[self.myCollectionView cellForItemAtIndexPath:aindex];
                            
                            /*设置状态为发送状态图片*/
                            NSString* stata = [dict valueForKey:@"statecode"];
                            if ([stata isEqualToString:@"0200"]) {
                                Temadict[@"SendState"] = [NSNumber numberWithInt:kSentOk];
                                
                            }else{
                                Temadict[@"SendState"] = [NSNumber numberWithInt:kSentFail];
                            }
                            Temadict[@"messid"] = dict[@"messid"];
                            [acell showDate:Temadict];
                            break;
                        }
                    }
                    
                }

                
            }];

        }else{
            NSLog(@"info==%@\n",dict[@"info"]);
        }
//        NSString* statecode = [NSString stringWithFormat:@"%d",[Nstatecode intValue]];

//        [DataInterface modifyUserInfo:ORIGIN_VAL oldpwd:ORIGIN_VAL newpwd:ORIGIN_VAL signature:ORIGIN_VAL title:ORIGIN_VAL degree:ORIGIN_VAL address:ORIGIN_VAL domicile:ORIGIN_VAL introduce:ORIGIN_VAL comname:ORIGIN_VAL comdesc:ORIGIN_VAL comaddress:ORIGIN_VAL comurl:ORIGIN_VAL induname:ORIGIN_VAL indudesc:ORIGIN_VAL schoolname:ORIGIN_VAL schooltype:ORIGIN_VAL sex:ORIGIN_VAL photo:[dict objectForKey:@"filename"] email:ORIGIN_VAL tags:ORIGIN_VAL attentiontags:ORIGIN_VAL hobbies:ORIGIN_VAL educations:ORIGIN_VAL honours:ORIGIN_VAL usertype:ORIGIN_VAL gold:ORIGIN_VAL level:ORIGIN_VAL configure:ORIGIN_VAL withCompletionHandler:^(NSMutableDictionary *dict) {
//            NSLog(@"图片发送==%@\n",dict);
////            [self loadData];
//        }];
    } errorBlock:^(NSString *desc) {
        NSLog(@"图片发送==%@\n",desc);
        
    }];
    
    
    /*界面刷新时*/
    // add extra cell, and load it into view;
    NSInteger arow = _messagesArray.count -1;
    NSArray* tempArray = @[[NSIndexPath indexPathForRow:arow inSection:0]];
    [_myCollectionView insertItemsAtIndexPaths:tempArray];
    
    date[@"SendState"] = [NSNumber numberWithInt:kSentIng];
    [date setObject:image forKey:kPicContent];
    /*添加进入聊天记录*/
    [[MessageBySend sharMessageBySend] addChatRoomMessageArray:date toOtherid:self.otherDic[@"userid"]];
    
    NSIndexPath* aindex =[NSIndexPath indexPathForRow:([self.messagesArray count]-1) inSection:0];
    MessageCell* cell = (MessageCell*)[self.myCollectionView cellForItemAtIndexPath:aindex];
    cell.message = date;
    [cell showDate:date];
    
    // show us the message
    [self scrollToBottom];
}


#pragma mark - SNImagePickerDelegate

- (void)imagePicker:(SNImagePickerNC *)imagePicker didFinishPickingWithMediaInfo:(NSMutableArray *)info
{
    /*拍照完成*/
    NSLog(@"didFinishPickingWithMediaInfo\n");
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    [assetLibrary assetForURL:[info lastObject] resultBlock:^(ALAsset *asset) {
        UIImage *image = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
        [self modifyUserPortrait:image];
    } failureBlock:^(NSError *error) {}];
}

- (void)imagePickerDidCancel:(SNImagePickerNC *)imagePicker
{
    /*拍照取消完成*/
     NSLog(@"imagePickerDidCancel\n");
}

- (void)changeValue:(NSString *)value WithIndex:(NSInteger)index
{
    NSLog(@"changeValue:(NSString *)value WithIndex:(NSInteger)index\n");
//    [_valueArr replaceObjectAtIndex:index withObject:value];
//    [_editTable reloadData];
}

//#pragma mark TOP BAR DELEGATE
//
//- (void) topLeftPressed {
//    if ([(NSObject *)_delegate respondsToSelector:@selector(closeChatController:)]) {
//        [_delegate closeChatController:self];
//    }
//    else {
//        NSLog(@"ChatController: AutoClosing");
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//}
//
//- (void) topMiddlePressed {
//    // Currently Inactive
//}
//
//- (void) topRightPressed {
//    // Currently Inactive
//}


#pragma mark KEYBOARD NOTIFICATIONS

- (void) keyboardWillShow:(NSNotification *)note
{
    
    if (!_chatInput.shouldIgnoreKeyboardNotifications) {
        
        NSDictionary *keyboardAnimationDetail = [note userInfo];
        UIViewAnimationCurve animationCurve = [keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        CGFloat duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        
        NSValue* keyboardFrameBegin = [keyboardAnimationDetail valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
        int keyboardHeight = (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication]statusBarOrientation])) ? keyboardFrameBeginRect.size.height : keyboardFrameBeginRect.size.width;
        
        _myCollectionView.scrollEnabled = NO;
        _myCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:^{
            
            CGFloat tempHeight = 0.f;
                tempHeight = KTopButtonHight;
            _myCollectionView.frame = CGRectMake(0, tempHeight, ScreenWidth(), ScreenHeight() - chatInputStartingHeight - keyboardHeight- tempHeight - 65);
//            _myCollectionView.backgroundColor = [UIColor redColor];
            NSLog(@"show == _myCollectionView.frame:%@",[NSValue valueWithCGRect:_myCollectionView.frame]);
            
        } completion:^(BOOL finished) {
            if (finished) {
                [self scrollToBottom];
                _myCollectionView.scrollEnabled = NO;
                _myCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
                
                
            }
        }];
    }
}

- (void) keyboardWillHide:(NSNotification *)note {
    
    if (!_chatInput.shouldIgnoreKeyboardNotifications) {
        NSDictionary *keyboardAnimationDetail = [note userInfo];
        UIViewAnimationCurve animationCurve = [keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        CGFloat duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        
        
        [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:^{
            
        } completion:^(BOOL finished) {
            if (finished) {
                CGFloat tempHeight = 0.f;
                    tempHeight = KTopButtonHight;
                _myCollectionView.frame = CGRectMake(0, tempHeight, ScreenWidth(), ScreenHeight() - chatInputStartingHeight - tempHeight - 64);
                NSLog(@"hide == _myCollectionView.frame:%@",[NSValue valueWithCGRect:_myCollectionView.frame]);
                _myCollectionView.scrollEnabled = YES;
                _myCollectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
                [self scrollToBottom];
            }
        }];
    }
}

#pragma mark CONNECTION NOTIFICATIONS

//- (void) isOffline {
//    if ([self.view viewWithTag:connectionStatusViewTag] == nil) {
//        UILabel * offlineStatus = [[UILabel alloc]init];
//        offlineStatus.frame = CGRectMake(0, 0, ScreenWidth(), 30);
//        offlineStatus.backgroundColor = [UIColor colorWithRed:0.322311 green:0.347904 blue:0.424685 alpha:1];
//        offlineStatus.textColor = [UIColor whiteColor];
//        offlineStatus.font = [UIFont boldSystemFontOfSize:16.0];
//        offlineStatus.textAlignment = NSTextAlignmentCenter;
//        offlineStatus.minimumScaleFactor = .3;
//
//
//        offlineStatus.text = @"You're offline! Messages may not send.";
//        offlineStatus.tag = connectionStatusViewTag;
////        [self.view insertSubview:offlineStatus belowSubview:_topBar];
////        [UIView animateWithDuration:.25 animations:^{
////            offlineStatus.center = CGPointMake(self.view.center.x, offlineStatus.center.y + _topBar.bounds.size.height);
////        }];
//    }
//}

//- (void) isOnline {
//    UILabel * offlineStatus = (UILabel *)[self.view viewWithTag:connectionStatusViewTag];
//    if (offlineStatus != nil) {
//        [UIView animateWithDuration:.25 animations:^{
//            offlineStatus.center = CGPointMake(self.view.center.x, offlineStatus.center.y - _topBar.bounds.size.height);
//        } completion:^(BOOL finished) {
//            if (finished) {
//                [offlineStatus removeFromSuperview];
//            }
//        }];
//    }
//}

#pragma mark COLLECTION VIEW METHODS

- (void) scrollToBottom {
    if (_messagesArray.count > 0) {
        static NSInteger section = 0;
        NSInteger item = [self collectionView:_myCollectionView numberOfItemsInSection:section] - 1;
        if (item < 0) item = 0;
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
        [_myCollectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    }
}

/* Scroll To Top */
//- (void) scrollToTop {
//    NSLog(@"scrollToTop\n");
//    if (_myCollectionView.numberOfSections >= 1 && [_myCollectionView numberOfItemsInSection:0] >= 1) {
//        NSIndexPath *firstIndex = [NSIndexPath indexPathForRow:0 inSection:0];
//        [_myCollectionView scrollToItemAtIndexPath:firstIndex atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
//    }
//}


/* To Monitor Scroll */
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView {
 CGFloat difference = lastContentOffset - scrollView.contentOffset.y;
 if (lastContentOffset > scrollView.contentOffset.y && difference > 10) {
 // scrolled up
     NSLog(@"up");
     
 }
 else if (lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y > 0) {
 // scrolled down
      NSLog(@"down");
 
 }
 lastContentOffset = scrollView.contentOffset.y;
     
///*暂时屏蔽添加下拉刷新*/
//     if (lastContentOffset<-20 && !hisState) {
//         hisState = YES;
//         [[MessageBySend sharMessageBySend]showprogressHUD:@"正在获取历史记录，请稍等！" withView:self.view];
//         NSMutableDictionary* temp = (NSMutableDictionary*)[_messagesArray firstObject];
//         NSNumber* amessid = temp[@"messid"];
//         NSString* messid = [NSString stringWithFormat:@"%d",[amessid integerValue]];
//        [[MessageBySend sharMessageBySend]getMessageHistory:self.offMessageDic andSendtype:@"1" andStartMessageid:messid];
//     }
 }


#pragma mark COLLECTION VIEW DELEGATE

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary * message = _messagesArray[[indexPath indexAtPosition:1]];
    NSLog(@"collectionViewLayout == %@\n",message);
    NSNumber* messtype= (NSNumber*)message[@"messtype"];
    
    static int offset = 20;
    
//    if (!message[kMessageSize]) {
        NSString * content = [message objectForKey:kMessageContent];
        id pic = [message objectForKey:kPicContent];
        if ([messtype integerValue]==1 && content) {
            
            NSMutableDictionary * attributes = [NSMutableDictionary new];
            attributes[NSFontAttributeName] = [UIFont systemFontOfSize:15.0f];
            attributes[NSStrokeColorAttributeName] = [UIColor darkTextColor];
            
            NSAttributedString * attrStr = [[NSAttributedString alloc] initWithString:content
                                                                           attributes:attributes];
            
            // Here's the maximum width we'll allow our outline to be // 260 so it's offset
            int maxTextLabelWidth = maxBubbleWidth - outlineSpace;
            
            // set max width and height
            // height is max, because I don't want to restrict it.
            // if it's over 100,000 then, you wrote a fucking book, who even does that?
            CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(maxTextLabelWidth, 100000)
                                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                context:nil];
            
            message[kMessageSize] = [NSValue valueWithCGSize:rect.size];
            
            NSLog(@"size1\n");
            return CGSizeMake(width(_myCollectionView), rect.size.height + offset);
        }else if([messtype integerValue] == 3){
            NSLog(@"size2\n");
            //liuzhencai
            return CGSizeMake(320,KPicHigth);
        }
    
//    }
//    else if([messtype integerValue] == 3){
//        NSLog(@"size3\n");
//        return CGSizeMake(320,KPicHigth);
//    }else{
        NSLog(@"size4\n");
        return CGSizeMake(_myCollectionView.bounds.size.width, [message[kMessageSize] CGSizeValue].height + offset);
//    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    return _messagesArray.count;
    //     return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // Get Cell
    MessageCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMessageCellReuseIdentifier forIndexPath:indexPath];
   
    
    // Set Who Sent Message
    NSMutableDictionary * message = _messagesArray[[indexPath indexAtPosition:1]];
    
    
    // Set the cell
//    cell.opponentImage = self.opponentImg;
//    cell.MyHeadimageView = self.MyHeadImg;
    if (_opponentBubbleColor)
        cell.opponentColor = _opponentBubbleColor;
    if (_userBubbleColor)
        cell.userColor = _userBubbleColor;
    cell.message = message;
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    NSDictionary* amess = [_messagesArray objectAtIndex:row];
    
    /*记录被选中的消息*/
    mess = amess;
//    //liuzhencai 如果显示是图片
//    if (mess[kMessageContent])
//    {
//        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示:" message:@"你确定要把该条评论置顶吗" delegate:self cancelButtonTitle:@"置顶" otherButtonTitles:@"取消", nil];
//        [alert show];
//    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == KInToChatRoomErrorTag) {
        /*进入部落聊天出现问题，则推出此界面*/
        //        [self popForwardBack];
    }else
    {
        if (buttonIndex == 0) {
            DebugLog(@"0");
            
        }
    }
    
}

#pragma mark SETTERS | GETTERS

//设置显示的消息
- (void) setMessagesArray:(NSMutableArray *)messagesArray {
    _messagesArray = messagesArray;
    
    // Fix if we receive Null
    if (![_messagesArray.class isSubclassOfClass:[NSArray class]]) {
        _messagesArray = [NSMutableArray new];
    }
    
    [_myCollectionView reloadData];
}

//- (void) setChatTitle:(NSString *)chatTitle{
////    _topBar.title = chatTitle;
////    _chatTitle = chatTitle;
//}
//
//- (void) setTintColor:(UIColor *)tintColor {
//    _chatInput.sendBtnActiveColor = tintColor;
//    _topBar.tintColor = tintColor;
//    _tintColor = tintColor;
//}

#pragma mark 图片滚动
/*接受到消息，界面滚动*/
- (void) didSendPicMessage:(NSMutableDictionary *)message
{

    
}


#pragma mark chatcontroller
/*接受到消息，界面滚动*/
- (void) didSendMessage:(NSMutableDictionary *)message
{
    NSLog(@"Timestamp: %@", message[kMessageTimestamp]);
    //    message[@"sentByUserId"] = @"currentUserId";
    
    /*添加属性，消息发送状态*/
    message[@"SendState"] = [NSNumber numberWithInt:kSentIng];
    
    
    if (_messagesArray == nil)  _messagesArray = [NSMutableArray new];
    
    // preload message into array;
    [_messagesArray addObject:message];
    
    /*判断是不是自己发送的，自己发送的添加发送状态图片*/
    NSNumber* nkMessageSentBy = (NSNumber*)message[@"senderid"];
    NSString* kMessageSentBy = [NSString stringWithFormat:@"%d",[nkMessageSentBy integerValue]];
    if ([kMessageSentBy isEqualToString:[UserInfoModelManger sharUserInfoModelManger].MeUserId] ) {
        /*如果是自己发送*/
        
        /*设置发送状态图片为ok*/
//        if (localMessage ) {
//            message[@"SendState"] = [NSNumber numberWithInt:kSentOk];
//            [cell showDate:message];
//            return;
//        }
        /**
         *  聊天通用接口
         *
         *  @param targetid 发送给，好友或部落
         *  @param sendtype 1为好友私聊，2为部落聊天
         *  @param mess     消息内容
         *  @param callback 回调
         */
        NSString* mess = (NSString*)message[kMessageContent];
        id pic = message[@"kPicContent"];
        if (mess) {
            
            [DataInterface chatRoomMess:message withCompletionHandler:^(NSMutableDictionary *dict){
                /*
                 Response:{
                 opercode:"0130",		//operCode为0130，客户端通过该字段确定事件
                 statecode:"0200",		//StateCode取值：发送成功[0200],发送失败[其他]
                 info:"发送成功",		//客户端可以使用该info进行提示，如:登录成功/账号或密码错误,登录失败!
                 sign:"9aldai9adsf"		//sign请求唯一标识*/
                
                
                
                DebugLog(@"聊天返回==%@",dict);
                /*判断返回状态的是不是该mess*/
                NSString* Backsign = dict[@"clientsign"];
                NSString* sendsign = (NSString*)message[@"clientsign"];
                if ([sendsign isEqual:Backsign] ) {
                    /*设置状态为发送状态图片*/
                    NSString* stata = [dict valueForKey:@"statecode"];
                    if ([stata isEqualToString:@"0200"]) {
                        message[@"SendState"] = [NSNumber numberWithInt:kSentOk];
                        
                    }else{
                        message[@"SendState"] = [NSNumber numberWithInt:kSentFail];
                    }
                    /*返回以后，有messid，加进去messid*/
                    message[@"messid"] = dict[@"messid"];
                    NSIndexPath* aindex =[NSIndexPath indexPathForRow:([self.messagesArray count]-1) inSection:0];
                    MessageCell* cell = (MessageCell*)[self.myCollectionView cellForItemAtIndexPath:aindex];
                    [cell showDate:message];
                }else{
                    NSMutableDictionary* Temadict = nil;
                    /*搜索返回消息是第几个*/
                    for (int i=[_messagesArray count]-1; i>=0; i--) {
                        Temadict = (NSMutableDictionary*)[_messagesArray objectAtIndex:i];
                        NSString* amesssend = Temadict[@"clientsign"];
                        if ([Backsign isEqualToString:amesssend]) {
                            
                            NSIndexPath* aindex =[NSIndexPath indexPathForRow:i inSection:0];
                            MessageCell* acell = (MessageCell*)[self.myCollectionView cellForItemAtIndexPath:aindex];
                            
                            /*设置状态为发送状态图片*/
                            NSString* stata = [dict valueForKey:@"statecode"];
                            if ([stata isEqualToString:@"0200"]) {
                                Temadict[@"SendState"] = [NSNumber numberWithInt:kSentOk];
                                
                            }else{
                                Temadict[@"SendState"] = [NSNumber numberWithInt:kSentFail];
                            }
                            Temadict[@"messid"] = dict[@"messid"];
                            [acell showDate:message];
                            break;
                        }
                    }
                    
                }
                
           
            }];
        }
    }else{
        /*如果不是自己发送*/
        
        
    }

    /*界面刷新时*/
    // add extra cell, and load it into view;
    NSInteger arow = _messagesArray.count -1;
    NSArray* tempArray = @[[NSIndexPath indexPathForRow:arow inSection:0]];
    [_myCollectionView insertItemsAtIndexPaths:tempArray];
    // show us the message
    [self scrollToBottom];

}

#pragma mark 自己发送消息
/*自己发送消息*/
- (void)messageSendByUser:(NSMutableDictionary *)message
{
    
    if (!Myuserinfo) {
        UserInfoModelManger* usermang =  [UserInfoModelManger sharUserInfoModelManger];
        Myuserinfo = [usermang getMe];
        
    }
    NSInteger userid = [[UserInfoModelManger sharUserInfoModelManger].MeUserId integerValue];
    NSNumber* meuserid = [NSNumber numberWithInt:userid];
    message[@"senderid"] = meuserid;
    
    NSNumber* aroomid = self.otherDic[@"userid"];
    [message setObject:aroomid forKey:@"tribeid"];
    [message setObject:[NSString stringWithFormat:@"%d",[aroomid integerValue]] forKey:@"targetid"];
    /*2,私人聊天*/
    [message setObject:@"1" forKey:@"sendtype"];
//    /*消息类型 1为文本，2为json对象，3为图片，4为录音*/
//    [message setObject:@"1" forKey:@"messtype"];
    /*发送时签名*/
    [message setObject:[SignGenerator getSign] forKey:@"sign"];
    
    /*私人聊天对方的userid，一样以tribeid存入部落聊天数组中*/
//    [message setObject:aroomid forKey:@"tribeid"];
    [message setObject:TimeStamp() forKey:@"date"];
    /*唯一标识*/
    [message setObject:TimeStamp() forKey:@"clientsign"];
    [message setObject:[UserInfoModelManger sharUserInfoModelManger].userInfo.photo forKey:@"senderphoto"];
    
    [[MessageBySend sharMessageBySend] addChatRoomMessageArray:message toOtherid:aroomid];
    
    /*界面刷新并且发送消息*/
    [self didSendMessage:message];
}

/*对方发送消息*/
- (void)messageSendByOpponent:(NSMutableDictionary *)message
{
    //    [message setValue:[NSNumber numberWithInt:kSentByOpponent] forKey:@"kMessageSentBy"];
    [self didSendMessage:message];
}

#pragma mark 获取到推送消息
- (void)reloadeChatView:(NSNotification*)chatmessage
{
    NSLog(@"reloadeChatView");
    NSMutableDictionary* auserinfo = [[NSMutableDictionary alloc]initWithDictionary:(NSDictionary*)[chatmessage valueForKey:@"userInfo"]];
    //    NSDictionary* auserinfo = (NSDictionary*)[chatmessage valueForKey:@"userInfo"];
    
    /*判断是不是当前聊天室*/
    NSNumber* atribeid = auserinfo[@"tribeid"];
    NSNumber *tribeId = [self.otherDic objectForKey:@"userid"];
    if ([atribeid intValue] != [tribeId intValue]) {
        return;
    }
    /*消息类型 1为文本，2为json对象，3为图片，4为录音*/
    
    NSNumber* nmesstype = (NSNumber*)(auserinfo[@"messtype"]);
    NSString* messtype = [NSString stringWithFormat:@"%d",[nmesstype intValue]];
    if ([messtype isEqualToString:@"1"]) {
        //       auserinfo[kMessageContent] = auserinfo[@"mess"];
    }else if ([messtype isEqualToString:@"3"])
    {
        /*暂时没添加接受图片*/
    }
    
    auserinfo[kMessageTimestamp] = auserinfo[@"date"];
    
    UserInfoModelManger* userManger = [UserInfoModelManger sharUserInfoModelManger];
    NSString* userdiString = [NSString stringWithFormat:@"%d",[auserinfo[@"senderid"] integerValue]];
//    UserInfoModel* aother = nil;
    [userManger getOtherUserInfo:userdiString withCompletionHandler:^(UserInfoModel* other)
     {
         NSLog(@"reloadeChatview***getOtherUserInfo");
         
         [self messageSendByOpponent:auserinfo];
         
         return other;
     }];
    
    
}

#pragma mark 获取到离线消息
- (void)reloadeChatViewAll:(NSNotification*)chatmessage
{
    hisState =  NO;
    [[MessageBySend sharMessageBySend]hideprogressHUD];
    [self getMessagesArray];
}

/*获取聊天室聊天记录*/
- (void)getMessagesArray
{
//    if ([_messagesArray count]==0) {
        /*如果没有消息获取本地的*/
        NSNumber* aothetid = [self.otherDic valueForKey:@"userid"];
        NSString* otherid = [NSString stringWithFormat:@"%d",[aothetid intValue]];
        NSMutableArray* tempArray =  [[MessageBySend sharMessageBySend]getChatRoomMessArray:otherid];
    if ([tempArray count]>0) {
        [self setMessagesArray:tempArray];
    }
    
//        _messagesArray = [[NSMutableArray alloc]initWithArray:tempArray];
   
//    }
}


#pragma mark 查看消息接口
-(void)ReceiveAndSeeMessige
{
    /*查看接受的消息，服务器置为已读*/
    /*
     type=1时支持的消息类型：0为系统消息,1为好友私聊,4为处理请求好友申请,12 @某人
     type=2是支持的消息类型：2为部落聊天,6为处理部落加入申请,13 @部落
     当type为2是请在messids中只写入一个messid，为部落聊天获取到的最大messid*/

    NSMutableDictionary* amess = [_messagesArray lastObject];
    NSNumber* amessid = amess[@"messid"];
    NSString* messid = [NSString stringWithFormat:@"%d",[amessid integerValue]];
    NSNumber* aroomid = self.otherDic[@"userid"];
    if (amessid && messid) {
        [[MessageBySend sharMessageBySend]ReceiveAndSeeMessige:messid type:@"1" tribeid:[NSString stringWithFormat:@"%d",[aroomid integerValue]]];
    }
    
}

#pragma mark 返回上一界面
-(void)popForwardBack
{
    /*返回上一页时关闭本页键盘*/
    [_chatInput.textView resignFirstResponder];
    [[MessageBySend sharMessageBySend] hideprogressHUD];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 获取离线消息
- (void)getOffMessageFromServer
{
    if (self.offMessageDic ) {

       [[MessageBySend sharMessageBySend]showprogressHUD:@"正在获取离线消息，请耐心等待" withView:self.view];
        [[MessageBySend sharMessageBySend]getMessageHistory:self.offMessageDic andSendtype:@"1" andStartMessageid:nil];

    }

}
@end
