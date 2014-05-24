//
//  PortraitView.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-5.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "PortraitView.h"

@interface PortraitView()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSArray *portraits;

@property (nonatomic, assign) id<PortraitViewDelegate> delegate;

@end

@implementation PortraitView

@synthesize titleLabel, portraits;

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title portraits:(NSArray *)images andDelegate:(id)del andShowBtn:(BOOL)isShowBtn
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.delegate = del;
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
        titleLabel.text = title;
//        [self addSubview:titleLabel];
        
        //背景
        UIImageView *bgImage = [[UIImageView alloc] initWithFrame:self.bounds];
        bgImage.image = [self stretchiOS6:@"label.png"];
        [self addSubview:bgImage];
        //title背景
        UIImageView *titleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 298, 30)];
        titleImgView.image = [UIImage imageNamed:@"title_bar_bg.png"];
        [bgImage addSubview:titleImgView];
        //title
        UILabel *titleLabels = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
        titleLabels.text = title;
        [titleImgView addSubview:titleLabels];
        
        self.portraits = images;
        
        CGFloat tableWidth = self.frame.size.width - 20;
        if (isShowBtn) {
            tableWidth = 210;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(tableWidth + 20, 43, 60, 30);
//            btn.backgroundColor = [UIColor greenColor];
            [btn setBackgroundImage:[self stretchiOS6:@"btn_enroll_normal.png"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[self stretchiOS6:@"btn_enroll_highlight.png"] forState:UIControlStateHighlighted];
            [btn setTitle:@"我要报名" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
        
        UITableView *table  = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        table.backgroundColor = [UIColor purpleColor];
        [table.layer setAnchorPoint:CGPointMake(0.0, 0.0)];
        table.transform = CGAffineTransformMakeRotation(M_PI/-2);
        table.showsVerticalScrollIndicator = NO;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.frame = CGRectMake(10, 80, tableWidth, 44);
        table.rowHeight = 50;
        NSLog(@"%f,%f,%f,%f",table.frame.origin.x,table.frame.origin.y,table.frame.size.width,table.frame.size.height);
        table.delegate = self;
        table.dataSource = self;
        [self addSubview:table];
        
    }
    return self;

}

- (void)signUp:(UIButton *)sender{
    NSLog(@"我要报名");
    if (self.delegate && [self.delegate respondsToSelector:@selector(singUpPortrait:)]) {
        [self.delegate singUpPortrait:nil];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.portraits count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellIdentifier];
        
//        cell.backgroundColor = [UIColor yellowColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
        cell.textLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
        
        UIImageView *portrait = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        portrait.tag = 100;
        portrait.image = [UIImage imageNamed:@"img_portrait72"];
        [cell.contentView addSubview:portrait];
        
    }
    
    UIImageView *portrait_ = (UIImageView *)[cell.contentView viewWithTag:100];
    if (indexPath.row%2 == 0) {
//        portrait_.backgroundColor = [UIColor redColor];
    }else{
//        portrait_.backgroundColor = [UIColor blueColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"--------->%d",indexPath.row);
    if ([self.delegate respondsToSelector:@selector(selectPortrait:)]) {
        [self.delegate selectPortrait:[self.portraits objectAtIndex:indexPath.row]];
    }
}
- (UIImage *) stretchiOS6:(NSString *)icon {
    UIImage *image = [UIImage imageNamed:icon];
    CGFloat normalLeftCap = image.size.width * 0.5f;
    CGFloat normalTopCap = image.size.height * 0.5f;
    // 13 * 34
    // 指定不需要拉伸的区域
    UIEdgeInsets insets = UIEdgeInsetsMake(normalTopCap, normalLeftCap, normalTopCap - 1, normalLeftCap - 1);
    
    // ios6.0的拉伸方式只不过比iOS5.0多了一个拉伸模式参数
    return [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
}

@end
