//
//  AddOrDeleteMemberViewController.h
//  QXH
//
//  Created by XueYong on 6/18/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "MyViewController.h"

typedef enum {
    addTribeMemberType,
    deleteTribeMemberType
}AddOrDeleteMemberType;

@interface AddOrDeleteMemberViewController : MyViewController
@property (nonatomic, assign) AddOrDeleteMemberType type;
@property (nonatomic, strong) NSDictionary *tribeDict;
@end
