//
//  PersonalCollectionController.m
//  QXH
//
//  Created by ZhaoLilong on 5/14/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "PersonalCollectionController.h"
#import "SquareViewController.h"
#import "SquareCell.h"
#import "SquareCellEx.h"
#import "SquareActivityCell.h"
#import "ShareTextController.h"
#import "InfoModel.h"
#import "InformationCell.h"
#import "InformationDetailController.h"
#import "SquareInfo.h"

@interface PersonalCollectionController ()
{
    NSMutableArray *info;
}
@end

@implementation PersonalCollectionController

- (void)getInfoList
{
    [DataInterface getInfoList:@"0" detailtype:@"3" tag:@"" classify:@"" arttype:@"" contentlength:@"" start:@"0" count:@"20" withCompletionHandler:^(NSMutableDictionary *dict) {
        info = [ModelGenerator json2InfoList:dict];
        [_collectionTable reloadData];
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
    self.title = @"我的收藏";
    [self getInfoList];
    
    _collectionTable.frame = CGRectMake(0, 0, 320, SCREEN_H);
    if (IOS7_OR_LATER) {
        [_collectionTable setSeparatorInset:(UIEdgeInsetsMake(0, 0, 0, 0))];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)loadTblData:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    InfoModel *model = [info objectAtIndex:indexPath.row];
    
    UITableViewCell *tblCell = nil;
    /**
     *  1为广场发布的文章，2为转发到广场的咨询，3为转发到广场的活动
     */
    switch ([model.type integerValue]) {
            case 1:
        {
            // 来自于广场
            static NSString *cellIdentifier = @"oneTypeCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIImageView *portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 48, 48)];
                portraitView.tag = 101;
                [cell.contentView addSubview:portraitView];
                
                UILabel *nameLabel  = [[UILabel alloc] initWithFrame:CGRectMake(68, 10, 100, 21)];
                nameLabel.tag = 102;
                [cell.contentView addSubview:nameLabel];
                
                UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 10, 140, 21)];
                dateLabel.tag = 103;
                [cell.contentView addSubview:dateLabel];
                
                UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 50, 232, 21)];
                contentLabel.tag = 104;
                [cell.contentView addSubview:contentLabel];
                
                for (int i = 0; i < 4; i++) {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(68+i*50+i*10, 80, 50, 50)];
                    imageView.tag = 105+i;
                    imageView.hidden = YES;
                    [cell.contentView addSubview:imageView];
                }
            }
            UIImageView *portraitView_  = (UIImageView *)[cell.contentView viewWithTag:101];
            UILabel *nameLabel_ = (UILabel *)[cell.contentView viewWithTag:102];
            UILabel *dateLabel_ = (UILabel *)[cell.contentView viewWithTag:103];
            UILabel *contentLabel_ = (UILabel *)[cell.contentView viewWithTag:104];
            [portraitView_ setImageWithURL:IMGURL(model.sphoto) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
            [portraitView_ circular];
            nameLabel_.text = model.sname;
            dateLabel_.text = model.date;
            contentLabel_.text = model.content;
            
            if (![model.artimgs isEqualToString:@""]) {
                if ([model.artimgs rangeOfString:@","].location != NSNotFound) {
                    NSArray *imgs = [model.artimgs componentsSeparatedByString:@","];
                    for (int i = 0; i < [imgs count]; i++) {
                        [(UIImageView *)[cell.contentView viewWithTag:(105+i)] setHidden:NO];
                        [(UIImageView *)[cell.contentView viewWithTag:(105+i)] setImageWithURL:IMGURL(imgs[i])];
                    }
                }else{
                    [(UIImageView *)[cell.contentView viewWithTag:105] setHidden:NO];
                    [(UIImageView *)[cell.contentView viewWithTag:105] setImageWithURL:IMGURL(model.artimgs)];
                }
            }else{
                for (int i = 0; i < 4; i++) {
                    [(UIImageView *)[cell.contentView viewWithTag:(105+i)] setHidden:YES];
                }
            }
            
            tblCell = cell;
        }
            break;
        case 2:
        {
            // 来自于智谷
            static NSString *infoIdentifier = @"InformationCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoIdentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"InformationCell" owner:nil options:nil] objectAtIndex:0];
            }
            [(InformationCell *)cell setModel:model];
            tblCell = cell;
        }
            break;
    }
    return tblCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [info count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 44.f;
    InfoModel *model = [info objectAtIndex:indexPath.row];
    switch ([model.type integerValue]) {
        case 1:
        {
            if ([model.artimgs isEqualToString:@""]) {
                rowHeight = 100.f;
            }else{
                rowHeight = 162.f;
            }
        }
            break;
        case 2:
        {
            rowHeight = 80;
        }
            break;
        default:
            break;
    }
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self loadTblData:tableView indexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InfoModel *model = [info objectAtIndex:indexPath.row];
    switch ([model.type integerValue]) {
        case 1:
        {
            ShareTextController *controller = [[ShareTextController alloc] initWithNibName:@"ShareTextController" bundle:nil];
            SquareInfo *tmpModel = [[SquareInfo alloc] init];
            tmpModel.content = model;
            controller.info = tmpModel;
            controller.type = SquareInfoTypeSq;
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 2:
        {
            InformationDetailController *controller = [[InformationDetailController alloc] initWithNibName:@"InformationDetailController" bundle:nil];
            controller.artid = model.artid;
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
