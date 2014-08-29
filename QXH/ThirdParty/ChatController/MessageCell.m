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
#import "Tool.h"


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
@property (retain, nonatomic) UILabel *textLabel;
@property (retain, nonatomic) UILabel *bgLabel;
@property (retain, nonatomic) UILabel *nameLabel;
@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) UILabel *shareLabel;
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
            _bgLabel.layer.rasterizationScale = 1.0f;
            _bgLabel.layer.shouldRasterize = YES;
            _bgLabel.layer.borderWidth = 2;
            _bgLabel.layer.cornerRadius = minimumHeight / 9;
            _bgLabel.alpha = .925;
            _bgLabel.layer.cornerRadius = minimumHeight / 9;
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
        messageSendBy = [MessageBySend sharMessageBySend];
        
        if (!_nameLabel) {
            _nameLabel = [UILabel new];
//            _nameLabel.layer.rasterizationScale = 1.5f;
            _nameLabel.layer.shouldRasterize = YES;
            _nameLabel.font = [UIFont systemFontOfSize:10.0f];
            _nameLabel.textColor = [UIColor blackColor];
            _nameLabel.numberOfLines = 0;
            _nameLabel.layer.borderColor = _userColor.CGColor;
            
            [self.contentView addSubview:_nameLabel];
        }
        
        if (!_titleLabel) {
            _titleLabel = [UILabel new];
            _titleLabel.font = [UIFont systemFontOfSize:13.0f];
            _titleLabel.textColor = [UIColor darkTextColor];
            _titleLabel.numberOfLines = 0;
            [self.contentView addSubview:_titleLabel];
        }
        
        if (!_shareLabel) {
            _shareLabel = [UILabel new];
            _shareLabel.font = [UIFont systemFontOfSize:12.0f];
            _shareLabel.textColor = [UIColor darkTextColor];
            _shareLabel.numberOfLines = 0;
            [self.contentView addSubview:_shareLabel];
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
    stateImageView.hidden = YES;
    NSNumber* kSentby = (NSNumber*)[_message valueForKey:@"senderid"];
     _sentBy = [kSentby intValue];
    NSString* asendId =[NSString stringWithFormat:@"%d",_sentBy];
    NSNumber* Nmesstype = (NSNumber*)[_message valueForKey:@"messtype"];
    _titleLabel.hidden =YES;
    _shareLabel.hidden = YES;
    /*是否自己发送*/
    BOOL SendByMeSelf = ([asendId isEqualToString:[UserInfoModelManger sharUserInfoModelManger].MeUserId])?YES:NO;
    
    //liuzhencai 如果显示是图片 3是图片
    if ([Nmesstype intValue] == 3)
    {
        _textLabel.hidden =YES;
        _bgLabel.hidden = YES;
        picImageView.hidden = NO;
        
        //自己发图片
        if (SendByMeSelf) {
//            stateImageView.hidden = NO;
            _imageView.hidden = YES;
            MyHeadimageView.hidden = NO;
            /*设置我的头像*/
            [messageSendBy getimageView:MyHeadimageView byImagePath:[_message valueForKey:@"senderphoto"]];
            picImageView.frame = CGRectMake(320-minimumHeight- KPicWidth - KheadX-5, KNameHight, KPicWidth, KPicHigth);
            _nameLabel.frame = CGRectMake(320-minimumHeight- KPicWidth - KheadX-5, 0, KPicWidth, KNameHight);
            _nameLabel.text = [_message valueForKey:@"sendername"];
             _nameLabel.textAlignment = NSTextAlignmentRight;
            UIImage* meSendPic = (UIImage*)_message[kPicContent];
            if (meSendPic) {
                /*设置发送图片*/
                picImageView.image = meSendPic;
                /*设置发送状态图片*/
//                stateImageView.hidden = NO;
                self.stateImageView.frame = CGRectMake(picImageView.frame.origin.x-kStateImageViewWidth,picImageView.frame.size.height-kStateImageViewHigth, kStateImageViewWidth,kStateImageViewHigth);
            }else{
                picImageView.image = nil;
                [messageSendBy getimageView:picImageView byImagePath:[_message valueForKey:@"mess"]];
                NSLog(@"%@",[_message valueForKey:@"mess"]);
            }

        }else{
            //对方发的
            _imageView.hidden = NO;
            MyHeadimageView.hidden = YES;
//             stateImageView.hidden = NO;
            [messageSendBy getimageView:_imageView byImagePath:[_message valueForKey:@"senderphoto"]];
            NSLog(@"_message==%@",_message);
            picImageView.image = nil;
    
            picImageView.frame = CGRectMake(offsetX / 2+ _imageView.bounds.size.width+5, KNameHight, KPicWidth, KPicHigth);
//            picImageView.center = CGPointMake(picImageView.center.x + _imageView.bounds.size.width+5, picImageView.center.y);
            [messageSendBy getimageView:picImageView byImagePath:[_message valueForKey:@"mess"]];
            _nameLabel.frame = CGRectMake(offsetX / 2 + _imageView.bounds.size.width+5, 0, KPicWidth, KNameHight);
            _nameLabel.text = [_message valueForKey:@"sendername"];
             _nameLabel.textAlignment = NSTextAlignmentLeft;
        }
  
    }else if([Nmesstype intValue] == 1){
        /*1为文本*/
        picImageView.image = nil;
        picImageView.hidden = YES;
        _textLabel.hidden =NO;
        _textLabel.backgroundColor = [UIColor clearColor];
        _bgLabel.hidden = NO;
        _textSize = [_message[kMessageSize] CGSizeValue];
        _textLabel.text = _message[kMessageContent];
       
        
        // the height that we want our text bubble to be
        CGFloat height = self.contentView.bounds.size.height;
        
        CGFloat width = (_textSize.width >KPicWidth?_textSize.width :KPicWidth)+outlineSpace;
        if (SendByMeSelf) {

            MyHeadimageView.hidden = NO;
            [messageSendBy getimageView:MyHeadimageView byImagePath:[_message valueForKey:@"senderphoto"]];
            
            _imageView.hidden = YES;
            _bgLabel.frame = CGRectMake(ScreenWidth() - width-minimumHeight-(offsetX*2), KNameHight, width, height-KLine) ;
            _bgLabel.layer.borderColor = _userColor.CGColor;

            _nameLabel.frame = CGRectMake(_bgLabel.frame.origin.x, 0, width, KNameHight);
            _nameLabel.text = [_message valueForKey:@"sendername"];
            _nameLabel.textAlignment = NSTextAlignmentRight;
            self.stateImageView.frame = CGRectMake(_bgLabel.frame.origin.x-kStateImageViewWidth, _bgLabel.frame.size.height-kStateImageViewHigth, kStateImageViewWidth,kStateImageViewHigth);
     
        }else {
  
            MyHeadimageView.hidden = YES;
            _imageView.hidden = NO;
//            for (UIView * v in @[_bgLabel, _textLabel]) {
//                v.center = CGPointMake(v.center.x + _imageView.bounds.size.width+offsetX, v.center.y);
//            }
            /*如果是对方发送消息，去除图像*/
            [messageSendBy getimageView:_imageView byImagePath:[_message valueForKey:@"senderphoto"]];
            _bgLabel.frame = CGRectMake(offsetX*2+minimumHeight, KNameHight, width, height-KLine);
            _bgLabel.layer.borderColor = _opponentColor.CGColor;

            
            _nameLabel.frame = CGRectMake(offsetX*2 + minimumHeight, 0, width, KNameHight);
            _nameLabel.text = [_message valueForKey:@"sendername"];
            _nameLabel.textAlignment = NSTextAlignmentLeft;
//            _imageView.backgroundColor = [UIColor redColor];
        }
        
        // position _textLabel in the _bgLabel;
        _textLabel.frame = CGRectMake(_bgLabel.frame.origin.x + (outlineSpace / 2), KNameHight, _bgLabel.bounds.size.width - outlineSpace, _bgLabel.bounds.size.height);
    }else if([Nmesstype intValue] == 2){
        /*2为json对象
         mess是对象
         
         sourcetype:1为广场文章，2为智谷分享，3为活动分享,4为名片分享
         名片:{sourcetype:4,userid:"123",username:"周扒皮",photo:"2",displayname:"张三",signature:"这个是签名...",usertype:"0",level:"1",uduty:"某某学校 校长"}
         广场文章:{sourcetype:1,artid:"1234",sid:"123456",sname:"发送人名字",sphoto:"1.jpg",date:"2014-05-06 22:13:11",title:"标题",artimgs:"1.jpg,2.jpg",content:"这是消息",authflag:"0",browsetime:10},
         咨询违章:{sourcetype:2,artid:"1234",sid:"123456",sname:"发送人名字",sphoto:"1.jpg",date:"2014-05-06 22:13:11",title:"标题",artimgs:"1.jpg,2.jpg",content:"这是消息",authflag:"0",browsetime:10},
         活动:{sourcetype:3,actid:"1234",actname:"活动名称",photos:"1.jpg,2.jpg",signupbegindate:"2014-05-01 12:00:00",signupenddate:"2014-05-03 12:00:00",begindate:"2014-05-05 12:00:00",enddate:"2014-05-05 13:00:00",actaddr:"活动地址",maxcount:"30",nowcount:"10",folcount:"10",tags:"标签，标签",desc:"",acttype:"活动类型"}
         */
        /*1为文本*/
        picImageView.image = nil;
        picImageView.hidden = NO;
        _textLabel.hidden =YES;
        _textLabel.backgroundColor = [UIColor clearColor];
        _bgLabel.hidden = NO;
        _titleLabel.hidden = NO;
        _shareLabel.hidden = NO;
//        _textSize = [_message[kMessageSize] CGSizeValue];
        NSString* messagetype2 = (NSString*)_message[@"mess"];
        
        // the height that we want our text bubble to be
//        CGFloat height = self.contentView.bounds.size.height - 10;
//        if (height < minimumHeight) height = minimumHeight;
        
        
        NSRange range = [messagetype2 rangeOfString:@"sourcetype"];
        NSString* sourcetype = nil;
        if (range.location != NSNotFound) {
            NSRange range1 = NSMakeRange(range.location+12, 1);
            sourcetype = [messagetype2 substringWithRange:range1];
        }
        NSArray* mesageArray = [messagetype2 componentsSeparatedByString:@","];
        
        switch ([sourcetype integerValue]) {
            case 1:
            {
                //            /*广场文章*/
                //            NSString* aTitleString= nil;
                //            for (int i=0; i<[mesageArray count]; i++) {
                //                NSString* temp1 = [mesageArray objectAtIndex:i];
                //                NSRange range2 = [temp1 rangeOfString:@"title"];
                //                if (range2.location != NSNotFound) {
                //
                //                    NSRange range3 = NSMakeRange(range2.location+8, [temp1 length]-9-range2.location);
                //                    aTitleString = [temp1 substringWithRange:range3];
                //                    break;
                //                }
                //            }
                //            NSString* result = [NSString stringWithFormat:@"*广场分享*\n\t%@",aTitleString];
                //            return result;
                
            }
                break;
            case 2:
            {
                /*智谷文章*/
                NSString* aTitleString= nil;
                NSString* aPhotoString= nil;
                for (int i=0; i<[mesageArray count]; i++) {
                    NSString* temp1 = [mesageArray objectAtIndex:i];
                    NSRange range2 = [temp1 rangeOfString:@"title"];
                    NSRange rangerPhoto1 = [temp1 rangeOfString:@"artimgs"];
                    if (range2.location != NSNotFound) {
                        
                        NSRange range23 = NSMakeRange(range2.location+8, [temp1 length]-9-range2.location);
                        aTitleString = [temp1 substringWithRange:range23];
                        
                    }else if(rangerPhoto1.location != NSNotFound)
                    {
                        NSRange rangePhoto2 = NSMakeRange(rangerPhoto1.location+10, [temp1 length]-11-rangerPhoto1.location);
                        aPhotoString = [temp1 substringWithRange:rangePhoto2];
                    }
                }
                    _shareLabel.text = @"*咨询文章分享*";
                    _titleLabel.text = aTitleString;
                    picImageView.image = nil;
                    [messageSendBy getimageView:picImageView byImagePath:aPhotoString];
               
            }
                break;
            case 3:
            {
                /*活动分享*/
                NSString* aTitleString= nil;
                NSString* aPhotoString= nil;
                for (int i=0; i<[mesageArray count]; i++) {
                    NSString* temp1 = [mesageArray objectAtIndex:i];
                    NSRange range2 = [temp1 rangeOfString:@"actname"];
                    NSRange rangerPhoto1 = [temp1 rangeOfString:@"photos"];
                    if (range2.location != NSNotFound) {
     
                        NSRange range23 = NSMakeRange(range2.location+10, [temp1 length]-10-1-range2.location);
                        aTitleString = [temp1 substringWithRange:range23];
                        
                    }else if(rangerPhoto1.location != NSNotFound)
                    {
                        /*如果字符串以双引号结尾，则减一，亚东字符串编译随心所欲，都快疯了*/
                        NSInteger x=0;
                        if([temp1 hasSuffix:@"\""])
                        {
                            x=1;
                        }
                        NSRange rangePhoto2 = NSMakeRange(rangerPhoto1.location+9, [temp1 length]-9-x-rangerPhoto1.location);
                        aPhotoString = [temp1 substringWithRange:rangePhoto2];
                    }
                   
                }
//                NSString* result = [NSString stringWithFormat:@"*活动分享*\n\t活动名称:%@",aTitleString];
                _shareLabel.text = @"*活动分享*";
                _titleLabel.text = aTitleString;
                picImageView.image = nil;
                [messageSendBy getimageView:picImageView byImagePath:aPhotoString];
            }
                break;
            case 4:
            {
                /*名片分享*/
                NSString* aTitleString= nil;
                NSString* aPhotoString= nil;
                for (int i=0; i<[mesageArray count]; i++) {
                    NSString* temp1 = [mesageArray objectAtIndex:i];
                    NSRange range2 = [temp1 rangeOfString:@"displayname"];
                    NSRange rangerPhoto1 = [temp1 rangeOfString:@"photo"];
                    if (range2.location != NSNotFound) {
                        
                        NSRange range3 = NSMakeRange(range2.location+14, [temp1 length]-15-range2.location);
                        aTitleString = [temp1 substringWithRange:range3];
//                        break;
                    }else if(rangerPhoto1.location != NSNotFound)
                    {
                        NSRange rangePhoto2 = NSMakeRange(rangerPhoto1.location+8, [temp1 length]-9-rangerPhoto1.location);
                        aPhotoString = [temp1 substringWithRange:rangePhoto2];
                    }
                }
                _shareLabel.text = @"*名片分享*";
                _titleLabel.text = aTitleString;
                
                picImageView.image = nil;
                [messageSendBy getimageView:picImageView byImagePath:aPhotoString];
         
            }
                break;
            default:
                break;
        }
        
//        _textLabel.text=  [Tool MingPianShowTex:messagetype2];
//        _textSize = [_message[kMessageSize] CGSizeValue];
        
        if (SendByMeSelf) {
            // then this is a message that the current user created . . .
            CGFloat x = ScreenWidth() - offsetX - KShareLabelWidth -MyHeadimageView.bounds.size.width-5;
            _nameLabel.frame = CGRectMake(x, 0, KShareLabelWidth, KNameHight);
            _nameLabel.text = [_message valueForKey:@"sendername"];
            _nameLabel.textAlignment = NSTextAlignmentRight;
            
            
            _bgLabel.frame = CGRectMake(x, KNameHight,KShareLabelWidth, KShareLabelHigth) ;
            _bgLabel.layer.borderColor = _userColor.CGColor;
            MyHeadimageView.hidden = NO;
            _imageView.hidden = YES;
            
            [messageSendBy getimageView:MyHeadimageView byImagePath:[_message valueForKey:@"senderphoto"]];
            
            
            _shareLabel.frame = CGRectMake(x+5, KNameHight+2, KShareLabelWidth-10, KShareTitleHigth);
            _shareLabel.textAlignment = NSTextAlignmentCenter;
            
            picImageView.frame = CGRectMake(x+5, KNameHight+KShareTitleHigth, minimumHeight, minimumHeight);
            CGFloat _titX = x+5+minimumHeight+5;
            CGFloat _titWidth = KShareLabelWidth-10-minimumHeight;

            _titleLabel.backgroundColor = [UIColor clearColor];
            _titleLabel.frame = CGRectMake(_titX, KNameHight+KShareTitleHigth, _titWidth-2, minimumHeight+10);
            
//            stateImageView.hidden = NO;
//            for (UIView * v in @[_bgLabel, _textLabel]) {
//                v.center = CGPointMake(v.center.x - MyHeadimageView.bounds.size.width-5, v.center.y);
//            }
//            self.stateImageView.frame = CGRectMake(_bgLabel.frame.origin.x-kStateImageViewWidth, _bgLabel.frame.size.height-kStateImageViewHigth, kStateImageViewWidth,kStateImageViewHigth);
            
        }else {
            MyHeadimageView.hidden = YES;
            _imageView.hidden = NO;
            
            CGFloat x = _imageView.bounds.size.width+offsetX;
            _bgLabel.frame = CGRectMake(x + offsetX, KNameHight, KShareLabelWidth, KShareLabelHigth);
            _bgLabel.layer.borderColor = _opponentColor.CGColor;
            

    
            /*如果是对方发送消息，去除图像*/
            [messageSendBy getimageView:_imageView byImagePath:[_message valueForKey:@"senderphoto"]];
            
            _nameLabel.frame = CGRectMake(offsetX+ x, 0, KShareLabelWidth, KNameHight);
            _nameLabel.text = [_message valueForKey:@"sendername"];
            _nameLabel.textAlignment = NSTextAlignmentLeft;
            _shareLabel.frame = CGRectMake(x+9, KNameHight+2, KShareLabelWidth-10, KShareTitleHigth);
            _shareLabel.textAlignment = NSTextAlignmentCenter;
            
            picImageView.frame = CGRectMake(x+10, KNameHight+KShareTitleHigth, minimumHeight, minimumHeight);
            CGFloat _titX = x+5+minimumHeight+10;
            CGFloat _titWidth = KShareLabelWidth-15-minimumHeight;
            
            _titleLabel.frame = CGRectMake(_titX, KNameHight+KShareTitleHigth-5, _titWidth, minimumHeight+10);
            
          
            //            _imageView.backgroundColor = [UIColor redColor];
        }
        
        // position _textLabel in the _bgLabel;
//        _textLabel.frame = CGRectMake(_bgLabel.frame.origin.x + (outlineSpace / 2), 0, _bgLabel.bounds.size.width - outlineSpace, _bgLabel.bounds.size.height);
        
    }
    
    // Get Our Stuff
  
}

-(void)addStateImageView:(NSInteger)senstate
{
//    stateImageView.hidden = NO;
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
        {
            UIImage* aimage =[UIImage imageNamed:@"msg_state_send_error.png"];
            stateImageView.image = aimage;
        }
            break;
    }
    

}

/*添加cell的显示信息*/
- (void)showDate:(NSDictionary*)adic
{
    
    return;
    
    /*设置消息发送状态*/
    NSInteger kState;
    NSNumber* statesend = [adic valueForKey:@"SendState"];
    if (!statesend) {
        kState = kSentOk;
    }else{
        kState = [statesend intValue];
    }
    [self addStateImageView:kState];
    /*暂时屏蔽该句*/
//    self.message = adic;

}
@end
