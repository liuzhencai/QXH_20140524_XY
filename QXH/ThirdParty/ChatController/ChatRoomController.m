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


#import "ChatRoomController.h"
#import "MessageCell.h"
#import "MyMacros.h"
#import "MyTribeDetailViewController.h"
#import "chatRoomActivViewController.h"
#import "chatRoomMemberViewController.h"



#define KTopButtonHight  50
#define KAskViewHight  100

#define CONVERSATION_TABLE_TAG 2330
#define ACTIVITY_TABLE_TAG 2331
#define NEMBERS_TABLE_TAG 2332


#define KInToChatRoomErrorTag  354

static NSString * kMessageCellReuseIdentifier = @"MessageCell";
//static int connectionStatusViewTag = 1701;
static int chatInputStartingHeight = 40;

static int scout=0;

@interface ChatRoomController ()

{
    // Used for scroll direction
    CGFloat lastContentOffset;
    /*记录被选中置顶的消息*/
    NSDictionary* mess;
    /*记录当前展示的界面的tag值*/
    NSInteger FrontViewTag;
    chatRoomActivViewController* chatRoomActive;
    chatRoomMemberViewController* chatRoomMember;
//    /*记录当前的cell*/
    MessageCell* statecell;
}

// View Properties
@property (strong, nonatomic) TopBar * topBar;
@property (strong, nonatomic) ChatInput * chatInput;
@property (strong, nonatomic) UICollectionView * myCollectionView;

@end

