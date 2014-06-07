//
//  MyTribeDetailViewController.m
//  QXH
//
//  Created by XUE on 14-5-21.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "MyTribeDetailViewController.h"
#import "AddressListViewController.h"
#import "YSKeyboardTableView.h"

@interface MyTribeDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) YSKeyboardTableView *mainTable;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UIImage *headImage;
@end

@implementation MyTribeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        _items = @[@"部落名称",@"部落秘书长",@"头像",@"部落标签",@"部落地域",@"新消息通知",@"置顶聊天",@"介绍",@"当前部落成员",@"清空聊天记录"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"详细资料";
    // Do any additional setup after loading the view.
    
    _mainTable = [[YSKeyboardTableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - 70) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    [_mainTable setup];
    [self.view addSubview:_mainTable];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, _mainTable.bottom, UI_SCREEN_WIDTH, 70)];
    //添加阴影
    footerView.backgroundColor = [UIColor clearColor];
    CGPathRef path = [UIBezierPath bezierPathWithRect:footerView.bounds].CGPath;
    [footerView.layer setShadowPath:path];
    footerView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    footerView.layer.shadowOffset = CGSizeMake(0, 1);
    footerView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    footerView.layer.shadowOpacity = 0.5f;
    [self.view addSubview:footerView];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake((footerView.width - 267)/2.0, (footerView.height - 40)/2.0, 267, 40);
    if (self.isCreatDetail) {
        [nextBtn setTitle:@"创建部落" forState:UIControlStateNormal];
    }else{
        [nextBtn setTitle:@"退出部落" forState:UIControlStateNormal];
    }
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_screening_normal"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_screening_highlight"] forState:UIControlStateHighlighted];
    [nextBtn addTarget:self action:@selector(exitTribe:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:nextBtn];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)exitTribe:(UIButton *)sender{
    NSLog(@"exit tribe");
    if (self.isCreatDetail) {
        //创建部落
//        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:nil];
//        [HttpRequest requestWithParams:params andCompletionHandler:^(NSMutableDictionary *dict) {
//            NSLog(@"返回值:%@",dict);
//        }];
//        [self showAlert:@"部落创建成功"];
        
        /**
         *  创建部落
         *
         *  @param tribename  部落名称
         *  @param tribestyle 部落类型
         *  @param userid     秘书长userid
         *  @param signature  部落签名
         *  @param desc       部落描述
         *  @param condition  加入条件
         *  @param purpose    宗旨
         *  @param rule       章程
         *  @param tags       不同标签之间用逗号隔开
         *  @param district   地域信息
         *  @param maxcount   最多人数
         *  @param members    部落成员，成员(userid)之间以逗号隔开
         *  @param callback   回调
         */
        [DataInterface createTribe:@"xxxxxx"
                        tribestyle:@""
                         secretary:@""  //userid
                         signature:@""
                              desc:@""
                         condition:@""
                           purpose:@""
                              rule:@""
                              tags:@""
                          district:@""
                          maxcount:@"30"
                           members:@""
             withCompletionHandler:^(NSMutableDictionary *dict){
                 NSLog(@"创建部落返回值：%@",dict);
                 [self showAlert:[dict objectForKey:@"info"]];
        }];
    }else{//退出部落
//        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:nil];
//        [HttpRequest requestWithParams:params andCompletionHandler:^(NSMutableDictionary *dict) {
//            NSLog(@"返回值:%@",dict);
//        }];
//        [self showAlert:@"您已退出本部落"];
        
        /**
         *  退出部落
         *
         *  @param targetid 被处理的退出成员的userid(如果该字段与userid相同为主动退出，不相同，为管理者踢出部落)
         *  @param tribeid  部落唯一标示
         *  @param callback 回调
         */
//        + (void)quitTribe:(NSString *)targetid
//    tribeid:(NSString *)tribeid
//    withCompletionHandler:(DictCallback)callback;
        [DataInterface quitTribe:@""  //100013
                         tribeid:@"6"
           withCompletionHandler:^(NSMutableDictionary *dict){
               NSLog(@"退出部落返回值：%@",dict);
               [self showAlert:[dict objectForKey:@"info"]];
        }];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
    bgView.image = [UIImage imageNamed:@"bar_transition"];
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 7) {
        return 80;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *title = [self addLabelWithFrame:CGRectMake(20, (cell.height - 30)/2.0, 280, 30)
                                            text:@""
                                           color:[UIColor blackColor]
                                            font:[UIFont systemFontOfSize:14]];
        title.tag = 200;
        [cell.contentView addSubview:title];
    }
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:200];
    titleLabel.frame = CGRectMake(20, (cell.height - 30)/2.0, 100, 30);
    titleLabel.text = [_items objectAtIndex:indexPath.row];
    
    UIView *subView = [cell.contentView viewWithTag:201];
    [subView removeFromSuperview];
    switch (indexPath.row) {
        case 0:{//部落名称
            UITextField *nameTextField = [self addTextFieldWithFrame:CGRectMake(titleLabel.right, titleLabel.top, 180, 30)
                                                         placeHolder:@""];
            nameTextField.tag = 201;
            nameTextField.enabled = NO;
            if (self.isCreatDetail) {
                nameTextField.placeholder = @"输入部落名称";
                nameTextField.enabled = YES;
            }
            [cell.contentView addSubview:nameTextField];
//            nameTextField.backgroundColor = [UIColor greenColor];
        }
            break;
        case 1:{//选择秘书长
            if (self.isCreatDetail) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
            break;
        case 2:{//头像
//            UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.contentView.width - 36 - 10, (cell.contentView.height - 36)/2.0, 36, 36)];
//            headImgView.tag = 201;
//            headImgView.image = [UIImage imageNamed:@"img_portrait72"];
//            [cell.contentView addSubview:headImgView];
            
            UIButton *head = [UIButton buttonWithType:UIButtonTypeCustom];
            head.frame = CGRectMake(cell.contentView.width - 36 - 10, (cell.contentView.height - 36)/2.0, 36, 36);
            [head setBackgroundImage:[UIImage imageNamed:@"img_portrait72"] forState:UIControlStateNormal];
            head.tag = 201;
            [head addTarget:self action:@selector(addHeadImage:) forControlEvents:UIControlEventTouchUpInside];
            head.enabled = NO;
            if (self.isCreatDetail) {
                head.enabled = YES;
                if (self.headImage) {
                   [head setBackgroundImage:self.headImage forState:UIControlStateNormal];
                }
            }
            [cell.contentView addSubview:head];
        }
            break;
        case 3:{//部落标签
            UITextField *labelTextField = [self addTextFieldWithFrame:CGRectMake(titleLabel.right, titleLabel.top, 180, 30)
                                                         placeHolder:@""];
            labelTextField.tag = 201;
            labelTextField.enabled = NO;
            if (self.isCreatDetail) {
                labelTextField.placeholder = @"输入部落标签";
                labelTextField.enabled = YES;
            }
            [cell.contentView addSubview:labelTextField];
//            labelTextField.backgroundColor = [UIColor greenColor];
        }
            break;
        case 5:{//新消息通知
            UISwitch *newsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(cell.contentView.width - 50 - 10, (cell.contentView.height - 30)/2.0, 50, 30)];
            newsSwitch.tag = 201;
            newsSwitch.on = YES;
            [newsSwitch addTarget:self action:@selector(newsSwitchAction:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:newsSwitch];
        }
            break;
        case 6:{//置顶聊天
            UISwitch *newsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(cell.contentView.width - 50 - 10, (cell.contentView.height - 30)/2.0, 50, 30)];
            newsSwitch.tag = 201;
            newsSwitch.on = NO;
            [newsSwitch addTarget:self action:@selector(topSwitchAction:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:newsSwitch];
        }
            break;
        case 7:{//介绍
            titleLabel.frame = CGRectMake(20, (44 - 30)/2.0, 100, 30);
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right, titleLabel.top, 200, 80 - 14)];
//            label.backgroundColor = [UIColor clearColor];
//            label.tag = 201;
//            label.text = @"";
//            [cell.contentView addSubview:label];
            
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(titleLabel.right, titleLabel.top, 200, 80 - 14)];
            textView.tag = 201;
            textView.editable = NO;
            if (self.isCreatDetail) {
                textView.text = @"输入介绍";
                textView.editable = YES;
            }
            [cell.contentView addSubview:textView];
