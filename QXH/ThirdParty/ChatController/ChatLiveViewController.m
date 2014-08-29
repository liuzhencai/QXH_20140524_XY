//
//  ChatLiveViewController.m
//  QXH
//
//  Created by liuzhencai on 14-7-16.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "ChatLiveViewController.h"
#import "MessageCell.h"
#import "MyMacros.h"
#import "MyTribeDetailViewController.h"
#import "chatRoomActivViewController.h"
#import "chatRoomMemberViewController.h"
#import "UserInfoModelManger.h"
#import "MessageBySend.h"
#import "MJRefresh.h"
#import "myimageviewViewController.h"


#define KTopButtonHight  0
#define KAskViewHight  100

#define CONVERSATION_TABLE_TAG 2330
#define ACTIVITY_TABLE_TAG 2331
#define NEMBERS_TABLE_TAG 2332


#define KInToChatRoomErrorTag  354

static NSString * kMessageCellReuseIdentifier = @"MessageCell";
//static int connectionStatusViewTag = 1701;
static int chatInputStartingHeight = 40;

@interface ChatLiveViewController ()
{
    // Used for scroll direction
    CGFloat lastContentOffset;
    /*记录被选中置顶的消息*/
//    NSDictionary* mess;
    /*记录当前展示的界面的tag值*/
//    NSInteger FrontViewTag;
    chatRoomActivViewController* chatRoomActive;
    chatRoomMemberViewController* chatRoomMember;
    ////    /*记录当前的cell*/
    //    MessageCell* statecell;
    
    /*自己信息*/
    UserInfoModel* Myuserinfo;
    
    /*部落id*/
    NSString* ChatRoomId;
    
    /*判断是否本地读取的消息记录*/
    BOOL localMessage;
    
    BOOL isLoading;
    
}

// View Properties
@property (strong, nonatomic) TopBar * topBar;
@property (strong, nonatomic) ChatInput * chatInput;
@property (strong, nonatomic) UICollectionView * myCollectionView;
@property (strong, nonatomic) SNImagePickerNC *imagePickerNavigationController;
@property(nonatomic, strong) UIImagePickerController *cameraPicker;

@end

@implementation ChatLiveViewController
@synthesize tribeInfoDict,tribeInfoDetailDict;
//@synthesize activitysList,membersList,askView;

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
    //    self.title = @"XXXX部落";
    self.title = [self.tribeInfoDict objectForKey:@"tribename"];
    
    
    // ChatInput
    _chatInput = [[ChatInput alloc]init];
    _chatInput.backgroundColor = [UIColor yellowColor];
    _chatInput.chatOffset = KTopButtonHight;
    _chatInput.stopAutoClose = NO;
    _chatInput.placeholderLabel.text = KTextDefault;
    _chatInput.delegate = self;
    _chatInput.backgroundColor = [UIColor colorWithWhite:1 alpha:0.825f];
    /*默认无权访问会话*/
    _chatInput.textView.editable = NO;
    _chatInput.sendBtn.enabled = NO;
    _chatInput.AddBtn.enabled = NO;
    
    // 聊天气泡的位置
    UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc]init];
    flow.sectionInset = UIEdgeInsetsMake(10, 0, 20, 0);
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    /*每一行之间距离*/
    flow.minimumLineSpacing = 30;
    
    // Set Up CollectionView2
    CGRect myFrame =  CGRectMake(0, 0, ScreenWidth(), ScreenHeight()  - height(_chatInput));
    NSLog(@"self.view.frame:%@",[NSValue valueWithCGRect:self.view.frame]);
    NSLog(@"myFrame:%@",[NSValue valueWithCGRect:myFrame]);
    _myCollectionView = [[UICollectionView alloc]initWithFrame:myFrame collectionViewLayout:flow];
    //_myCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _myCollectionView.backgroundColor = [UIColor whiteColor];
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    _myCollectionView.tag=CONVERSATION_TABLE_TAG;
    _myCollectionView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _myCollectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 2, 5, -2);
    _myCollectionView.allowsSelection = YES;
    _myCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [_myCollectionView setUserInteractionEnabled:YES];
    [_myCollectionView registerClass:[MessageCell class]
          forCellWithReuseIdentifier:kMessageCellReuseIdentifier];
    
    
    
    /*添加聊天*/
    [self.view addSubview:_myCollectionView];
    
    /*获取部落信息*/
    [self getTribeInfo];
    
//    /*获取部落置顶消息*/
//    [self getTribeTopInfo];
    
    /*获取部落聊天记录*/
    [self getMessagesArray];
    [self addHeader];
    [self addFooter];
    
    
    /*等带框*/
    progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    progressHUD.animationType = MBProgressHUDAnimationFade;
    progressHUD.labelFont = [UIFont systemFontOfSize:13.f];
    progressHUD.labelText = @"图片上传中...";
    [self.view addSubview:progressHUD];
    [progressHUD hide:YES];

    
    // Register Keyboard Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadeChatRoom:) name:@"reloadeChatRoom" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadeChatRoomAll:) name:@"reloadeChatRoomAll" object:nil];
    /*没有历史记录*/
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NOHistory:) name:@"NOHistory" object:nil];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    
    // Add views here, or they will create problems when launching in landscape
    [MessageBySend sharMessageBySend].delegate =self;
    [self scrollToBottom];
    [self.view addSubview:_chatInput];
    
}

