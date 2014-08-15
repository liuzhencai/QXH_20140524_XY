//
//  ChatLiveViewController.h
//  QXH
//
//  Created by liuzhencai on 14-7-16.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//  直播间

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


@interface ChatLiveViewController : MyViewController <UICollectionViewDataSource, UICollectionViewDelegate, TopBarDelegate, ChatInputDelegate,CustomSegmentControlDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,SNImagePickerDelegate,UINavigationBarDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,MessageBySendDelegate>

{
        MBProgressHUD* progressHUD;
}


@property (nonatomic, strong) NSDictionary *tribeInfoDict;//部落信息
@property (nonatomic, strong) NSDictionary *tribeInfoDetailDict;//部落返回信息

//@property (nonatomic, strong) UIView *chatview;//部落信息
//@property (nonatomic, strong) UIView *askView;//每日一问

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
