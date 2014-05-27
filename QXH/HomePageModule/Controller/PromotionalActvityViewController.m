//
//  PromotionalActvityViewController.m
//  QXH
//
//  Created by XueYong on 5/17/14.
//  Copyright (c) 2014 ZhaoLilong. All rights reserved.
//

#import "PromotionalActvityViewController.h"

@interface PromotionalActvityViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIScrollView *mainScroll;

@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) UITextView *activityDes;//活动描述

@property (nonatomic, strong) UITextField *name;//活动名称
@property (nonatomic, strong) UITextField *place;//活动地点
@property (nonatomic, strong) UITextField *comeFrom;//活动来源

@property (nonatomic, strong) UILabel *startTime;//活动开始时间
@property (nonatomic, strong) UILabel *endTime;//活动结束时间
@property (nonatomic, strong) UILabel *type;//活动类型
@property (nonatomic, strong) UILabel *cutOffTime;//报名截止时间
@property (nonatomic, strong) UILabel *limitCount;//报名截止时间

@property (nonatomic, strong) UIImage *headImage;//头像
@property (nonatomic, strong) UIImageView *headImgView;//头像
@property (nonatomic, strong) UIButton *uploadImageBtn;//上传图片
@property (nonatomic, strong) UIButton *commitBtn;//提交按钮

@end

#define HEIGHT_CELL 30
#define WIDTH_VALUE 180
#define WIDTH_TITLE 80
@implementation PromotionalActvityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _items = @[@"活动名称",@"活动描述:",@"地        点:",@"来        自:",@"开始时间:",@"结束时间:",@"活动类型:",@"报名截止:",@"人数限制:"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"发活动";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    
    _mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT)];
    [self.view addSubview:_mainScroll];
    
    CGFloat tableHeight = 8 * HEIGHT_CELL + 100;
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, UI_SCREEN_WIDTH- 20, tableHeight + 5) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTable.backgroundColor = [UIColor clearColor];
    _mainTable.scrollEnabled = NO;
    CGRect tableFrame = _mainTable.frame;
    UIImageView *tableBgView = [[UIImageView alloc] initWithFrame:tableFrame];
    tableBgView.image = [UIImage imageNamed:@"label"];
    _mainTable.backgroundView = tableBgView;
    [_mainScroll addSubview:_mainTable];
    
    UIButton *userRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    userRegister.frame = CGRectMake((UI_SCREEN_WIDTH - 220)/2.0, _mainTable.bottom + 30, 220, 33);
    self.uploadImageBtn = userRegister;
    [userRegister setTitle:@"上传头像" forState:UIControlStateNormal];
    [userRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [userRegister setBackgroundImage:[UIImage imageNamed:@"btn_submit_normal"] forState:UIControlStateNormal];
    [userRegister setBackgroundImage:[UIImage imageNamed:@"btn_submit_highlight"] forState:UIControlStateHighlighted];
    [userRegister addTarget:self action:@selector(headImage:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScroll addSubview:userRegister];
    
    _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH - 160)/2.0, _mainTable.bottom + 20, 160, 100)];
    _headImgView.hidden = YES;
//    _headImgView.backgroundColor = [UIColor greenColor];
    [_mainScroll addSubview:_headImgView];
    
    _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commitBtn.frame = CGRectMake((UI_SCREEN_WIDTH - 220)/2.0, _headImgView.bottom + 20, 220, 33);
    _commitBtn.hidden = YES;
    [_commitBtn setTitle:@"发布活动" forState:UIControlStateNormal];
    [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_commitBtn setBackgroundImage:[UIImage imageNamed:@"btn_submit_normal"] forState:UIControlStateNormal];
    [_commitBtn setBackgroundImage:[UIImage imageNamed:@"btn_submit_highlight"] forState:UIControlStateHighlighted];
    [_commitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScroll addSubview:_commitBtn];
    
    _mainScroll.contentSize = CGSizeMake(UI_SCREEN_WIDTH, _uploadImageBtn.bottom + 20);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetView{
    _headImgView.hidden = NO;
    _headImgView.image = self.headImage;
    _commitBtn.hidden = NO;
    _uploadImageBtn.hidden = YES;
    _mainScroll.contentSize = CGSizeMake(UI_SCREEN_WIDTH, _commitBtn.bottom + 20);
}