#pragma mark 界面消失
- (void)viewWillDisappear:(BOOL)animated
{
    [_chatInput close];

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
    newMessageOb[kMessageTimestamp] = [NSDate getdate];
    //    [self didSendMessage:newMessageOb];
    [self messageSendByUser:newMessageOb];
    
}

////liuzhencai 设置显示照片图片
//- (void) chatInputPicMessageSent:(NSString *)messageString {
//    
//    NSMutableDictionary * newMessageOb = [NSMutableDictionary new];
//    [newMessageOb setValue:messageString forKey:kPicContent ];
//    newMessageOb[kMessageTimestamp] = [NSDate getdate];
//    //    [self didSendMessage:newMessageOb];
//    [self messageSendByUser:newMessageOb];
//}

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

#pragma mark ADD NEW MESSAGE

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
//            if (askView)
//                tempHeight = KAskViewHight + KTopButtonHight;
//            else
                tempHeight = KTopButtonHight;
            _myCollectionView.frame = CGRectMake(0, tempHeight, ScreenWidth(), ScreenHeight() - chatInputStartingHeight - keyboardHeight- tempHeight - 60);
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

#pragma mark 键盘隐藏
- (void) keyboardWillHide:(NSNotification *)note {
    
    if (!_chatInput.shouldIgnoreKeyboardNotifications) {
        NSDictionary *keyboardAnimationDetail = [note userInfo];
        UIViewAnimationCurve animationCurve = [keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        CGFloat duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        
        
        [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:^{
            
        } completion:^(BOOL finished) {
            if (finished) {
                CGFloat tempHeight = 0.f;
//                if (askView)
//                    tempHeight = KTopButtonHight+KAskViewHight;
//                else
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


#pragma mark 上刷新
/* Scroll To Top*/
//- (void) scrollToTop {
//    if (_myCollectionView.numberOfSections >= 1 && [_myCollectionView numberOfItemsInSection:0] >= 1) {
//        NSIndexPath *firstIndex = [NSIndexPath indexPathForRow:0 inSection:0];
//        [_myCollectionView scrollToItemAtIndexPath:firstIndex atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
//    }
//}


/* To Monitor Scroll*/
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat difference = lastContentOffset - scrollView.contentOffset.y;
//    if (lastContentOffset > scrollView.contentOffset.y && difference > 10) {
//        // scrolled up
//        DebugLog(@"up");
//    }
//    else if (lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y > 0) {
//        // scrolled down
//         DebugLog(@"down");
//
//    }
//    lastContentOffset = scrollView.contentOffset.y;
//}


#pragma mark COLLECTION VIEW DELEGATE

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary * message = _messagesArray[[indexPath indexAtPosition:1]];
    NSLog(@"message==%@\n",message);
    static int offset = 20;
    
    if (!message[kMessageSize]) {
        NSString * content = [message objectForKey:kMessageContent];
        id pic = [message objectForKey:kPicContent];
        NSNumber* messtype = [message objectForKey:@"messtype"];
//        if (content && !pic && ([messtype intValue] != 3))
        if (content && !pic && [messtype intValue] == 1)
        {
            
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
            rect.size.height += KNameHight+KLine;
            message[kMessageSize] = [NSValue valueWithCGSize:rect.size];
      
            return CGSizeMake(width(_myCollectionView), rect.size.height + offset);
        }else{
            //liuzhencai
            return CGSizeMake(320,KPicHigth+KNameHight);
        }
        
    }
    else {
        //        float height = KPicHigth;
        //        if (height < [message[kMessageSize] CGSizeValue].height + offset) {
        //            height = [message[kMessageSize] CGSizeValue].height + offset;
        //        }
        return CGSizeMake(_myCollectionView.bounds.size.width, [message[kMessageSize] CGSizeValue].height + offset);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    return _messagesArray.count;
    //     return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // Get Cell
    MessageCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMessageCellReuseIdentifier
                                                                  forIndexPath:indexPath];
    
    // Set Who Sent Message
    NSMutableDictionary * message = _messagesArray[[indexPath indexAtPosition:1]];
    
    //    cell addStateImageView:ks
    /*每个cell要存储自己的sendmessage状态*/
    // Set the cell
    //    cell.opponentImage = self.opponentImg;
    //    cell setm
    
    //    [cell AddMyHeadimageView:userinfo.iconImageview];
    //    cell.MyHeadimageView = self.MyHeadImg;
    
    if (_opponentBubbleColor) cell.opponentColor = _opponentBubbleColor;
    if (_userBubbleColor) cell.userColor = _userBubbleColor;
    cell.message = message;
    [cell showDate:message];
    
    //    /*暂时储存cell*/
    //    if (indexPath.row == ([_messagesArray count]-1)) {
    //        statecell = cell;
    //    }
    
    return cell;
    
}

#pragma mark 点击被选择的聊天记录
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    NSDictionary* amess = [_messagesArray objectAtIndex:row];
    
    if (!amess[kMessageContent]) {
        return;
    }
    /*messtype:"1",
     //消息类型 1为文本，2为json对象，3为图片，4为录音*/
    
    NSNumber* Nmesstype = amess[@"messtype"];
    NSInteger messtype = [Nmesstype integerValue];
    switch (messtype) {
        case 1:
        {
            /*判断自己有没有置顶权限，如果没有，则不理*/
            //            NSString* meuserid = [UserInfoModelManger sharUserInfoModelManger].MeUserId;
            //            NSInteger Imeuserid = [meuserid integerValue];
            //            NSNumber* NGreadid = [self.tribeInfoDetailDict valueForKey:@"creater"];
            //            NSInteger IGreadid = [NGreadid integerValue];
            //            NSNumber* Nsecretaryid = [self.tribeInfoDetailDict valueForKey:@"secretary"];
            //            NSInteger Isecretaryid = [Nsecretaryid integerValue];
            //
            //            if (Imeuserid == IGreadid || Imeuserid == Isecretaryid)
            //            {
            //                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示:" message:@"你确定要把该条评论置顶吗" delegate:self cancelButtonTitle:@"置顶" otherButtonTitles:@"取消", nil];
            //                [alert show];
            //            }
        }
            break;
        case 2:
        {
            NSLog(@"其他类型");
            
            
        }
            break;
        case 3:
        {
            NSString* photo = (NSString*)amess[kMessageContent];
            myimageviewViewController* myimage=[[myimageviewViewController alloc]init];
            myimage.photo = photo;
            [self.navigationController pushViewController:myimage animated:YES];
            //            UIView* imageview = [[UIView alloc]initWithFrame:self.view.frame];
            //            UIImageView* image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            //            [image setImageWithURL:IMGURL(image)];
            //            [imageview addSubview:image];
            
            
        }
            break;
        default:
            break;
    }
    
   
}

#pragma mark 提示框
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    IsshowAlert = NO;
    if (alertView.tag == KInToChatRoomErrorTag) {
        /*进入部落聊天出现问题，则推出此界面*/
        //        [self popForwardBack];
    }else
    {
//        if (buttonIndex == 0) {
//            DebugLog(@"0");
//            [self addAskViewByMe:mess];
//        }
    }
    
}

#pragma mark SETTERS | GETTERS

//设置显示的消息
- (void) setMessagesArray:(NSMutableArray *)messagesArray {
//    _messagesArray = messagesArray;
//    
//    // Fix if we receive Null
//    if (![_messagesArray.class isSubclassOfClass:[NSArray class]]) {
//        _messagesArray = [NSMutableArray new];
//    }
    _messagesArray = [[NSMutableArray alloc]initWithArray:messagesArray];
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


#pragma mark chatcontroller
/*接受到消息，界面滚动*/
- (void) didSendMessage:(NSMutableDictionary *)message
{
    
//    NSLog(@"Timestamp: %@", message[kMessageTimestamp]);
//    //    message[@"sentByUserId"] = @"currentUserId";
//    
//    /*添加属性，消息发送状态*/
//    message[@"SendState"] = [NSNumber numberWithInt:kSentIng];
    
    
    if (_messagesArray == nil)
        _messagesArray = [NSMutableArray new];
    
    // preload message into array;
    [_messagesArray addObject:message];
    
    /*判断是不是自己发送的，自己发送的添加发送状态图片*/
    NSNumber* nkMessageSentBy = (NSNumber*)message[@"senderid"];
    NSString* kMessageSentBy = [NSString stringWithFormat:@"%d",[nkMessageSentBy integerValue]];
    
    
    if ([kMessageSentBy isEqualToString:[UserInfoModelManger sharUserInfoModelManger].MeUserId] ) {
        //        /*
        //         是本地获取消息
        //         设置发送状态图片为ok*/
        //        if (localMessage ) {
        //             message[@"SendState"] = [NSNumber numberWithInt:kSentOk];
        //            NSIndexPath* aindex =[NSIndexPath indexPathForRow:([self.messagesArray count]-1) inSection:0];
        //            MessageCell* cell = (MessageCell*)[self.myCollectionView cellForItemAtIndexPath:aindex];
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
        NSString* amess = (NSString*)message[kMessageContent];
        if (amess && ChatRoomId) {
            
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
                        [[DBManager sharedManager]changeByDate:Backsign andMessid:dict[@"messid"]];
                    /*返回以后，有messid，加进去messid*/
                    message[@"messid"] = dict[@"messid"];
                    NSIndexPath* aindex =[NSIndexPath indexPathForRow:([self.messagesArray count]-1) inSection:0];
                    MessageCell* cell = (MessageCell*)[self.myCollectionView cellForItemAtIndexPath:aindex];
                    cell.message = message;
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
                            [[DBManager sharedManager]changeByDate:Backsign andMessid:dict[@"messid"]];
                            Temadict[@"messid"] = dict[@"messid"];
                            acell.message = Temadict;
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
    
    // add extra cell, and load it into view;
    NSInteger arow = _messagesArray.count -1;
    NSArray* tempArray = @[[NSIndexPath indexPathForRow:arow inSection:0]];
    [_myCollectionView insertItemsAtIndexPaths:tempArray];
    

    // show us the message
    [self scrollToBottom];
}

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
    /*消息类型 1为文本，2为json对象，3为图片，4为录音*/
    [message setObject:@"1" forKey:@"messtype"];
    NSNumber* aroomid = self.tribeInfoDict[@"tribeid"];
    [message setObject:aroomid forKey:@"tribeid"];
    [message setObject:[NSString stringWithFormat:@"%d",[aroomid integerValue]] forKey:@"targetid"];
    /*14,部落聊天*/
    [message setObject:@"14" forKey:@"sendtype"];
    /*唯一标识*/
    [message setObject:[NSDate getdate] forKey:@"clientsign"];
    /*发送时签名*/
    [message setObject:[SignGenerator getSign] forKey:@"sign"];
    [message setObject:[NSDate getdate] forKey:@"date"];
    [message setObject:[UserInfoModelManger sharUserInfoModelManger].userInfo.photo forKey:@"senderphoto"];
    [[MessageBySend sharMessageBySend] addChatRoomMessageByMe:message andSendtype:[NSNumber numberWithInt:14] ];
    
    /*界面刷新并且发送消息*/
    [self didSendMessage:message];
}

/*对方发送消息*/
- (void)messageSendByOpponent:(NSMutableDictionary *)message
{
    //    [message setValue:[NSNumber numberWithInt:kSentByOpponent] forKey:@"kMessageSentBy"];
    [self didSendMessage:message];
}
//#pragma mark - CustomSegmentControlDelegate
///*界面会话切换*/
//- (void)segmentClicked:(NSInteger)index{
//    NSLog(@"segment clicked:%d",index);
//    switch (index) {
//        case 0:
//        {
//            /*会话*/
//            FrontViewTag = CONVERSATION_TABLE_TAG;
//            UIView* table = (UIView*)[self.view viewWithTag:CONVERSATION_TABLE_TAG];
//            [self.view bringSubviewToFront:table];
//            [self.view addSubview:_chatInput];
//            if (askView) {
//                [self.view addSubview:askView];
//            }
//        }
//            break;
//        case 1:
//        {
//            /*活动*/
//            FrontViewTag = ACTIVITY_TABLE_TAG;
//            [self getActivityListInTribe];
//            
//        }
//            break;
//        case 2:
//        {
//            /*成员*/
//            FrontViewTag = NEMBERS_TABLE_TAG;
//            [self getTribeMembers];
//            
//        }
//            break;
//            
//        default:
//            break;
//    }
//    //    if (index == 2) {
//    //        if (self.tribeInfoDict) {
//    //            /**
//    //             *  获取部落成员列表
//    //             *
//    //             *  @param tribeid  部落id
//    //             *  @param callback 回调
//    //             */
//    //            NSString *tribeId = [self.tribeInfoDict objectForKey:@"tribeid"];
//    //            [DataInterface getTribeMembers:tribeId withCompletionHandler:^(NSMutableDictionary *dict){
//    //                NSLog(@"获取部落成员列表返回值:%@",dict);
//    //                if (dict) {
//    //                    NSArray *list = [dict objectForKey:@"list"];
//    //                    self.membersList = [NSMutableArray arrayWithArray:list];
//    //                    UITableView *table = (UITableView *)[self.view viewWithTag:NEMBERS_TABLE_TAG];
//    //                    [table reloadData];
//    //                }
//    //                [self showAlert:[dict objectForKey:@"info"]];
//    //            }];
//    //        }
//    //    }
//    //    NSInteger tag = CONVERSATION_TABLE_TAG + index;
//    
//}


#pragma mark 获取部落详细信息
- (void)getTribeInfo{
    /**
     *  获取部落信息
     *
     *  @param tribeid  部落id
     *  @param callback 回调
     */
    
    NSNumber* aroomid = self.tribeInfoDict[@"tribeid"];
    NSString* roomid =[NSString stringWithFormat:@"%d",[aroomid intValue]];
    ChatRoomId = roomid;
    if (self.tribeInfoDict) {
        
        [DataInterface getTribeInfo:ChatRoomId withCompletionHandler:^(NSMutableDictionary *dict){
            NSLog(@"部落信息返回值：%@",dict);
            /*
             opercode:"0114",		//operCode为0114，客户端通过该字段确定事件
             statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
             info:"创建成功",		//获取成功/失败!
             tribename:"部落名称",		//部落名称
             tribestyle:"部落类型",		//部落类型
             signature:"部落签名",		//部落签名
             desc:"部落描述",		//部落描述
             condition:"加入条件",		//加入条件
             purpose:"宗旨",			//宗旨
             rule:"章程",			//章程
             tags:"标签，标签"，		//不同标签之间用逗号隔开
             creater:"123456",		//创建人userid
             creatername:"张三",		//创建人名称
             createrphoto:"1.jpg",		//创建人头像
             creatersign:"签名",		//创建人签名
             secretary:"秘书长userid",	//秘书长userid
             secretaryname:"秘书长userid",	//秘书长名称
             secretaryphoto:"秘书长userid",	//秘书长头像
             secretarysign:"秘书长userid",	//秘书长签名
             district:"130400",		//地域信息
             photo:"2.jpg",			//部落头像
             status:1,			//状态 1为状态正常的部落(可聊天使用的部落),2为申请中的部落(不能聊天)
             authflag:"1",			//认证标识,0为普通部落,1为官方认证
             maxcount:"30",			//部落最多人数
             nowcount:"20"			//当前部落人数
             */
            self.tribeInfoDetailDict = dict;
            //            [self showAlert:[dict objectForKey:@"info"]];
            
            [self getinChatRoom];
        }];
    }
    
    
}


- (void)getinChatRoom
{
    /**
     *  进入直播间
     *
     *  @param tribeid  部落id
     *  @param callback 回调
     */
    //     NSString *tribeId = [self.tribeInfoDict objectForKey:@"tribeid"];
    [DataInterface gotoOneDream:ChatRoomId withCompletionHandler:^(NSMutableDictionary *dict){
        NSLog(@"部落信息返回值：%@",dict);
        /*
         opercode:"0136",		//operCode为0133，客户端通过该字段确定事件
         statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
         info:"操作成功"			//操作成功/失败!*/
        NSString* statecode = dict[@"statecode"];
        if (![statecode isEqualToString:@"0200"]) {
            UIAlertView* aler = [[UIAlertView alloc]initWithTitle:@"提示：" message:[dict objectForKey:@"info"] delegate:self cancelButtonTitle:@"确  定" otherButtonTitles:nil, nil];
            aler.tag = KInToChatRoomErrorTag;
            [aler show];
            [self showAlert:[dict objectForKey:@"info"]];
        }else{
            /*用户拥有会话权限*/
            _chatInput.textView.editable = YES;
            _chatInput.sendBtn.enabled = YES;
            _chatInput.AddBtn.enabled = YES;
            
        }
        
    }];
}

//- (void)getActivityListInTribe{
//    
//    if (chatRoomActive  && [chatRoomActive.activitysList count]) {
//        /*如果获取到，就不再获取*/
//        UIView* table = (UIView*)[self.view viewWithTag:ACTIVITY_TABLE_TAG];
//        [self.view bringSubviewToFront:table];
//        return;
//    }
//    
//    //获取活动列表
//    /**
//     *  获取/搜索活动列表(列表按创建时间的逆序排列)
//     *
//     *  @param start     起始消息的artid，不填写该字段读取最新消息n个
//     *  @param count     获取消息数量
//     *  @param actname   活动名称
//     *  @param tag       标签
//     *  @param district  地域信息
//     *  @param canjoin   0为全部活动，1为未参加的活动,2为已参加的活动
//     *  @param actstate  活动状态 0为全部，1为未开始的活动，2为正在进行的活动，3为已结束的活动
//     *  @param begindate 活动起始时间
//     *  @param enddate   活动结束时间
//     *  @param callback  回调
//     */
//    if (self.tribeInfoDict) {
//        [DataInterface getActList:@"0"
//                            count:@"20"
//                          actname:@""
//                    contentlength:@"30"
//                              tag:@""
//                         district:@""
//                          canjoin:@"0"
//                         actstate:@"0"
//                           status:@"0"
//                          tribeid:ChatRoomId
//                        begindate:@""
//                          enddate:@""
//            withCompletionHandler:^(NSMutableDictionary *dict){
//                
//                /*
//                 返回数据格式
//                 Response:{
//                 opercode:"0125",		//operCode为0125，客户端通过该字段确定事件
//                 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
//                 info:"获取成功",		//获取成功/失败!
//                 list:				//消息列表
//                 [
//                 {actid:"1234",actname:"活动名称",photos:"1.jpg,2.jpg",signupbegindate:"2014-05-01 12:00:00",signupenddate:"2014-05-03 12:00:00",begindate:"2014-05-05 12:00:00",enddate:"2014-05-05 13:00:00",actaddr:"活动地址",maxcount:"30",nowcount:"10",folcount:"10",tags:"标签，标签",desc:"",acttype:"活动类型"},
//                 {actid:"1234",actname:"活动名称",photos:"1.jpg,2.jpg",signupbegindate:"2014-05-01 12:00:00",signupenddate:"2014-05-03 12:00:00",begindate:"2014-05-05 12:00:00",enddate:"2014-05-05 13:00:00",actaddr:"活动地址",maxcount:"30",nowcount:"10",folcount:"10",tags:"标签，标签",desc:"",acttype:"活动类型"},
//                 {actid:"1234",actname:"活动名称",photos:"1.jpg,2.jpg",signupbegindate:"2014-05-01 12:00:00",signupenddate:"2014-05-03 12:00:00",begindate:"2014-05-05 12:00:00",enddate:"2014-05-05 13:00:00",actaddr:"活动地址",maxcount:"30",nowcount:"10",folcount:"10",tags:"标签，标签",desc:"",acttype:"活动类型"},
//                 ......
//                 ]
//                 */
//                
//                NSLog(@"活动列表返回数据:%@",dict);
//                NSString* statecode = dict[@"statecode"];
//                if ([statecode isEqualToString:@"0200"]) {
//                    NSArray* list = [dict valueForKey:@"list"];
//                    if ([list count] == 0) {
//                        [self showAlert:@"该部落暂时没有可分享的活动!"];
//                        return ;
//                    }
//                    self.activitysList = [NSMutableArray arrayWithArray:list];
//                    chatRoomActive.activitysList = self.activitysList;
//                    [chatRoomActive.tableview reloadData];
//                    UIView* table = (UIView*)[self.view viewWithTag:ACTIVITY_TABLE_TAG];
//                    [self.view bringSubviewToFront:table];
//                }else{
//                    NSString* info = dict[@"info"];
//                    [self showAlert:info];
//                    
//                }
//                
//            }];
//    }
//}

//- (void)getTribeMembers
//{
//    /*
//     获取部落成员
//     */
//    if (!chatRoomMember  || [chatRoomMember.Arrlist count]) {
//        /*如果获取到，就不再获取*/
//        UIView* table = (UIView*)[self.view viewWithTag:NEMBERS_TABLE_TAG];
//        [self.view bringSubviewToFront:table];
//        return;
//    }
//    if (self.tribeInfoDict) {
//        [DataInterface getTribeMembers:ChatRoomId withCompletionHandler:^(NSMutableDictionary *dict){
//            NSLog(@"部落成员返回:%@",dict);
//            
//            /*
//             返回数据
//             opercode:"0117",		//operCode为0117，客户端通过该字段确定事件
//             statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
//             info:"创建成功",		//获取成功/失败!
//             list:[
//             {userid:"123",username:"周扒皮",photo:"2",displayname:"张三",signature:"这个是签名...",remark:"备注",usertype:"0",level:"1",membertype:"1",online:"1"},
//             {userid:"123",username:"周扒皮",photo:"2",displayname:"张三",signature:"这个是签名...",remark:"备注",usertype:"0",level:"1",membertype:"2",online:"1"},
//             ...
//             ]
//             */
//            NSString* statecode = dict[@"statecode"];
//            if ([statecode isEqualToString:@"0200"]) {
//                NSArray* list = [dict valueForKey:@"list"];
//                chatRoomMember.Arrlist = (NSMutableArray*)list;
//                UIView* table = (UIView*)[self.view viewWithTag:NEMBERS_TABLE_TAG];
//                [self.view bringSubviewToFront:table];
//                [chatRoomMember.tableview reloadData];
//                
//            }else{
//                NSString* info = dict[@"info"];
//                [self showAlert:info];
//                
//            }
//        }];
//    }
//    
//}

//- (void)detail:(UIButton *)sender{
//    NSLog(@"详细资料");
//    MyTribeDetailViewController *myTribeDetail = [[MyTribeDetailViewController alloc] init];
//    myTribeDetail.tribeDict = self.tribeInfoDict;
//    [self.navigationController pushViewController:myTribeDetail animated:YES];
//}

#pragma mark 获取到推送消息
- (void)reloadeChatRoom:(NSNotification*)chatmessage
{
    NSLog(@"reloadeChatRoom");
    NSMutableDictionary* auserinfo = [[NSMutableDictionary alloc]initWithDictionary:(NSDictionary*)[chatmessage valueForKey:@"userInfo"]];
    //    NSDictionary* auserinfo = (NSDictionary*)[chatmessage valueForKey:@"userInfo"];
    
    /*判断是不是当前聊天室*/
    NSNumber* atribeid = auserinfo[@"tribeid"];
    NSNumber *tribeId = [self.tribeInfoDict objectForKey:@"tribeid"];
    if ([atribeid intValue] != [tribeId intValue]) {
        return;
    }
//    [self messageSendByOpponent:auserinfo];
    
    //    NSArray* messageArray = auserinfo[@"messageArray"];
    
    //    NSMutableDictionary* buserinfo = [[NSMutableDictionary alloc]initWithDictionary:[messageArray lastObject]];
    /*消息类型 1为文本，2为json对象，3为图片，4为录音*/
    
//    NSNumber* nmesstype = (NSNumber*)(auserinfo[@"messtype"]);
//    NSString* messtype = [NSString stringWithFormat:@"%d",[nmesstype intValue]];
//    if ([messtype isEqualToString:@"1"]) {
//        //       auserinfo[kMessageContent] = auserinfo[@"mess"];
//    }else if ([messtype isEqualToString:@"3"])
//    {
//        /*暂时没添加接受图片*/
//    }
//    
//    auserinfo[kMessageTimestamp] = auserinfo[@"date"];
//    
    UserInfoModelManger* userManger = [UserInfoModelManger sharUserInfoModelManger];
    NSString* userdiString = [NSString stringWithFormat:@"%d",[auserinfo[@"senderid"] integerValue]];
    [userManger getOtherUserInfo:userdiString withCompletionHandler:^(UserInfoModel* other)
     {
         NSLog(@"reloadeChatRoom***getOtherUserInfo");
         
         [self messageSendByOpponent:auserinfo];
         
         return other;
     }];
    
    
}

#pragma mark 获取到所有离线消息展示
- (void)reloadeChatRoomAll:(NSNotification*)chatmessage
{
    NSLog(@"reloadeChatRoom==%@",chatmessage);
    [self getMessagesArray];
    
    //    NSMutableDictionary* auserinfo = [[NSMutableDictionary alloc]initWithDictionary:(NSDictionary*)[chatmessage valueForKey:@"userInfo"]];
    //    //    NSDictionary* auserinfo = (NSDictionary*)[chatmessage valueForKey:@"userInfo"];
    //
    //    /*判断是不是当前聊天室*/
    //    NSNumber* atribeid = auserinfo[@"tribeid"];
    //    NSNumber *tribeId = [self.tribeInfoDict objectForKey:@"tribeid"];
    //    if ([atribeid intValue] != [tribeId intValue]) {
    //        return;
    //    }
    //
    //    //    NSArray* messageArray = auserinfo[@"messageArray"];
    //
    //    //    NSMutableDictionary* buserinfo = [[NSMutableDictionary alloc]initWithDictionary:[messageArray lastObject]];
    //    /*消息类型 1为文本，2为json对象，3为图片，4为录音*/
    //
    //    NSNumber* nmesstype = (NSNumber*)(auserinfo[@"messtype"]);
    //    NSString* messtype = [NSString stringWithFormat:@"%d",[nmesstype intValue]];
    //    if ([messtype isEqualToString:@"1"]) {
    //        //       auserinfo[kMessageContent] = auserinfo[@"mess"];
    //    }else if ([messtype isEqualToString:@"3"])
    //    {
    //        /*暂时没添加接受图片*/
    //    }
    //
    //    auserinfo[kMessageTimestamp] = auserinfo[@"date"];
    //
    //    UserInfoModelManger* userManger = [UserInfoModelManger sharUserInfoModelManger];
    //    NSString* userdiString = [NSString stringWithFormat:@"%d",[auserinfo[@"senderid"] integerValue]];
    //    UserInfoModel* aother = nil;
    //    [userManger getOtherUserInfo:userdiString withCompletionHandler:^(UserInfoModel* other)
    //     {
    //         NSLog(@"reloadeChatRoom***getOtherUserInfo");
    //
    //         [self messageSendByOpponent:auserinfo];
    //
    //         return other;
    //     }];
    //
    
}

#pragma amrk 获取聊天室聊天记录
- (void)getMessagesArray
{
    //    if ([_messagesArray count]==0) {
    /*如果没有消息获取本地的*/
    NSArray* tempArray =  [[MessageBySend sharMessageBySend]getChatRoomMessArray:ChatRoomId andStart:@"0" andcount:@"20" andSendType:@"14"];
//       NSArray* tempArray =  [[MessageBySend sharMessageBySend]getChatRoomMessArrayOld:ChatRoomId];
    if ([tempArray count]) {
        
        NSMutableArray* temp1 = [[NSMutableArray alloc]initWithArray:tempArray];
        self.messagesArray = temp1;
    }
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
    
    NSNumber* aroomid = self.tribeInfoDict[@"tribeid"];;
    NSString* otherid = [NSString stringWithFormat:@"%d",[aroomid intValue]];
    /*字典中写入图片,因为太耗时，暂时不用*/
    //    NSData* picdata = UIImagePNGRepresentation(image);
    
    [date setValue:otherid forKey:@"targetid"];
    [date setObject:aroomid forKey:@"tribeid"];
    /*2,部落聊天*/
    [date setValue:@"14" forKey:@"sendtype"];
    /*消息类型 1为文本，2为json对象，3为图片，4为录音*/
    [date setValue:@"3" forKey:@"messtype"];
    NSInteger userid = [[UserInfoModelManger sharUserInfoModelManger].MeUserId integerValue];
    NSNumber* meuserid = [NSNumber numberWithInt:userid];
    date[@"senderid"] = meuserid;
    
    /*唯一标识*/
    [date setObject:[NSDate getdate] forKey:@"clientsign"];
    /*发送时签名*/
    [date setObject:[SignGenerator getSign] forKey:@"sign"];
    [date setObject:[NSDate getdate] forKey:@"date"];
    NSString* sendphoto = [UserInfoModelManger sharUserInfoModelManger].userInfo.photo;
    if (!sendphoto) {
        [self showAlert:@"您的网络太慢，请稍后尝试!"];
        return;
    }
    [date setObject:[UserInfoModelManger sharUserInfoModelManger].userInfo.photo forKey:@"senderphoto"];
    
    
    if (_messagesArray == nil)  _messagesArray = [NSMutableArray new];
    
    // preload message into array;
    [_messagesArray addObject:date];
    
    
    /*添加等待框*/
        
    
    [progressHUD hide:NO];
    [progressHUD show:YES];
    
    [DataInterface fileUpload:image type:@"1" withCompletionHandler:^(NSMutableDictionary *dict) {
        NSLog(@"图片发送==%@\n",dict);
        [progressHUD hide:YES];
        NSNumber* Nstatecode = dict[@"statecode"];
        NSInteger Istatecode = [Nstatecode intValue];
        if (Istatecode == 200) {
            
            NSString* messIcon = dict[@"filename"];
            [date setValue:messIcon forKey:@"mess"];
            /*另生成一个新的字典，因为原自己图片，会崩溃*/
            NSMutableDictionary* tempSendDic = [[NSMutableDictionary alloc]initWithDictionary:date];
            [tempSendDic removeObjectForKey:kPicContent];
            /*保存数据库*/
            [[MessageBySend sharMessageBySend] saveFmdb:tempSendDic];
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
                    [[DBManager sharedManager]changeByDate:Backsign andMessid:dict[@"messid"]];
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
                            [[DBManager sharedManager]changeByDate:Backsign andMessid:dict[@"messid"]];
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
    [[MessageBySend sharMessageBySend] addChatRoomMessageByMe:date andSendtype:[NSNumber numberWithInt:14]];
    
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

#pragma mark 返回上一界面
-(void)popForwardBack
{
    [_chatInput.textView resignFirstResponder];
    [MessageBySend sharMessageBySend].delegate =nil;
    /*同时临时退出部落*/
    [DataInterface leaveOneDream:ChatRoomId withCompletionHandler:^(NSMutableDictionary* dic){
        NSLog(@"临时退出部落==%@",dic);
    }];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark 添加上啦刷新测试
- (void)addHeader
{
    //    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [_myCollectionView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        //            [[MessageBySend sharMessageBySend]showprogressHUD:@"正在获取历史记录，请稍等！" withView:self.view];
        NSMutableArray* tempAray =  [[MessageBySend sharMessageBySend]getHistoryFormLocalByTargid:ChatRoomId andBack:YES];
        if ([tempAray count]>0) {
            _messagesArray = [[NSMutableArray alloc]initWithArray:tempAray];
            
            [_myCollectionView reloadData];
        }
        [_myCollectionView headerEndRefreshing];
        
        
        //        // 模拟延迟加载数据，因此2秒后才调用）
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            [_myCollectionView reloadData];
        //            // 结束刷新
        //            [_myCollectionView headerEndRefreshing];
        //        });
    }];
    
    //#warning 自动刷新(一进入程序就下拉刷新)
    //    [_myCollectionView headerBeginRefreshing];
}

- (void)addFooter
{
   
    // 添加上拉刷新尾部控件
    [_myCollectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        NSMutableArray* tempAray =  [[MessageBySend sharMessageBySend]getHistoryFormLocalByTargid:ChatRoomId andBack:NO];
        if ([tempAray count]>0) {
            _messagesArray = [[NSMutableArray alloc]initWithArray:tempAray];
            
            [_myCollectionView reloadData];
        }
        [_myCollectionView footerEndRefreshing];
        // 增加5条假数据
        //        for (int i = 0; i<5; i++) {
        //            [vc.fakeColors addObject:MJRandomColor];
        //        }
        
        //        // 模拟延迟加载数据，因此2秒后才调用）
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            [_myCollectionView reloadData];
        //            // 结束刷新
        //            [_myCollectionView footerEndRefreshing];
        //        });
    }];
}

#pragma mark 没有历史记录
- (void)NOHistory:(NSNotification*)chatmessage
{
    //    [_myCollectionView reloadData];
    // 结束刷新
//    [_myCollectionView headerEndRefreshing];
////    [self showAlert:@"已经没有历史记录！"];
//    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示:" message:@"已经没有历史记录！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//    [alert show];
    
    
}

- (void)NoHistory
{
    // 结束刷新
    [_myCollectionView headerEndRefreshing];
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示:" message:@"已经没有历史记录！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alert show];
}
@end