@implementation ChatRoomController
@synthesize opponentImg,activitysList,membersList,tribeInfoDict;
@synthesize askView,tribeInfoDetailDict;

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
    self.title = @"XXXX部落";

    /*默认当前界面是聊天*/
    FrontViewTag = CONVERSATION_TABLE_TAG;
    /*部落档案按钮*/
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 80, 40);
    [rightBtn setTitle:@"部落档案" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(detail:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
	// Do any additional setup after loading the view.
    
    /*顶部选择控件*/
    CustomSegmentControl *segment = [[CustomSegmentControl alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, KTopButtonHight) andTitles:@[@"会话",@"活动",@"成员"]];
    segment.delegate = self;
    [self.view addSubview:segment];
    

    /*活动界面*/
    CGRect activeFrame =  CGRectMake(0, KTopButtonHight, ScreenWidth(), ScreenHeight() - KTopButtonHight-64);
    chatRoomActive =[[chatRoomActivViewController alloc]init];
    chatRoomActive.view.frame = activeFrame;
    chatRoomActive.navigation = self.navigationController;
    chatRoomActive.view.tag = ACTIVITY_TABLE_TAG;
    [self.view addSubview:chatRoomActive.view];
    
    /*成员界面*/
    chatRoomMember = [[chatRoomMemberViewController alloc]init];
    chatRoomMember.view.frame = activeFrame;
    chatRoomMember.navigation = self.navigationController;
    chatRoomMember.view.tag = NEMBERS_TABLE_TAG;
    [self.view addSubview:chatRoomMember.view];

    /*聊天view*/
//    chatview = [[UIView alloc]initWithFrame:CGRectMake(0, KTopButtonHight, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-KTopButtonHight-64)];
    
    [self addMyHeadImage:[UIImage imageNamed:@"tempUser.png"]];
    [self addOHeadImage:[UIImage imageNamed:@"tempUser.png"]];
    // ChatInput
    _chatInput = [[ChatInput alloc]init];
    _chatInput.backgroundColor = [UIColor yellowColor];
    _chatInput.chatOffset = KTopButtonHight;
    _chatInput.stopAutoClose = NO;
    _chatInput.placeholderLabel.text = @"  Send A Message";
    _chatInput.delegate = self;
    _chatInput.backgroundColor = [UIColor colorWithWhite:1 alpha:0.825f];
    /*默认无权访问会话*/
    _chatInput.textView.editable = NO;
    _chatInput.sendBtn.enabled = NO;
    _chatInput.AddBtn.enabled = NO;
   
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
    
    /*获取部落信息*/
    [self getTribeInfo];
    
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
    

}

- (void) viewWillAppear:(BOOL)animated
{
    
    // Add views here, or they will create problems when launching in landscape
    

    switch (FrontViewTag) {
        case CONVERSATION_TABLE_TAG:
        {
            //获取部落信息
//            [self getTribeInfo];
            [self scrollToBottom];
             [self.view addSubview:_chatInput];
            
        }
            break;
        case ACTIVITY_TABLE_TAG:
        {
            
        }
            break;
        case NEMBERS_TABLE_TAG:
        {
            
        }
            break;
            
        default:
            break;
    }

    
//    [self.view addSubview:_topBar];
    
    // Scroll CollectionView Before We Start

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*添加每日一问*/
- (void)addAskView
{
    if (!askView) {
        askView = [[UIView alloc]initWithFrame:CGRectMake(0, KTopButtonHight, UI_SCREEN_WIDTH, KAskViewHight)];
//        [self.view addSubview:askView];
        askView.backgroundColor = [UIColor whiteColor];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, UI_SCREEN_WIDTH - 20, 25)];
        title.text = @"每日一问";
        title.font = [UIFont systemFontOfSize:18.0];
        title.textColor = GREEN_FONT_COLOR;
        title.backgroundColor = [UIColor clearColor];
        [askView addSubview:title];
        
      UIImageView*  askheadImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, title.bottom, 36, 36)];
        askheadImgView.tag = 21083;
        //        _headImgView.backgroundColor = [UIColor redColor];
        [askView addSubview:askheadImgView];
        
       UILabel* _name = [[UILabel alloc] initWithFrame:CGRectMake(askheadImgView.right + 10, askheadImgView.top, 120, 30)];
        _name.tag = 21084;
        _name.font = [UIFont boldSystemFontOfSize:16.0];
        _name.textColor = GREEN_FONT_COLOR;
        _name.backgroundColor = [UIColor clearColor];
        [askView addSubview:_name];
        
        UILabel* _time = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 10 - 120, askheadImgView.top, 120, 30)];
        _time.textAlignment = NSTextAlignmentRight;
        _time.tag = 21085;
        _time.font = [UIFont systemFontOfSize:14.0];
        _time.textColor = [UIColor lightGrayColor];
        _time.backgroundColor = [UIColor clearColor];
        [askView addSubview:_time];
        
        UILabel* _speechContent = [[UILabel alloc] initWithFrame:CGRectMake(askheadImgView.right + 10, _name.bottom, UI_SCREEN_WIDTH - 20 - 36 - 10, 50)];
        _speechContent.tag = 21086;
        _speechContent.numberOfLines = 0;
        _speechContent.font = [UIFont systemFontOfSize:14.0];
        //        _speechContent.textColor = [UIColor lightGrayColor];
        _speechContent.backgroundColor = [UIColor clearColor];
        [askView addSubview:_speechContent];
        
        CGFloat tempHeight = 0.f;
        tempHeight = KTopButtonHight+KAskViewHight;
       
        _myCollectionView.frame = CGRectMake(0, tempHeight, ScreenWidth(), ScreenHeight() - chatInputStartingHeight - tempHeight - 64);
        NSLog(@"hide == _myCollectionView.frame:%@",[NSValue valueWithCGRect:_myCollectionView.frame]);
        _myCollectionView.scrollEnabled = YES;
        _myCollectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
        [self scrollToBottom];
    }
    [self.view addSubview:askView];
    /*头像*/
    UIImageView* askheadImgView = (UIImageView*)[askView viewWithTag:21083];
    askheadImgView.image = [UIImage imageNamed:@"img_portrait72"];
    
    /*名字*/
     UILabel* _name = (UILabel*)[askView viewWithTag:21084];
    _name.text = @"名字";
    
    UILabel* _time = (UILabel*)[askView viewWithTag:21085];
    _time.text = @"19:24";
    
    UILabel* _speechContent = (UILabel*)[askView viewWithTag:21086];
     _speechContent.text = @"发言内容发言内容发言内容发言内容发言内容发言内容发言内容从前有座山，山里有座庙，庙里有个和尚讲故事，讲的是从前有座山，山里有座庙";
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
//    [self didSendMessage:newMessageOb];
    [self messageSendByUser:newMessageOb];

}

