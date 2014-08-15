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
    float heightX = 0;
    if ([model.refsign length] < 50) {
        _detailLabel.hidden = YES;
        _commentLabel.text = model.refsign;
        heightX =51- [SquareCellEx labelhight:model];
        [_commentLabel setFrame:CGRectMake(70, 35, 234, [SquareCellEx labelhight:model])];
        [_bomView setFrame:CGRectMake(70, 97-heightX, 234, 63)];
    }else{
        _commentLabel.text = [[model.refsign substringToIndex:50] stringByAppendingString:@"..."];
        _detailLabel.hidden = NO;
        [_commentLabel setFrame:CGRectMake(70, 29, 234, 51)];
        [_bomView setFrame:CGRectMake(70, 97, 234, 63)];
    }
    _nameLabel.text = model.uname;
    _dateLabel.text = [model.date substringToIndex:10];
    if (flag == 0) {
        _contentLabel.text = _infoModel.title;
        [_subImageView setImageWithURL:IMGURL(_infoModel.artimgs)];
    }else{
        _contentLabel.text = _infoModel.title;
        [_subImageView setImageWithURL:IMGURL(_infoModel.sphoto)];
    }

}

+ (float)height:(SquareInfo *)model
{
    float heightX = 0;
    if ([model.refsign length] < 50) {

        
      heightX =51- [SquareCellEx labelhight:model];
    }
    return (168-heightX);
}

+ (float)labelhight:(SquareInfo *)model
{
    UILabel* temlabel = [[UILabel alloc]init];
    temlabel.text = model.refsign;
    temlabel.numberOfLines = 0;
    temlabel.lineBreakMode = NSLineBreakByWordWrapping;
    UIFont* font = [UIFont systemFontOfSize:13.f];
    CGSize size = CGSizeMake(234,2000);
    CGSize labelsize = [model.refsign sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    return labelsize.height;
}
@end
