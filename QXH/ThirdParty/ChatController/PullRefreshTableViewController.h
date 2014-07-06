//
//  PullRefreshTableViewController.h
//  QXH
//
//  Created by liuzhencai on 14-7-6.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//  为了添加下拉刷新

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>


@interface PullRefreshTableViewController : MyViewController {
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
}

@property (nonatomic, strong) UIView *refreshHeaderView;
@property (nonatomic, strong) UILabel *refreshLabel;
@property (nonatomic, strong) UIImageView *refreshArrow;
@property (nonatomic, strong) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, strong) NSString *textPull;
@property (nonatomic, strong) NSString *textRelease;
@property (nonatomic, strong) NSString *textLoading;


@property (nonatomic, strong) UICollectionView *myRefreshview;




- (void)setupStrings;
- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopRefreshing;
- (void)refresh;

@end
