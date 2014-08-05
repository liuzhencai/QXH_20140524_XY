//
//  SquareCellEx.m
//  QXH
//
//  Created by ZhaoLilong on 5/20/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "SquareCellEx.h"
#import "InformationDetailController.h"
#import "AppDelegate.h"

@interface SquareCellEx ()

@property (nonatomic, strong) InfoModel *infoModel;

@end

@implementation SquareCellEx

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)tap:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    InformationDetailController *controller = [[InformationDetailController alloc] initWithNibName:@"InformationDetailController" bundle:nil];
    controller.artid = _infoModel.artid;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[delegate.tabController.viewControllers objectAtIndex:0] pushViewController:controller animated:YES];
//    controller.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:controller animated:YES];
}

- (void)setCellData:(SquareInfo *)model withFlag:(NSInteger)flag
{
    _infoModel = model.content;
    [_portraitView setImageWithURL:IMGURL(model.uphoto) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
    [_portraitView circular];
    _commentLabel.text = model.refsign;
    _nameLabel.text = model.uname;
    _dateLabel.text = [model.date substringToIndex:10];
    _positionLabel.text = model.uduty;
    if (flag == 0) {
        _contentLabel.text = _infoModel.title;
        [_subImageView setImageWithURL:IMGURL(_infoModel.artimgs)];
    }else{
        _contentLabel.text = _infoModel.content;
        [_subImageView setImageWithURL:IMGURL(_infoModel.sphoto)];
    }

}

@end
