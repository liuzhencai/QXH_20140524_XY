//
//  InfoCommentModel.h
//  QXH
//
//  Created by ZhaoLilong on 14-6-21.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoCommentModel : NSObject

@property (nonatomic, copy) NSString *comment;

@property (nonatomic, assign) NSInteger ctid;

@property (nonatomic, assign) NSInteger sid;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *sname;

@property (nonatomic, copy) NSString *sphoto;

@end