//            textView.backgroundColor = [UIColor greenColor];
        }
            break;
        case 8:{//当前成员数
            UITextField *labelTextField = [self addTextFieldWithFrame:CGRectMake(titleLabel.right, titleLabel.top, 180, 30)
                                                          placeHolder:@""];
            labelTextField.tag = 201;
            labelTextField.enabled = NO;
            if (self.isCreatDetail) {
                labelTextField.placeholder = @"输入成员数";
                labelTextField.enabled = YES;
            }
            [cell.contentView addSubview:labelTextField];
//            labelTextField.backgroundColor = [UIColor greenColor];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
    if (self.isCreatDetail) {
        if (indexPath.row == 1) {
            AddressListViewController *addressList = [[AddressListViewController alloc] init];
            addressList.addressListBlock = ^(NSDictionary *dict){
                NSLog(@"通讯录列表返回值%@",dict);
            };
            [self.navigationController pushViewController:addressList animated:YES];
        }
    }else{
        if (indexPath.row == 9) {
            NSLog(@"清空聊天记录");
            [self showAlert:@"聊天记录已清空"];
        }
    }
}

- (void)newsSwitchAction:(UISwitch *)newsSwitch{
    NSLog(@"news:%d",newsSwitch.on);
}

- (void)topSwitchAction:(UISwitch *)topSwitch{
    NSLog(@"top:%d",topSwitch.on);
}

- (void)addHeadImage:(UIButton *)sender{
    NSLog(@"选择头像");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [alert show];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
    [_mainTable reloadData];
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
