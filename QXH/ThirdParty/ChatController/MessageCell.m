//
//  MessageCell.m
//  LowriDev
//
//  Created by Logan Wright on 3/17/14
//  Copyright (c) 2014 Logan Wright. All rights reserved.
//


/*
 Mozilla Public License
 Version 2.0
 */


#import "MessageCell.h"
#import "MyMacros.h"
#import "UserInfoModelManger.h"

// External Constants
int const outlineSpace = 22; // 11 px on each side for border
int const maxBubbleWidth = 260; // Max Bubble Size

// Message Dict Keys
NSString * const kMessageSize = @"size";
//消息发送者
NSString * const kMessageSentBy = @"senderid";

#define KheadX 5


//#if defined(__has_include) 
//// (namespace)
//#if __has_include("FSChatManager.h")
//static NSString * kMessageContent = @"content";
//static NSString * kMessageTimestamp = @"timestamp";
//
//#else
//NSString * const kMessageContent = @"content";
//NSString * const kMessageTimestamp = @"timestamp"; // Will eventually be used to access & display timestamps
//
//
//#endif
//#else
//#endif



// Instance Level Constants
static int offsetX = 6; // 6 px from each side
// Minimum Bubble Height
//static int minimumHeight = 30;

#define kStateImageViewWidth 24
#define kStateImageViewHigth 17

@interface MessageCell()

// Who Sent The Message
@property (nonatomic) SentBy sentBy;

// Received Size
@property CGSize textSize;

// Bubble, Text, ImgV
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UILabel *bgLabel;
/* 
 对方的头像
 */
//@property (strong, nonatomic) UIImageView *imageView;



@end

@implementation MessageCell
@synthesize MyHeadimageView,picImageView;
@synthesize stateImageView,_imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        self.contentView.layer.rasterizationScale = 2.0f;
        self.contentView.layer.shouldRasterize = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        // Blue
        _opponentColor = [UIColor colorWithRed:0.142954 green:0.60323 blue:0.862548 alpha:0.88];
        // Green
        _userColor = [UIColor colorWithRed:0.14726 green:0.838161 blue:0.533935 alpha:1];
        
        /*发送状态的图片*/
        if (!stateImageView) {
            stateImageView = [[UIImageView alloc]init];
            stateImageView.backgroundColor = [UIColor clearColor];
            stateImageView.hidden = YES;
            [self.contentView addSubview:stateImageView];
        }
        //由label来做气泡的
        if (!_bgLabel) {
            _bgLabel = [UILabel new];
            _bgLabel.layer.rasterizationScale = 2.0f;
            _bgLabel.layer.shouldRasterize = YES;
            _bgLabel.layer.borderWidth = 2;
            _bgLabel.layer.cornerRadius = minimumHeight / 5;
            _bgLabel.alpha = .925;
            [self.contentView addSubview:_bgLabel];
        }
        
        //显示的文字内容
        if (!_textLabel) {
            _textLabel = [UILabel new];
            _textLabel.layer.rasterizationScale = 2.0f;
            _textLabel.layer.shouldRasterize = YES;
            _textLabel.font = [UIFont systemFontOfSize:15.0f];
            _textLabel.textColor = [UIColor darkTextColor];
            _textLabel.numberOfLines = 0;
            [self.contentView addSubview:_textLabel];
        }
        
        /*展示的图片*/
        if (picImageView == nil) {
            picImageView = [UIImageView new];
//            _picImageView.frame = CGRectMake(offsetX / 2, 0, minimumHeight*3, minimumHeight*3);
            picImageView.layer.cornerRadius = minimumHeight / 5;
            picImageView.layer.masksToBounds = YES;
            picImageView.layer.rasterizationScale = 2;
            picImageView.layer.shouldRasterize = YES;
            [self.contentView addSubview:picImageView];
        }
        
        /*自己的头像*/
        if (!MyHeadimageView) {
            MyHeadimageView = [UIImageView new];
            MyHeadimageView.frame = CGRectMake(320-minimumHeight-5, 0, minimumHeight, minimumHeight);
            MyHeadimageView.layer.cornerRadius = minimumHeight / 5;
            MyHeadimageView.layer.masksToBounds = YES;
            MyHeadimageView.layer.rasterizationScale = 2;
            MyHeadimageView.layer.shouldRasterize = YES;
            [self.contentView addSubview:MyHeadimageView];
        }
        

        /*对方的头像*/
        if (!_imageView) {
            _imageView = [UIImageView new];
            _imageView.frame = CGRectMake(KheadX, 0, minimumHeight, minimumHeight);
            _imageView.layer.cornerRadius = minimumHeight / 5;
            _imageView.layer.masksToBounds = YES;
            _imageView.layer.rasterizationScale = 2;
            _imageView.layer.shouldRasterize = YES;
            [self.contentView addSubview:_imageView];
        }
    }
    
    return self;
}

#pragma mark GETTERS | SETTERS

////设置显示对方头像
//- (void) AddOpponentImageView:(UIImageView *)opponentImage {
//
//    _imageView.image = opponentImage.image;
//}
//
////设置自己头像
//- (void)AddMyHeadimageView:(UIImageView *)MyHeadimage
//{
//    MyHeadimageView.image = MyHeadimage.image;
//  
//}

////设置消息发送者
//- (void)setkMessageRuntimeSentBy:(SentBy)sendby
//{
//    _message[kMessageRuntimeSentBy] = [NSNumber numberWithInt:sendby];
//
//}

//- (UIImage *) opponentImage {
//    return _imageView.image;
//}

