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

// Message Dictionary Keys (defined in MessageCell)
FOUNDATION_EXPORT NSString * const kMessageSize;
//FOUNDATION_EXPORT NSString * const kMessageContent;
FOUNDATION_EXPORT NSString * const kMessageRuntimeSentBy;
//FOUNDATION_EXPORT NSString * const kMessageTimestamp;

@class ChatController;

@protocol ChatControllerDelegate

/*!
 User has sent a new message
 */
@required - (void) chatController:(ChatController *)chatController didSendMessage:(NSMutableDictionary *)message;

/*!
 Close Chat Controller - Will Dismiss If Nothing Selected
 */
@optional - (void) closeChatController:(ChatController *)chatController;

@end

@interface ChatController : MyViewController <UICollectionViewDataSource, UICollectionViewDelegate, TopBarDelegate, ChatInputDelegate>

@property (retain, nonatomic) id<ChatControllerDelegate>delegate;

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
 The img to use for the opponent
 */
@property (strong, nonatomic) UIImage * opponentImg;

/*!
 The img to use for the PicImg
 */
@property (strong, nonatomic) UIImage * PicImg;

/*!
 The img to use for the MyHead
 */
@property (strong, nonatomic) UIImage * MyHeadImg;

/*!
 To set the title
 */
@property (strong, nonatomic) NSString * chatTitle;

/*!
 The messages to display in the controller
 */
@property (strong, nonatomic) NSMutableArray * messagesArray;

/*!
 The current user's Id - This is not currently in use, it is put here for an example use
 */
@property (strong, nonatomic) NSString * currentUserId;

#pragma mark ADD NEW MESSAGE

/*!
 Add new message to view
 */
- (void) addNewMessage:(NSDictionary *)message;

#pragma mark CONNECTION UI NOTIFICATIONS

/*!
 Notify UI that user is: Offline
 */
- (void) isOffline;
/*!
 Notify UI that user is: Online
 */
- (void) isOnline;

@property (nonatomic, strong) UIView *topCustomView;

- (id)initWithCustomView:(UIView *)customView;

@end
