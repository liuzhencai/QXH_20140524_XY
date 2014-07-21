//
//  FileNameCardViewController.m
//  QXH
//
//  Created by XUE on 14-5-16.
//  Copyright (c) 2014年 ZhaoLilong. All rights reserved.
//

#import "FillNameCardViewController.h"
#import "EditUserInfoViewController.h"
#import "SelectCityViewController.h"

@interface FillNameCardViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) NSArray *items;//填写项
@property (nonatomic, strong) UIImageView *headImgView;//头像
@property (nonatomic, strong) UIImage *headImage;//头像
@property (nonatomic, strong) NSString *imageString;//

@property (nonatomic, strong) NSString *name;//姓名
@property (nonatomic, strong) NSString *signature;//签名
@property (nonatomic, strong) NSString *workUnit;//工作单位
@property (nonatomic, strong) NSString *city;//城市
@property (nonatomic, strong) NSString *duty;//单位职务
@property (nonatomic, strong) NSString *interest;//兴趣爱好
@property (nonatomic, strong) NSString *school;//毕业院校
@property (nonatomic, strong) NSString *phone;//手机号码
@property (nonatomic, strong) NSString *honor;//曾获荣誉

@property (nonatomic, strong) NSDictionary *cityInfo;//城市信息
@end
#define FONT  16
#define CELL_HEIGHT 44
@implementation FillNameCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _items = @[@[@{@"title":@"头像",@"isMust":@NO}],
                   @[@{@"title":@"真实姓名",@"subTitle":@"您的姓名",@"isMust":@YES},
                     @{@"title":@"个性签名",@"subTitle":@"您的签名",@"isMust":@YES},
                     @{@"title":@"工作单位",@"subTitle":@"您的工作单位",@"isMust":@YES},
                     @{@"title":@"城市",@"subTitle":@"您所在城市",@"isMust":@YES},
                     @{@"title":@"单位职务",@"subTitle":@"您的单位职务",@"isMust":@NO},
                     @{@"title":@"兴趣爱好",@"subTitle":@"您的兴趣爱好",@"isMust":@NO},
                     @{@"title":@"毕业院校",@"subTitle":@"您的毕业院校",@"isMust":@NO},
                     @{@"title":@"手机号码",@"subTitle":@"您的手机号",@"isMust":@NO},
                     @{@"title":@"曾获荣誉",@"subTitle":@"您曾获荣誉",@"isMust":@NO}
                     ]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"注册";
    // Do any additional setup after loading the view.
    
    CGFloat tableHeight = 30 + 11 * CELL_HEIGHT;
    CGFloat screenHeight = UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_STATUS_BAR_HEIGHT - 60;
    tableHeight = tableHeight < screenHeight ? tableHeight : screenHeight;
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, tableHeight) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.scrollEnabled = YES;
    [self.view addSubview:_mainTable];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame = CGRectMake((UI_SCREEN_WIDTH - 300)/2.0, screenHeight + 13, 300, 40);
    [submit setTitle:@"提  交" forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submit.titleLabel.font = [UIFont systemFontOfSize:18];
    [submit setBackgroundImage:[UIImage imageNamed:@"btn_submit_normal"] forState:UIControlStateNormal];
    [submit setBackgroundImage:[UIImage imageNamed:@"btn_submit_highlight"] forState:UIControlStateHighlighted];
    [submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submit:(UIButton *)sender{
    NSLog(@"提交");
    
    if (!self.name) {
        [self showAlert:@"请输入姓名"];
        return;
    }
    if (!self.signature) {
        [self showAlert:@"请输入个人签名"];
        return;
    }
    if (!self.workUnit) {
        [self showAlert:@"请输入工作单位"];
        return;
    }
    if (!self.city) {
        [self showAlert:@"请选择城市信息"];
        return;
    }
    if (self.headImage) {
        /**
         *  文件上传
         *  @param file     UIImage对象或文件URL
         *  @param type     1为图片，2为文档，3为音频
         *  @param callback 回调
         */
        [DataInterface fileUpload:self.headImage type:@"1" withCompletionHandler:^(NSMutableDictionary *dict) {
            NSLog(@"上传图片返回值%@",dict);
            self.imageString = [dict objectForKey:@"filename"];
            NSLog(@"%@",[dict objectForKey:@"info"]);
            
            [self submitIsHaveHeadImage:YES];
        } errorBlock:^(NSString *desc) {
            NSLog(@"上传图片错误：%@",desc);
            [self showAlert:desc];
        }];
        
    }else{
        [self submitIsHaveHeadImage:NO];
    }
}

- (void)submitIsHaveHeadImage:(BOOL)isImage{
    NSString *duty = ORIGIN_VAL;//职务
    if ([self.duty length] > 0) {
        duty = self.duty;
    }
    NSString *interest = ORIGIN_VAL;//兴趣爱好
    if ([self.interest length] > 0) {
        interest = self.interest;
    }
    NSString *school = ORIGIN_VAL;//毕业院校
    if ([self.school length] > 0) {
        school = self.school;
    }
    NSString *phone = ORIGIN_VAL;//手机号码
    if ([self.phone length] > 0) {
        phone = self.phone;
    }
    NSString *honor = ORIGIN_VAL;//曾获荣誉
    if ([self.honor length] > 0) {
        honor = self.honor;
    }
    NSString *imageUrl = ORIGIN_VAL;
    if (isImage) {
        imageUrl = self.imageString;
    }
    
    NSString *cityCode = [self.cityInfo objectForKey:@"cityid"];
    
    /**
     *  修改用户信息(注：如果某个字段不修改请将字段的值置为“------”,其他情况视为修改)
     *
     *  @param displayname   昵称
     *  @param oldpwd        老密码
     *  @param newpwd        新密码
     *  @param signature     签名
     *  @param title         头衔职称
     *  @param degree        学位
     *  @param address       籍贯编码
     *  @param domicile      居住地编码
     *  @param introduce     自我介绍
     *  @param comname       公司名称
     *  @param comdesc       公司描述
     *  @param comaddress    公司地址
     *  @param comurl        公司网址
     *  @param induname      行业名称
     *  @param indudesc      行业描述
     *  @param schoolname    学校名称
     *  @param schooltype    学校类型
     *  @param sex           0为保密，1为男，2为女
     *  @param email         用户邮箱
     *  @param tags          用户标签
     *  @param attentiontags 关注标签
     *  @param hobbies       爱好
     *  @param educations    教育经历
     *  @param honours       荣誉
     *  @param callback      回调
     */
    [DataInterface modifyUserInfo:self.name
                           oldpwd:ORIGIN_VAL
                           newpwd:ORIGIN_VAL
                        signature:self.signature
                            title:duty
                           degree:ORIGIN_VAL
                          address:cityCode
                         domicile:cityCode
                        introduce:ORIGIN_VAL
                          comname:ORIGIN_VAL
                          comdesc:ORIGIN_VAL
                       comaddress:ORIGIN_VAL
                           comurl:ORIGIN_VAL
                         induname:ORIGIN_VAL
                         indudesc:ORIGIN_VAL
                       schoolname:school
                       schooltype:ORIGIN_VAL
                              sex:@"0"
                            photo:self.imageString
                            email:ORIGIN_VAL
                             tags:ORIGIN_VAL
                    attentiontags:ORIGIN_VAL
                          hobbies:interest
                       educations:school
                          honours:honor
                         usertype:ORIGIN_VAL
                             gold:ORIGIN_VAL
                            level:ORIGIN_VAL
                        configure:ORIGIN_VAL
            withCompletionHandler:^(NSMutableDictionary *dict) {
                NSLog(@"填写用户信息返回值：%@",dict);
                [self.navigationController popToRootViewControllerAnimated:YES];
                [self showAlert:[dict objectForKey:@"info"]];
    }];
}

#pragma mark - UITableViewDelegate
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_items count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_items objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 30;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
        bgView.backgroundColor = COLOR_WITH_ARGB(231, 242, 222, 1.0);
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, tableView.width - 20 * 2, bgView.height)];
        title.text = @"详细个人信息";
        title.font = [UIFont systemFontOfSize:FONT];
        title.backgroundColor = [UIColor clearColor];
        [bgView addSubview:title];
        return bgView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor blackColor];
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = COLOR_WITH_ARGB(49, 109, 33, 1.0);
        
        UILabel *status = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 30 - 60, (cell.contentView.height - 30)/2.0, 60, 30)];
        status.backgroundColor = [UIColor clearColor];
        status.tag = 100;
        status.font = [UIFont systemFontOfSize:14];
        status.textColor = [UIColor lightGrayColor];
        status.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:status];
        
    }
    NSDictionary *item = [[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    BOOL isMust = [[item objectForKey:@"isMust"] boolValue];
    NSString *title = [item objectForKey:@"title"];
    if (isMust) {
        title = [NSString stringWithFormat:@"%@ (必填)",title];
    }
    cell.textLabel.text = title;
    UIImageView *head = (UIImageView *)[cell.contentView viewWithTag:101];
    [head removeFromSuperview];
    UILabel *status = (UILabel *)[cell.contentView viewWithTag:100];
    if (indexPath.section == 1) {
        cell.detailTextLabel.text = [item objectForKey:@"subTitle"];
        status.hidden = NO;
        status.text = @"未填写";
        switch (indexPath.row) {
            case 0:{//姓名
                if (self.name) {
                    cell.detailTextLabel.text = self.name;
                    status.text = @"已填写";
                }
            }
                break;
            case 1:{//签名
                if (self.signature) {
                    cell.detailTextLabel.text = self.signature;
                    status.text = @"已填写";
                }
            }
                break;
            case 2:{//工作单位
                if (self.workUnit) {
                    cell.detailTextLabel.text = self.workUnit;
                    status.text = @"已填写";
                }
            }
                break;
            case 3:{//城市
                if (self.city) {
                    cell.detailTextLabel.text = self.city;
                    status.text = @"已填写";
                }
            }
                break;
            case 4:{//单位职务
                if (self.duty) {
                    cell.detailTextLabel.text = self.duty;
                    status.text = @"已填写";
                }
            }
                break;
            case 5:{//兴趣爱好
                if (self.interest) {
                    cell.detailTextLabel.text = self.interest;
                    status.text = @"已填写";
                }
            }
                break;
            case 6:{//毕业院校
                if (self.school) {
                    cell.detailTextLabel.text = self.school;
                    status.text = @"已填写";
                }
            }
                break;
            case 7:{//手机号码
                if (self.phone) {
                    cell.detailTextLabel.text = self.phone;
                    status.text = @"已填写";
                }
            }
                break;
            case 8:{//曾获荣誉
                if (self.honor) {
                    cell.detailTextLabel.text = self.honor;
                    status.text = @"已填写";
                }
            }
                break;
                
            default:
                break;
        }
    }else{
        status.hidden = YES;
        UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 30 - 40, 4, 36, 36)];
        [headImageView setRound:YES];
        if (self.headImage) {
            headImageView.image = self.headImage;
        }else{
            headImageView.image = [UIImage imageNamed:@"img_portrait96"];
        }
//        [headImageView setImageWithURL:IMGURL(self.imageString) placeholderImage:[UIImage imageNamed:@"img_portrait96"]];
        [cell.contentView addSubview:headImageView];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选择：%@",indexPath);
    if (indexPath.section == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [alert show];
    }else{
        if (indexPath.row == 3) {//城市
            SelectCityViewController *selectCity = [[SelectCityViewController alloc] init];
            selectCity.selectCityCallBack = ^(NSDictionary *cityDict){
                if (cityDict) {
                    NSLog(@"选择城市:%@",cityDict);
                    self.cityInfo = cityDict;
                    NSString *provinceName = [cityDict objectForKey:@"province"];
                    provinceName = [provinceName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSString *cityName = [cityDict objectForKey:@"city"];
                    NSString *address = [NSString stringWithFormat:@"%@%@",provinceName,cityName];
                    self.city = address;
                    [_mainTable reloadData];
                }
            };
            [self.navigationController pushViewController:selectCity animated:YES];
        }else{
            EditUserInfoViewController *editUserInfo = [[EditUserInfoViewController alloc] init];
            editUserInfo.type = indexPath.row;
            editUserInfo.editUserInfoCallBack = ^(NSString *str){
                NSLog(@"返回值：%@",str);
                if([str length]){
                    switch (indexPath.row) {
                        case 0://姓名
                            self.name = str;
                            break;
                        case 1://签名
                            self.signature = str;
                            break;
                        case 2://工作单位
                            self.workUnit = str;
                            break;
//                        case 3://城市
//                            self.city = str;
//                            break;
                        case 4://单位职务
                            self.duty = str;
                            break;
                        case 5://兴趣爱好
                            self.interest = str;
                            break;
                        case 6://毕业院校
                            self.school = str;
                            break;
                        case 7://手机号码
                            self.phone = str;
                            break;
                        case 8://曾获荣誉
                            self.honor = str;
                            break;
                        default:
                            break;
                    }
                    [_mainTable reloadData];
                }
            };
            [self.navigationController pushViewController:editUserInfo animated:YES];
        }
    }
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
//        /**
//         *  文件上传
//         *  @param file     UIImage对象或文件URL
//         *  @param type     1为图片，2为文档，3为音频
//         *  @param callback 回调
//         */
//        [DataInterface fileUpload:image
//                             type:@"1"
//            withCompletionHandler:^(NSMutableDictionary *dict){
//                NSLog(@"上传图片返回值%@",dict);
//                self.imageString = [dict objectForKey:@"filename"];
//                [self showAlert:[dict objectForKey:@"info"]];
//            }
//                       errorBlock:^(NSString *desc) {
//                           NSLog(@"上传图片错误：%@",desc);
//                           [self showAlert:desc];
//                       }];
        
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