- (void)submit:(UIButton *)sender{
    NSLog(@"submit");
    [self showAlert:@"成功发布"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)headImage:(UIButton *)sender{
    NSLog(@"head image");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [alert show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0 && indexPath.row == 1) {
//        return 100;
//    }
    if (indexPath.row == 1) {
        return 100;
    }
    return HEIGHT_CELL;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 20;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier1 = @"cellId1";
    static NSString *indentifier2 = @"cellId2";
    
    if (indexPath.row == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier1];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier1];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, (HEIGHT_CELL - 20)/2.0, WIDTH_TITLE, 20)];
            title.tag = 200;
            title.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:title];
        }
        UILabel *title = (UILabel *)[cell.contentView viewWithTag:200];
        title.text = [_items objectAtIndex:indexPath.row];
        if (!_activityDes) {
            _activityDes = [[UITextView alloc] initWithFrame:CGRectMake(WIDTH_TITLE + 20, title.top, WIDTH_VALUE, 80)];
            _activityDes.text = @"输入活动描述";
            _activityDes.font = [UIFont systemFontOfSize:14];
            _activityDes.backgroundColor = [UIColor clearColor];
        }
        [cell.contentView addSubview:_activityDes];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, _activityDes.bottom + 5, 300 - 20, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:line];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier2];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier2];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
//        cell.textLabel.text = [[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        [cell.contentView removeAllSubViews];
        
//        if (indexPath.section == 0) {
//            if (indexPath.row == 0) {
//                if (!_name) {
//                    _name = [self addTextFieldWithFrame:CGRectMake(120, (HEIGHT_CELL - 30)/2.0, 180, 30)
//                                            placeHolder:@"请输活动名称"];
////                    _name.backgroundColor = [UIColor greenColor];
//                }
//                [cell.contentView addSubview:_name];
//            }
//        }else{
            switch (indexPath.row) {
                case 0:{
                    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 298, 30)];
                    bgImgView.image = [UIImage imageNamed:@"title_bar_bg"];
                    [cell.contentView addSubview:bgImgView];
                    if (!_name) {
                        _name = [self addTextFieldWithFrame:CGRectMake(WIDTH_TITLE + 20, (HEIGHT_CELL - 30)/2.0, WIDTH_VALUE, 30)
                                                 placeHolder:@"请输活动地点"];
                        //                        _place.backgroundColor = [UIColor greenColor];
                    }
                    [cell.contentView addSubview:_name];
                }
                    break;
                case 2:{
                    if (!_place) {
                        _place = [self addTextFieldWithFrame:CGRectMake(WIDTH_TITLE + 20, (HEIGHT_CELL - 30)/2.0, WIDTH_VALUE, 30)
                                                placeHolder:@"请输活动地点"];
//                        _place.backgroundColor = [UIColor greenColor];
                    }
                    [cell.contentView addSubview:_place];
                }
                    break;
                case 3:{
                    if (!_comeFrom) {
                        _comeFrom = [self addTextFieldWithFrame:CGRectMake(WIDTH_TITLE + 20, (HEIGHT_CELL - 30)/2.0, WIDTH_VALUE, 30)
                                                placeHolder:@"请输活动名称"];
//                        _comeFrom.backgroundColor = [UIColor greenColor];
                    }
                    [cell.contentView addSubview:_comeFrom];
                }
                    break;
                case 4:{
                    if (!_startTime) {
                        _startTime = [self addLabelWithFrame:CGRectMake(WIDTH_TITLE + 20, (HEIGHT_CELL - 30)/2.0, WIDTH_VALUE, 30)
                                                        text:@"开始时间"
                                                       color:[UIColor blackColor]
                                                        font:[UIFont systemFontOfSize:14]];
//                        _startTime.backgroundColor = [UIColor greenColor];
                    }
                    [cell.contentView addSubview:_startTime];
                }
                    break;
                case 5:{
                    if (!_endTime) {
                        _endTime = [self addLabelWithFrame:CGRectMake(WIDTH_TITLE + 20, (HEIGHT_CELL - 30)/2.0, WIDTH_VALUE, 30)
                                                        text:@"结束时间"
                                                       color:[UIColor blackColor]
                                                        font:[UIFont systemFontOfSize:14]];
//                        _endTime.backgroundColor = [UIColor greenColor];
                    }
                    [cell.contentView addSubview:_endTime];
                }
                    break;
                case 6:{
                    if (!_type) {
                        _type = [self addLabelWithFrame:CGRectMake(WIDTH_TITLE + 20, (HEIGHT_CELL - 30)/2.0, WIDTH_VALUE, 30)
                                                      text:@"活动类型"
                                                     color:[UIColor blackColor]
                                                      font:[UIFont systemFontOfSize:14]];
//                        _type.backgroundColor = [UIColor greenColor];
                    }
                    [cell.contentView addSubview:_type];
                }
                    break;
                case 7:{
                    if (!_cutOffTime) {
                        _cutOffTime = [self addLabelWithFrame:CGRectMake(WIDTH_TITLE + 20, (HEIGHT_CELL - 30)/2.0, WIDTH_VALUE, 30)
                                                      text:@"报名截止时间"
                                                     color:[UIColor blackColor]
                                                      font:[UIFont systemFontOfSize:14]];
//                        _cutOffTime.backgroundColor = [UIColor greenColor];
                    }
                    [cell.contentView addSubview:_cutOffTime];
                }
                    break;
                case 8:{
                    if (!_limitCount) {
                        _limitCount = [self addLabelWithFrame:CGRectMake(WIDTH_TITLE + 20, (HEIGHT_CELL - 30)/2.0, WIDTH_VALUE, 30)
                                                         text:@"人数限制"
                                                        color:[UIColor blackColor]
                                                         font:[UIFont systemFontOfSize:14]];
//                        _limitCount.backgroundColor = [UIColor greenColor];
                    }
                    [cell.contentView addSubview:_limitCount];
                }
                    break;
                default:
                    break;
            }
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, (HEIGHT_CELL - 20)/2.0, WIDTH_TITLE, 20)];
        if (indexPath.row == 0) {
            title.font = [UIFont systemFontOfSize:17.0];
        }else{
            title.font = [UIFont systemFontOfSize:14.0];
        }
        title.text = [_items objectAtIndex:indexPath.row];
        title.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:title];
