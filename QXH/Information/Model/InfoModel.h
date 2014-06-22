//
//  InfoModel.h
//  QXH
//
//  Created by ZhaoLilong on 14-6-2.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoModel : NSObject

@property (nonatomic, copy) NSString *artid;

@property (nonatomic, copy) NSString *sid;

@property (nonatomic, copy) NSString *sname;

@property (nonatomic, copy) NSString *sphoto;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *artimgs;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *authflag;

@property (nonatomic, copy) NSString *browsetime;

@property (nonatomic, assign) NSInteger contentlength;

@end
