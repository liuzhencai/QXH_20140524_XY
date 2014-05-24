//
//  OneDreamController.m
//  QXH
//
//  Created by ZhaoLilong on 14-5-4.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "OneDreamController.h"
#import "ActivityCell.h"


@interface OneDreamController ()

@end

@implementation OneDreamController

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
    self.title = @"直播间";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 220;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityCell *cell;
    static NSString *cellIdentifier = @"ActivityIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_chatController)
        _chatController = [ChatController new];
    _chatController.delegate = self;
    _chatController.opponentImg = [UIImage imageNamed:@"tempUser.png"];
    _chatController.MyHeadImg = [UIImage imageNamed:@"tempUser.png"];
    _chatController.chatTitle = @"张三";
    [self.navigationController pushViewController:_chatController animated:YES];
}

#pragma mark chatcontroller
- (void) chatController:(ChatController *)chatController didSendMessage:(NSMutableDictionary *)message
{
    // Messages come prepackaged with the contents of the message and a timestamp in milliseconds
    //    NSLog(@"Message Contents: %@", message[kMessageContent]);
    NSLog(@"Timestamp: %@", message[kMessageTimestamp]);
    
    // Evaluate or add to the message here for example, if we wanted to assign the current userId:
    message[@"sentByUserId"] = @"currentUserId";
    icout++;
    
    message[@"kMessageRuntimeSentBy"] = [NSNumber numberWithInt:((icout%2)?kSentByUser:kSentByOpponent)];
    
    // Must add message to controller for it to show
    [_chatController addNewMessage:message];
}

/*!
 Close Chat Controller - Will Dismiss If Nothing Selected
 */
//- (void) closeChatController:(ChatController *)chatController
//{
////    [chatController dismissViewControllerAnimated:YES completion:^{
////        [chatController removeFromParentViewController];
//////        chatController = nil;
////    }];
//}
@end
