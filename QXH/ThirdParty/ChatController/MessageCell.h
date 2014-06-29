//
//  MessageCell.h
//  LowriDev
//
//  Created by Logan Wright on 3/17/14
//  Copyright (c) 2014 Logan Wright. All rights reserved.
//


/*
 Mozilla Public License
 Version 2.0
 */


#import <UIKit/UIKit.h>

/*!
 Who sent the message
 */
typedef enum {
    kSentByUser,
    //对手
    kSentByOpponent,
} SentBy;


typedef enum {
    kSentIng,
    kSentOk,
    kSentFail
} SendState;

// Used for shared drawing btwn self & chatController
FOUNDATION_EXPORT int const outlineSpace;
FOUNDATION_EXPORT int const maxBubbleWidth;

//liuzhencai
//定义图片
#define kPicContent         @"Piccontent"

//定义文字
#define kMessageContent     @"content"
#define kMessageTimestamp   @"timestamp"

//显示图片时定义宽度和高度
#define KPicHigth 90
#define KPicWidth 90

// Message Dictionary Keys
FOUNDATION_EXPORT NSString * const kMessageSize;
FOUNDATION_EXPORT NSString * const kMessageSentBy;
#if defined(__has_include)
#if __has_include("FSChatManager.h")
// (namespace)
#else
//FOUNDATION_EXPORT NSString * const kMessageTimestamp;
//FOUNDATION_EXPORT NSString * const kMessageContent;




#endif
#else
#endif

@interface MessageCell : UICollectionViewCell

/*
 Message Property
 */
@property (strong, nonatomic) NSDictionary * message;

/*!
 Opponent bubble color
 */
@property (strong, nonatomic) UIColor * opponentColor;
/*!
 User bubble color
 */
@property (strong, nonatomic) UIColor * userColor;

/*!
 Opponent image -- nil for blank
 */
@property (strong, nonatomic) UIImage * opponentImage;

/*
 我的头像
 */
@property (strong, nonatomic) UIImageView *MyHeadimageView;

/*
 拍照的图片
 */
@property (strong, nonatomic) UIImageView *picImageView;

/*
 发送状态的图片
 */
@property (strong, nonatomic) UIImageView *stateImageView;

/*
 设置状态的图片
 */
-(void)addStateImageView:(NSInteger)senstate;

@end