- (void) setOpponentColor:(UIColor *)opponentColor {
    if (_sentBy == kSentByOpponent) {
        _bgLabel.layer.borderColor = opponentColor.CGColor;
    }
    _opponentColor = opponentColor;
}

- (void) setUserColor:(UIColor *)userColor {
    if (_sentBy == kSentByUser) {
        _bgLabel.layer.borderColor = userColor.CGColor;
    }
    _userColor = userColor;
}

- (void) setMessage:(NSDictionary *)message {
    _message = message;
    [self drawCell];
}

- (void) drawCell {
    
    NSNumber* kSentby = (NSNumber*)[_message valueForKey:@"senderid"];
     _sentBy = [kSentby intValue];
    NSString* asendId =[NSString stringWithFormat:@"%d",_sentBy];
 
    //liuzhencai 如果显示是图片
    if (_message[kPicContent])
    {
        _textLabel.hidden =YES;
        _bgLabel.hidden = YES;
        picImageView.image = [UIImage imageNamed:_message[kPicContent]];
   
        picImageView.hidden = NO;
        
        picImageView.frame = CGRectMake(offsetX / 2, 0, minimumHeight*3, minimumHeight*3);
        //自己发图片
        if ([asendId isEqualToString:[UserInfoModelManger sharUserInfoModelManger].MeUserId]) {
            _imageView.hidden = YES;
            MyHeadimageView.hidden = NO;
            picImageView.frame = CGRectMake(320-_imageView.bounds.size.width- KPicWidth - KheadX, 0, minimumHeight*3, minimumHeight*3);
        }else{
            //对方发的
            _imageView.hidden = NO;
            MyHeadimageView.hidden = YES;
            picImageView.center = CGPointMake(picImageView.center.x + _imageView.bounds.size.width, picImageView.center.y);
        }
  
    }else{
        picImageView.hidden = YES;
        _textLabel.hidden =NO;
        _bgLabel.hidden = NO;
        _textSize = [_message[kMessageSize] CGSizeValue];
        _textLabel.text = _message[kMessageContent];
       
        
        // the height that we want our text bubble to be
        CGFloat height = self.contentView.bounds.size.height - 10;
        if (height < minimumHeight) height = minimumHeight;
        
        if ([asendId isEqualToString:[UserInfoModelManger sharUserInfoModelManger].MeUserId]) {
            // then this is a message that the current user created . . .
            _bgLabel.frame = CGRectMake(ScreenWidth() - offsetX, 0, -_textSize.width - outlineSpace, height) ;
            _bgLabel.layer.borderColor = _userColor.CGColor;
            MyHeadimageView.hidden = NO;

//            MyHeadimageView.image = [[UserInfoModelManger sharUserInfoModelManger]getMe].iconImageview.image;
            NSURL *url = IMGURL([_message valueForKey:@"senderphoto"]);
            [MyHeadimageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
            
            _imageView.hidden = YES;
            stateImageView.hidden = NO;
            for (UIView * v in @[_bgLabel, _textLabel]) {
                v.center = CGPointMake(v.center.x - MyHeadimageView.bounds.size.width-5, v.center.y);
            }
            self.stateImageView.frame = CGRectMake(_bgLabel.frame.origin.x-kStateImageViewWidth, _bgLabel.frame.size.height-kStateImageViewHigth, kStateImageViewWidth,kStateImageViewHigth);
     
        }
        else {
            // sent by opponent
            _bgLabel.frame = CGRectMake(offsetX, 0, _textSize.width + outlineSpace, height);
            _bgLabel.layer.borderColor = _opponentColor.CGColor;
            
            for (UIView * v in @[_bgLabel, _textLabel]) {
                v.center = CGPointMake(v.center.x + _imageView.bounds.size.width+offsetX, v.center.y);
            }
            /*如果是对方发送消息，去除图像*/
//            UIImage* ahead = [[UserInfoModelManger sharUserInfoModelManger]getIcon:[_message valueForKey:@"senderphoto"]];
            NSURL *url = IMGURL([_message valueForKey:@"senderphoto"]);
            [_imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_portrait96"]];

            MyHeadimageView.hidden = YES;
            _imageView.hidden = NO;
            stateImageView.hidden = YES;
//            _imageView.backgroundColor = [UIColor redColor];
        }
        
       
        
        // position _textLabel in the _bgLabel;
        _textLabel.frame = CGRectMake(_bgLabel.frame.origin.x + (outlineSpace / 2), 0, _bgLabel.bounds.size.width - outlineSpace, _bgLabel.bounds.size.height);
    }
    
    // Get Our Stuff
  
}

-(void)addStateImageView:(NSInteger)senstate
{
    stateImageView.hidden = NO;
    switch (senstate) {
        case kSentIng:
        {
            UIImage* aimage =[UIImage imageNamed:@"msg_state_sending.png"];
            stateImageView.image = aimage;
            
        }
            break;
        case kSentOk:
        {
            UIImage* aimage =nil;
            stateImageView.image = aimage;
            stateImageView.hidden = YES;
        }
            break;
        case kSentFail:
        {
            UIImage* aimage =[UIImage imageNamed:@"msg_state_send_error.png"];
            stateImageView.image = aimage;
        }
            break;
        default:
            break;
    }
    

}

/*添加cell的显示信息*/
- (void)showDate:(NSDictionary*)adic
{
//    self.opponentImage = self.opponentImg;
//    self.MyHeadimageView = self.MyHeadImg;
    
    /*设置消息发送状态*/
    NSInteger kState;
    NSNumber* statesend = [adic valueForKey:@"SendState"];
    if (!statesend) {
        kState = kSentOk;
    }else{
        kState = [statesend intValue];
    }
    [self addStateImageView:kState];
    self.message = adic;

}
@end