//liuzhencai 设置显示照片图片
- (void) chatInputPicMessageSent:(NSString *)messageString {
    
    NSMutableDictionary * newMessageOb = [NSMutableDictionary new];
    [newMessageOb setValue:messageString forKey:kPicContent ];
    newMessageOb[kMessageTimestamp] = TimeStamp();
//    [self didSendMessage:newMessageOb];
     [self messageSendByUser:newMessageOb];
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
            if (askView)
                tempHeight = KAskViewHight + KTopButtonHight;
            else
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

- (void) keyboardWillHide:(NSNotification *)note {
    
    if (!_chatInput.shouldIgnoreKeyboardNotifications) {
        NSDictionary *keyboardAnimationDetail = [note userInfo];
        UIViewAnimationCurve animationCurve = [keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        CGFloat duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        

        [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:^{

        } completion:^(BOOL finished) {
            if (finished) {
                CGFloat tempHeight = 0.f;
                if (askView)
                    tempHeight = KTopButtonHight+KAskViewHight;
                else
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

/* Scroll To Top
- (void) scrollToTop {
    if (_myCollectionView.numberOfSections >= 1 && [_myCollectionView numberOfItemsInSection:0] >= 1) {
        NSIndexPath *firstIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        [_myCollectionView scrollToItemAtIndexPath:firstIndex atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
}
*/

/* To Monitor Scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat difference = lastContentOffset - scrollView.contentOffset.y;
    if (lastContentOffset > scrollView.contentOffset.y && difference > 10) {
        // scrolled up
    }
    else if (lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y > 0) {
        // scrolled down
        
    }
    lastContentOffset = scrollView.contentOffset.y;
}
*/

#pragma mark COLLECTION VIEW DELEGATE

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary * message = _messagesArray[[indexPath indexAtPosition:1]];
    
    static int offset = 20;
    
    if (!message[kMessageSize]) {
        NSString * content = [message objectForKey:kMessageContent];
        if (content) {
            
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
            
            return CGSizeMake(width(_myCollectionView), rect.size.height + offset);
        }else{
            //liuzhencai
             return CGSizeMake(320,90);
        }
       
    }
    else {
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
 
    
    // Set the cell
    cell.opponentImage = self.opponentImg;
    cell.MyHeadimageView = self.MyHeadImg;
    if (_opponentBubbleColor) cell.opponentColor = _opponentBubbleColor;
    if (_userBubbleColor) cell.userColor = _userBubbleColor;
    cell.message = message;
    
    /*暂时储存cell*/
    if (indexPath.row == ([_messagesArray count]-1)) {
        statecell = cell;
    }
    
    return cell;
     
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    NSDictionary* amess = [_messagesArray objectAtIndex:row];
    
    /*记录被选中的消息*/
    mess = amess;
    //liuzhencai 如果显示是图片
    if (mess[kMessageContent])
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示:" message:@"你确定要把该条评论置顶吗" delegate:self cancelButtonTitle:@"置顶" otherButtonTitles:@"取消", nil];
        [alert show];
    }
    
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
            [self addAskView];
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


#pragma mark 界面改造

/*改造方法
 设置我的头像
 */

- (void)addMyHeadImage:(UIImage*)aimage
{
    self.MyHeadImg = aimage;
}

- (void)addOHeadImage:(UIImage*)aimage
{
    self.opponentImg = aimage;
}

#pragma mark chatcontroller
/*接受到消息，界面滚动*/
- (void) didSendMessage:(NSMutableDictionary *)message
{
    // Messages come prepackaged with the contents of the message and a timestamp in milliseconds
    //    NSLog(@"Message Contents: %@", message[kMessageContent]);
    NSLog(@"Timestamp: %@", message[kMessageTimestamp]);
    
    // Evaluate or add to the message here for example, if we wanted to assign the current userId:
    message[@"sentByUserId"] = @"currentUserId";

    
    if (_messagesArray == nil)  _messagesArray = [NSMutableArray new];
    
    // preload message into array;
    [_messagesArray addObject:message];
    
    // add extra cell, and load it into view;
    NSArray* tempArray = @[[NSIndexPath indexPathForRow:_messagesArray.count -1 inSection:0]];
    [_myCollectionView insertItemsAtIndexPaths:tempArray];
    
//    [statecell addStateImageView:kSentIng];
    // show us the message
    [self scrollToBottom];
    
    /*判断是不是自己发送的，自己发送的添加发送状态图片*/
    NSNumber* nkMessageSentBy = (NSNumber*)message[@"kMessageSentBy"];
    if (kSentByUser == [nkMessageSentBy intValue] ) {

        
        /**
         *  聊天通用接口
         *
         *  @param targetid 发送给，好友或部落
         *  @param sendtype 1为好友私聊，2为部落聊天
         *  @param mess     消息内容
         *  @param callback 回调
         */
        NSString* mess = (NSString*)message[kMessageContent];
        NSNumber* aroomid = self.tribeInfoDict[@"tribeid"];
        NSString* roomid =[NSString stringWithFormat:@"%d",[aroomid intValue]];
        if (mess && roomid) {
            [DataInterface chat:roomid sendtype:@"2" mess:mess withCompletionHandler:^(NSMutableDictionary *dict){
                /*
                 Response:{
                 opercode:"0130",		//operCode为0130，客户端通过该字段确定事件
                 statecode:"0200",		//StateCode取值：发送成功[0200],发送失败[其他]
                 info:"发送成功",		//客户端可以使用该info进行提示，如:登录成功/账号或密码错误,登录失败!
                 sign:"9aldai9adsf"		//sign请求唯一标识*/
                DebugLog(@"聊天返回==%@",dict);
                NSString* stata = [dict valueForKey:@"statecode"];
                if ([stata isEqualToString:@"0200"]) {
                    [statecell addStateImageView:kSentOk];
                }else{
                    [statecell addStateImageView:kSentFail];
                }
            }];
        }
    }
   
}

/*自己发送消息*/
- (void)messageSendByUser:(NSMutableDictionary *)message
{
//       message[@"kMessageSentBy"] = kSentByUser;
    [statecell addStateImageView:kSentIng];
        [message setValue:[NSNumber numberWithInt:kSentByUser] forKey:@"kMessageSentBy"];
       [self didSendMessage:message];
}

/*对方发送消息*/
- (void)messageSendByOpponent:(NSMutableDictionary *)message
{
    [message setValue:[NSNumber numberWithInt:kSentByOpponent] forKey:@"kMessageSentBy"];
    [self didSendMessage:message];
}
#pragma mark - CustomSegmentControlDelegate
/*界面会话切换*/
- (void)segmentClicked:(NSInteger)index{
    NSLog(@"segment clicked:%d",index);
    switch (index) {
        case 0:
        {
           /*会话*/
            FrontViewTag = CONVERSATION_TABLE_TAG;
            UIView* table = (UIView*)[self.view viewWithTag:CONVERSATION_TABLE_TAG];
            [self.view bringSubviewToFront:table];
             [self.view addSubview:_chatInput];
            if (askView) {
                [self.view addSubview:askView];
            }
        }
            break;
        case 1:
        {
            /*活动*/
            FrontViewTag = ACTIVITY_TABLE_TAG;
            [self getActivityListInTribe];

        }
            break;
        case 2:
        {
            /*成员*/
            FrontViewTag = NEMBERS_TABLE_TAG;
            [self getTribeMembers];

        }
            break;
            
        default:
            break;
    }
//    if (index == 2) {
//        if (self.tribeInfoDict) {
//            /**
//             *  获取部落成员列表
//             *
//             *  @param tribeid  部落id
//             *  @param callback 回调
//             */
//            NSString *tribeId = [self.tribeInfoDict objectForKey:@"tribeid"];
//            [DataInterface getTribeMembers:tribeId withCompletionHandler:^(NSMutableDictionary *dict){
//                NSLog(@"获取部落成员列表返回值:%@",dict);
//                if (dict) {
//                    NSArray *list = [dict objectForKey:@"list"];
//                    self.membersList = [NSMutableArray arrayWithArray:list];
//                    UITableView *table = (UITableView *)[self.view viewWithTag:NEMBERS_TABLE_TAG];
//                    [table reloadData];
//                }
//                [self showAlert:[dict objectForKey:@"info"]];
//            }];
//        }
//    }
//    NSInteger tag = CONVERSATION_TABLE_TAG + index;

}


#pragma mark 获取网络数据
- (void)getTribeInfo{
    /**
     *  获取部落信息
     *
     *  @param tribeid  部落id
     *  @param callback 回调
     */
     NSString *tribeId = [self.tribeInfoDict objectForKey:@"tribeid"];
    if (self.tribeInfoDict) {
       
        [DataInterface getTribeInfo:tribeId withCompletionHandler:^(NSMutableDictionary *dict){
            NSLog(@"部落信息返回值：%@",dict);
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
     NSString *tribeId = [self.tribeInfoDict objectForKey:@"tribeid"];
    [DataInterface gotoOneDream:tribeId withCompletionHandler:^(NSMutableDictionary *dict){
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

- (void)getActivityListInTribe{
    
    if (!chatRoomActive  || [chatRoomActive.activitysList count]) {
        /*如果获取到，就不再获取*/
        UIView* table = (UIView*)[self.view viewWithTag:ACTIVITY_TABLE_TAG];
        [self.view bringSubviewToFront:table];
        return;
    }
    
    //获取活动列表
    /**
     *  获取/搜索活动列表(列表按创建时间的逆序排列)
     *
     *  @param start     起始消息的artid，不填写该字段读取最新消息n个
     *  @param count     获取消息数量
     *  @param actname   活动名称
     *  @param tag       标签
     *  @param district  地域信息
     *  @param canjoin   0为全部活动，1为未参加的活动,2为已参加的活动
     *  @param actstate  活动状态 0为全部，1为未开始的活动，2为正在进行的活动，3为已结束的活动
     *  @param begindate 活动起始时间
     *  @param enddate   活动结束时间
     *  @param callback  回调
     */
    if (self.tribeInfoDict) {
        [DataInterface getActList:@"0"
                            count:@"20"
                          actname:@""
                    contentlength:@"30"
                              tag:@""
                         district:@""
                          canjoin:@"0"
                         actstate:@"0"
                          tribeid:[self.tribeInfoDict objectForKey:@"tribeid"]
                        begindate:@""
                          enddate:@""
            withCompletionHandler:^(NSMutableDictionary *dict){
                
                /*
                 返回数据格式
                 Response:{
                 opercode:"0125",		//operCode为0125，客户端通过该字段确定事件
                 statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
                 info:"获取成功",		//获取成功/失败!
                 list:				//消息列表
                 [
                 {actid:"1234",actname:"活动名称",photos:"1.jpg,2.jpg",signupbegindate:"2014-05-01 12:00:00",signupenddate:"2014-05-03 12:00:00",begindate:"2014-05-05 12:00:00",enddate:"2014-05-05 13:00:00",actaddr:"活动地址",maxcount:"30",nowcount:"10",folcount:"10",tags:"标签，标签",desc:"",acttype:"活动类型"},
                 {actid:"1234",actname:"活动名称",photos:"1.jpg,2.jpg",signupbegindate:"2014-05-01 12:00:00",signupenddate:"2014-05-03 12:00:00",begindate:"2014-05-05 12:00:00",enddate:"2014-05-05 13:00:00",actaddr:"活动地址",maxcount:"30",nowcount:"10",folcount:"10",tags:"标签，标签",desc:"",acttype:"活动类型"},
                 {actid:"1234",actname:"活动名称",photos:"1.jpg,2.jpg",signupbegindate:"2014-05-01 12:00:00",signupenddate:"2014-05-03 12:00:00",begindate:"2014-05-05 12:00:00",enddate:"2014-05-05 13:00:00",actaddr:"活动地址",maxcount:"30",nowcount:"10",folcount:"10",tags:"标签，标签",desc:"",acttype:"活动类型"},
                 ......
                 ]
                 */
                
                NSLog(@"活动列表返回数据:%@",dict);
                NSString* statecode = dict[@"statecode"];
                if ([statecode isEqualToString:@"0200"]) {
                    NSArray* list = [dict valueForKey:@"list"];
                    self.activitysList = [NSMutableArray arrayWithArray:list];
                    chatRoomActive.activitysList = self.activitysList;
                    [chatRoomActive.tableview reloadData];
                    UIView* table = (UIView*)[self.view viewWithTag:ACTIVITY_TABLE_TAG];
                    [self.view bringSubviewToFront:table];
                }else{
                    NSString* info = dict[@"info"];
                    [self showAlert:info];
                    
                }
   
            }];
    }
}

- (void)getTribeMembers
{
    /*
     获取部落成员
     */
    if (!chatRoomMember  || [chatRoomMember.Arrlist count]) {
        /*如果获取到，就不再获取*/
        UIView* table = (UIView*)[self.view viewWithTag:NEMBERS_TABLE_TAG];
        [self.view bringSubviewToFront:table];
        return;
    }
    if (self.tribeInfoDict) {
        [DataInterface getTribeMembers:[self.tribeInfoDict objectForKey:@"tribeid"] withCompletionHandler:^(NSMutableDictionary *dict){
            NSLog(@"部落成员返回:%@",dict);
            
            /*
             返回数据
             opercode:"0117",		//operCode为0117，客户端通过该字段确定事件
             statecode:"0200",		//StateCode取值：获取成功[0200],获取失败[其他]
             info:"创建成功",		//获取成功/失败!
             list:[
             {userid:"123",username:"周扒皮",photo:"2",displayname:"张三",signature:"这个是签名...",remark:"备注",usertype:"0",level:"1",membertype:"1",online:"1"},
             {userid:"123",username:"周扒皮",photo:"2",displayname:"张三",signature:"这个是签名...",remark:"备注",usertype:"0",level:"1",membertype:"2",online:"1"},
             ...
             ]
             */
            NSString* statecode = dict[@"statecode"];
            if ([statecode isEqualToString:@"0200"]) {
                NSArray* list = [dict valueForKey:@"list"];
                chatRoomMember.Arrlist = (NSMutableArray*)list;
                UIView* table = (UIView*)[self.view viewWithTag:NEMBERS_TABLE_TAG];
                [self.view bringSubviewToFront:table];
                [chatRoomMember.tableview reloadData];
                
            }else{
                NSString* info = dict[@"info"];
                [self showAlert:info];
                
            }
        }];
    }
    
}

- (void)detail:(UIButton *)sender{
    NSLog(@"详细资料");
    MyTribeDetailViewController *myTribeDetail = [[MyTribeDetailViewController alloc] init];
    myTribeDetail.tribeDict = self.tribeInfoDict;
    [self.navigationController pushViewController:myTribeDetail animated:YES];
}

#pragma mark 获取到推送消息
- (void)reloadeChatRoom:(NSNotification*)chatmessage
{
    NSDictionary* auserinfo = (NSDictionary*)[chatmessage valueForKey:@"userInfo"];

    /*判断是不是当前聊天室*/
    NSNumber* atribeid = auserinfo[@"tribeid"];
    NSNumber *tribeId = [self.tribeInfoDict objectForKey:@"tribeid"];
    if ([atribeid intValue] != [tribeId intValue]) {
        return;
    }
    
    NSArray* messageArray = auserinfo[@"messageArray"];
    
    NSMutableDictionary* userinfo = [[NSMutableDictionary alloc]initWithDictionary:[messageArray lastObject]];
    /*消息类型 1为文本，2为json对象，3为图片，4为录音*/

    NSNumber* nmesstype = (NSNumber*)userinfo[@"messtype"];
    NSString* messtype = [NSString stringWithFormat:@"%d",[nmesstype intValue]];
    if ([messtype isEqualToString:@"1"]) {
       userinfo[kMessageContent] = userinfo[@"mess"];
    }else if ([messtype isEqualToString:@"3"])
    {
      /*暂时没添加接受图片*/
    }
    userinfo[kMessageTimestamp] = userinfo[@"date"];
    [self messageSendByOpponent:userinfo];
}

@end
