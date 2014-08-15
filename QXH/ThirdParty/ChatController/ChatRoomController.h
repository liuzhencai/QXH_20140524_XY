//
//  ChatController.h
//  LowriDev
//
//  Created by Logan Wright on 3/17/14
//  Copyright (c) 2014 liuzhencai. All rights reserved.
//  聊天界面


/*
 Mozilla Public License
 Version 2.0
 */


#import <UIKit/UIKit.h>
#import "TopBar.h"
#import "ChatInput.h"
#import "MessageCell.h"
#import "CustomSegmentControl.h"
#import "PullRefreshTableViewController.h"
#import "SNImagePickerNC.h"
#import "MBProgressHUD.h"
#import "MessageBySend.h"

// Message Dictionary Keys (defined in MessageCell)
FOUNDATION_EXPORT NSString * const kMessageSize;
//FOUNDATION_EXPORT NSString * const kMessageContent;
FOUNDATION_EXPORT NSString * const kMessageSentBy;
//FOUNDATION_EXPORT NSString * const kMessageTimestamp;



@interface ChatRoomController : MyViewController <UICollectionViewDataSource, UICollectionViewDelegate, TopBarDelegate, ChatInputDelegate,CustomSegmentControlDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,SNImagePickerDelegate,UINavigationBarDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,MessageBySendDelegate>
{
    MBProgressHUD* progressHUD;
}

//@property (retain, nonatomic) id<ChatControllerDelegate>delegate;


@property (nonatomic, strong) NSMutableArray *activitysList;//活动列表
@property (nonatomic, strong) NSMutableArray *membersList;//成员列表
@property (nonatomic, strong) NSDictionary *tribeInfoDict;//部落信息
@property (nonatomic, strong) NSDictionary *tribeInfoDetailDict;//部落返回信息
@property (nonatomic, strong)NSMutableDictionary* offMessageDic;//离线消息字典

//@property (nonatomic, strong) UIView *chatview;//部落信息
@property (nonatomic, strong) UIView *askView;//每日一问

- (void)messageSendByUser:(NSMutableDictionary *)message;
/*对方发送消息*/
- (void)messageSendByOpponent:(NSMutableDictionary *)message;




/*设置聊天室标题*/
//- (void) setChatTitle:(NSString *)chatTitle;
#pragma mark PROPERTIES


/*!
 The color of the user's chat bubbles
 */
@property (strong, nonatomic) UIColor * userBubbleColor;
/*!
 The color of the opponent's chat bubbles
 */
@property (strong, nonatomic) UIColor * opponentBubbleColor;
/*!
 Change Overall Tint (send btn, & top bar)
 */
@property (strong, nonatomic) UIColor * tintColor;



/*!
 The messages to display in the controller
 */
@property (strong, nonatomic) NSMutableArray * messagesArray;

/*!
 The current user's Id - This is not currently in use, it is put here for an example use
 */
//@property (strong, nonatomic) NSString * currentUserId;

//#pragma mark ADD NEW MESSAGE

/*!
 Add new message to view
 */
//- (void) addNewMessage:(NSDictionary *)message;

//#pragma mark CONNECTION UI NOTIFICATIONS

/*!
 Notify UI that user is: Offline
 */
//- (void) isOffline;
/*!
 Notify UI that user is: Online
 */
//- (void) isOnline;

@property (nonatomic, strong) UIView *topCustomView;

- (id)initWithCustomView:(UIView *)customView;

- (void)NoHistory;

@end