//        }
        
        return cell;
    }
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
}

#pragma mark - UITextFieldDelegate
- (UITextField *)addTextFieldWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
//    textField.textAlignment = NSTextAlignmentRight;
    textField.borderStyle = UITextBorderStyleNone;
    textField.backgroundColor = [UIColor clearColor];
    textField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    textField.placeholder = placeHolder;
//    textField.backgroundColor = [UIColor redColor];
//    textField.textColor = UIColorFromRGB(0x000000);;
    textField.font = [UIFont systemFontOfSize:14];
    textField.delegate = self;
    return textField;
}

- (UILabel *)addLabelWithFrame:(CGRect)frame
                          text:(NSString *)text
                         color:(UIColor *)color
                          font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.text = text;
    if (color) {
        label.textColor = color;
    }
    return label;
}

#pragma mark - 拍照选择照片协议方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    NSData *data;
    if ([mediaType isEqualToString:@"public.image"]){
        //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，哈哈
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        //图片压缩，因为原图都是很大的，不必要传原图
        NSLog(@"图片压缩前大小：%d",[UIImagePNGRepresentation(originImage) length]);
        UIImage *scaleImage = [self scaleImage:originImage toScale:0.3];//[self scaleImage:originImage toScale:0.3];
        //        if ([data length] > 1024 * 1024 * 2) {
        //            scaleImage = [self scaleImage:originImage toScale:0.05];
        //        }else{
        //            scaleImage = [self scaleImage:originImage toScale:0.1];
        //        }
        //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
        if (UIImagePNGRepresentation(scaleImage) == nil) {
            //将图片转换为JPG格式的二进制数据
            data = UIImageJPEGRepresentation(scaleImage, 1);
        } else {
            //将图片转换为PNG格式的二进制数据
            data = UIImagePNGRepresentation(scaleImage);
        }
        //将二进制数据生成UIImage
        UIImage *image = [UIImage imageWithData:data];
        self.headImage = image;
        NSLog(@"图片压缩后大小：%d",[data length]);
        [self showAlert:@"图片上传成功"];
//        NSFileManager *fileManager = [NSFileManager defaultManager];//将图片存储到本地documents
//        NSString *filePath = [[NSHomeDirectory() stringByAppendingString:@"/Documents"] stringByAppendingString:@"/imgs"];
//        BOOL isExist = [fileManager fileExistsAtPath:filePath];
//        if (!isExist) {
//            [fileManager createDirectoryAtPath:filePath
//                   withIntermediateDirectories:YES
//                                    attributes:nil
//                                         error:nil];
//        }
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self resetView];
}

#pragma mark- 缩放图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    switch (buttonIndex) {
        case 1:{//Take picture
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }else{
                NSLog(@"模拟器无法打开相机");
            }
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
        case 2:{
            if ([UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypePhotoLibrary]) {
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:nil];
            }
        }
            break;
        default:
            break;
    }
}

@end
