//
//  InformationCommentController.m
//  QXH
//
//  Created by ZhaoLilong on 5/18/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "InformationCommentController.h"
#import "InformationCommentCell.h"
#import "NameCardViewController.h"

@interface InformationCommentController ()
{
    NSMutableArray *commentList;
}

@end

@implementation InformationCommentController

- (void)getCommentList
{
    [DataInterface getCommentList:self.artid start:@"0" count:@"20" withCompletionHandler:^(NSMutableDictionary *dict) {
        commentList = [ModelGenerator json2CommentList:dict];
        [_commentTbl reloadData];
    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"评论";
    if (IOS7_OR_LATER) {
        [_commentTbl setSeparatorInset:(UIEdgeInsetsMake(0, 0, 0, 0))];
    }
    [self getCommentList];
    
    UIButton *righttbuttonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    righttbuttonItem.frame = CGRectMake(0, 0,74, 31);
    [righttbuttonItem setTitle:@"发表评论" forState:UIControlStateNormal];
    [righttbuttonItem addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *righttItem = [[UIBarButtonItem alloc] initWithCustomView:righttbuttonItem];
    self.navigationItem.rightBarButtonItem = righttItem;
}

- (void)comment:(id)sender
{
    NSLog(@"发表评论");
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc]init];
    [alertView setUseMotionEffects:TRUE];
    [alertView setButtonTitles:@[@"发表"]];
    UITextView *commentView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 260, 60)];
    [alertView setContainerView:commentView];
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        [DataInterface praiseArticle:self.artid laud:@"0" comment:commentView.text withCompletionHandler:^(NSMutableDictionary *dict) {
            [alertView close];
        }];
    }];
    [alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [commentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"informationComment";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InformationCommentCell" owner:nil options:nil] objectAtIndex:0];
    }
    [(InformationCommentCell *)cell setModel:[commentList objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NameCardViewController *nameCard = [[NameCardViewController alloc] init];
    [self.navigationController pushViewController:nameCard animated:YES];
}

@end
