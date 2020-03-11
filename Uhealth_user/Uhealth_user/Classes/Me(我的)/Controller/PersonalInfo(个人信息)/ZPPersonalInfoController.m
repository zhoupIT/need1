//
//  ZPPersonalInfoController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/3/22.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPPersonalInfoController.h"
#import "HSSetTableViewController.h"
#import "ZPModifyNameController.h"
//#import "ZPCompanyAddressController.h"
#import "ZPUserModel.h"
#import "ZPBindingCompanyController.h"
typedef NS_ENUM (NSInteger,ZPSexType) {
    ZPSexTypeMALE,
    ZPSexTypeFEMALE,
    ZPSexTypeUNKNOWN
};
@interface ZPPersonalInfoController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong)HSImageCellModel *header;
@property (nonatomic,strong) HSTextCellModel *sex;
@property (nonatomic,strong) HSTextCellModel *name;
@property (nonatomic,strong) HSTextCellModel *birth;
@property (nonatomic,strong) HSTextCellModel *address;
@property (nonatomic,strong) HSTextCellModel *company;
//创建对象
@property (nonatomic, strong) UIDatePicker *datePicker;
//日期上方的取消和确定视图
@property (nonatomic,strong) UIToolbar *inputAccessoryView;
//用户模型
@property (nonatomic,strong) ZPUserModel *userModel;

@property (nonatomic,assign) ZPSexType sextype;
@end

@implementation ZPPersonalInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self getUserInfo];
}

#pragma mark - private method
//获取本地个人信息 并赋值
- (void)getUserInfo {
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        ZPUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
        self.userModel = model;
        self.header.imageUrl = model.portrait;
        self.name.detailText = model.nickName;
        if (model.gender == nil) {
            self.sex.detailText = @"";
        } else {
            self.sex.detailText = [model.gender.text isEqualToString:@"未知"]?@"":model.gender.text;
            if ([model.gender.name isEqualToString:@"FEMALE"]) {
                self.header.placeHoderImage = [UIImage imageNamed:@"user_female"];
            } else {
                self.header.placeHoderImage = [UIImage imageNamed:@"user_male"];
            }
        }
        self.birth.detailText = model.birthday;
        self.address.detailText = model.companyAddress;
        self.company.detailText = model.companyName;
        if (model.companyName.length) {
            self.company.showArrow = NO;
            self.company.actionBlock = nil;
        }
        [self updateCellModel:self.header];
        [self updateCellModel:self.name];
        [self updateCellModel:self.sex];
        [self updateCellModel:self.birth];
        [self updateCellModel:self.address];
        [self updateCellModel:self.company];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *resDate = [formatter dateFromString:self.birth.detailText];
        // 设置当前显示时间
        [self.datePicker setDate:resDate animated:YES];
    }
}

//修改性别
- (void)updateUserSex {
    WEAK_SELF(weakSelf);
    [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"modifyUserInfo" parameters:@{@"gender":[self getEngSex]} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
//            [MBProgressHUD showSuccess:@"修改性别成功"];
            ZPLog(@"修改性别成功");
            ZPUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
            model.gender.text = self.sex.detailText;
            model.gender.name = [self getEngSex];
            [NSKeyedArchiver archiveRootObject:model toFile:ZPUserInfoPATH];
            if ([model.gender.name isEqualToString:@"FEMALE"]) {
                weakSelf.header.placeHoderImage = [UIImage imageNamed:@"user_female"];
            } else {
                weakSelf.header.placeHoderImage = [UIImage imageNamed:@"user_male"];
            }
            [weakSelf updateCellModel:weakSelf.header];
        } else {
//            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        
    } className:[ZPPersonalInfoController class]];
}


- (void)changeAva {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertCtrol = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        
    }];
    
    UIAlertAction *takephotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            [MBProgressHUD showError:@"请允许程序运行拍照功能"];
        }
        [weakSelf presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *choosephotoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            
        }else{
            [MBProgressHUD showError:@"请允许程序打开相册"];
        }
        pickerImage.delegate = self;
        pickerImage.allowsEditing = YES;
        
        [weakSelf presentViewController:pickerImage animated:YES completion:nil];
    }];
    [alertCtrol addAction:cancle];
    [alertCtrol addAction:takephotoAction];
    [alertCtrol addAction:choosephotoAction];
    [self.navigationController presentViewController:alertCtrol animated:YES completion:nil];
}

- (void)changeName {
     __weak typeof(self) weakSelf = self;
    ZPModifyNameController *modNameControl = [[ZPModifyNameController alloc] init];
    modNameControl.updateName = ^(NSString *name) {
        weakSelf.name.detailText = name;
        [weakSelf updateCellModel:self.name];
    };
    [self.navigationController pushViewController:modNameControl animated:YES];
}

- (void)changeSex {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertCtrol = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        
    }];
    
    UIAlertAction *takephotoAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.sex.detailText = @"男";
        [weakSelf updateCellModel:weakSelf.sex];
        [weakSelf updateUserSex];
    }];
    UIAlertAction *choosephotoAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.sex.detailText = @"女";
        [weakSelf updateCellModel:weakSelf.sex];
        [weakSelf updateUserSex];
    }];
    [alertCtrol addAction:cancle];
    [alertCtrol addAction:takephotoAction];
    [alertCtrol addAction:choosephotoAction];
    [self.navigationController presentViewController:alertCtrol animated:YES completion:nil];
}


- (void)setupDateKeyPan {
//    if (!self.datePicker) {
//
//    }
    [UIView animateWithDuration:.3 animations:^{
        self.datePicker.frame=CGRectMake(0,kSCREEN_HEIGHT-236,kSCREEN_WIDTH,236);
        self.inputAccessoryView.frame=CGRectMake(0,kSCREEN_HEIGHT-236-44,kSCREEN_WIDTH,44);
    } completion:^(BOOL finished) {
//        self.datePicker = nil;
//        self.inputAccessoryView = nil;
    }];
    
}

- (void)done {
    [UIView animateWithDuration:.3 animations:^{
        self.datePicker.frame=CGRectMake(0,kSCREEN_HEIGHT+44,kSCREEN_WIDTH,236);
        self.inputAccessoryView.frame=CGRectMake(0,kSCREEN_HEIGHT,kSCREEN_WIDTH,44);
    } completion:^(BOOL finished) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //设置时间格式
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateStr = [formatter  stringFromDate:self.datePicker.date];
        self.birth.detailText = dateStr;
        [self updateCellModel:self.birth];
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        //设置时间格式
        formatter1.dateFormat = @"yyyy-MM-dd";
        
        NSString *dateStr1 = [formatter1 stringFromDate:self.datePicker.date];
//        self.datePicker = nil;
//        self.inputAccessoryView = nil;
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"modifyUserInfo" parameters:@{@"birthday":dateStr1} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                ZPLog(@"修改出生日期成功");
                [MBProgressHUD showSuccess:@"修改出生日期成功"];
                ZPUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
                model.birthday = dateStr;
                [NSKeyedArchiver archiveRootObject:model toFile:ZPUserInfoPATH];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPPersonalInfoController class]];
    }];
}

- (void)cancel {
    [UIView animateWithDuration:.3 animations:^{
        self.datePicker.frame=CGRectMake(0,kSCREEN_HEIGHT+44,kSCREEN_WIDTH,236);
        self.inputAccessoryView.frame=CGRectMake(0,kSCREEN_HEIGHT,kSCREEN_WIDTH,44);
    } completion:^(BOOL finished) {
//        self.datePicker = nil;
//        self.inputAccessoryView = nil;
    }];
}

- (void)dateChange:(UIDatePicker *)datePicker {
}

#pragma mark - delegate
// 选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
//    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
//    if ([type isEqualToString:@"public.image"])
//    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        UIImage *image = info[UIImagePickerControllerEditedImage];
        NSData *data = UIImageJPEGRepresentation(image,0.0);
       
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        
    [MBProgressHUD showMessage:@"上传图片中..."];
    
        // 1.任务一：获取用户上传的图片的url
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"file" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSString *imageName = [NSString stringWithFormat:@"portrait.jpeg"];
            [formData appendPartWithFileData:data name:@"file" fileName:imageName mimeType:@"jpeg"];
        } progress:^(NSProgress *progress) {
        
        } success:^(NSURLSessionDataTask *task, id response) {
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSString *fullPath = [response objectForKey:@"data"];
                //更新用户的头像的url
                [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"modifyUserInfo" parameters:@{@"portrait":fullPath} progress:^(NSProgress *progress) {
                    
                } success:^(NSURLSessionDataTask *task, id response) {
                    [MBProgressHUD hideHUD];
                    if ([[response objectForKey:@"code"] integerValue]  == 200) {
                        [MBProgressHUD showSuccess:@"上传个人头像成功"];
                        //加在视图中
                        self.header.imageIcon = image;
                        self.header.cornerRadius = self.header.imageSize.height*0.5;
                        [self updateCellModel:self.header];
                        
                        if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
                            ZPUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
                            model.portrait = fullPath;
                            [NSKeyedArchiver archiveRootObject:model toFile:ZPUserInfoPATH];
                        }
                    } else {
                        [MBProgressHUD showError:[response objectForKey:@"message"]];
                    }
                } failed:^(NSURLSessionDataTask *task, NSError *error) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:error.localizedDescription];
                } className:[ZPPersonalInfoController class]];
            } else {
                 [MBProgressHUD hideHUD];
                 [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPPersonalInfoController class]];
}

// 取消选取图片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)getEngSex {
    if ([self.sex.detailText isEqualToString:@"男"]) {
        return @"MALE";
    } else if ([self.sex.detailText isEqualToString:@"女"]) {
        return @"FEMALE";
    }
    return @"UNKNOWN";
}

- (void)setupUI {
    self.view.backgroundColor = RGB_242_242_242;
    self.title = @" 个人信息";
    
    
    //初始化tableView
    [self initSetTableViewConfigureStyle:UITableViewStyleGrouped];
    
    __weak typeof(self) weakSelf = self;
    //组装数据源
    //头像
    UIImage *icon = [UIImage imageNamed:@"common_userMale_icon"];
    
    HSImageCellModel *header = [[HSImageCellModel alloc] initWithTitle:@"头像" placeholderImage:icon imageUrl:nil actionBlock:^(HSBaseCellModel *model) {
        [weakSelf changeAva];
    } imageBlock:^(HSBaseCellModel *cellModel) {
        HSLog(@"点击头像--%@",cellModel)
        [weakSelf changeAva];
    }];
    header.titleColor = RGB_74_74_74;
    header.titleFont = [UIFont systemFontOfSize:15];
    header.cornerRadius = 30;
    self.header = header;
    
    
    //名字
    HSTextCellModel *name = [[HSTextCellModel alloc] initWithTitle:@"昵称" detailText:@"" actionBlock:^(HSBaseCellModel *model) {
        [weakSelf changeName];
    }];
    name.titleColor = RGB_74_74_74;
    name.titleFont = [UIFont systemFontOfSize:15];
    self.name = name;
    
    
    
    //性别
    HSTextCellModel *sex = [[HSTextCellModel alloc] initWithTitle:@"性别" detailText:@"" actionBlock:^(HSBaseCellModel *model) {
        [weakSelf changeSex];
    }];
    sex.titleColor = RGB_74_74_74;
    sex.titleFont = [UIFont systemFontOfSize:15];
    self.sex = sex;
    
    //日期
    HSTextCellModel *birth = [[HSTextCellModel alloc] initWithTitle:@"出生日期" detailText:@"" actionBlock:^(HSBaseCellModel *model) {
        [weakSelf setupDateKeyPan];
    }];
    birth.titleColor = RGB_74_74_74;
    birth.titleFont = [UIFont systemFontOfSize:15];
    self.birth = birth;

    //地址
    HSTextCellModel *address = [[HSTextCellModel alloc] initWithTitle:@"公司地址" detailText:@"" actionBlock:^(HSBaseCellModel *model) {
//        ZPCompanyAddressController *address = [[ZPCompanyAddressController alloc] init];
//        [weakSelf.navigationController pushViewController:address animated:YES];
    }];
    address.titleColor = RGB_74_74_74;
    address.titleFont = [UIFont systemFontOfSize:15];
    self.address = address;
    
    //绑定公司
    HSTextCellModel *company = [[HSTextCellModel alloc] initWithTitle:@"绑定公司" detailText:@"" actionBlock:^(HSBaseCellModel *model) {
        ZPBindingCompanyController *companyControl = [[ZPBindingCompanyController alloc] init];
        companyControl.updateComBlock = ^{
            if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
                ZPUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
                weakSelf.company.detailText = model.companyName;
                weakSelf.company.showArrow = NO;
                weakSelf.company.actionBlock = nil;
                [weakSelf updateCellModel:weakSelf.company];
            }
        };
        [self.navigationController pushViewController:companyControl animated:YES];
    }];
    company.titleColor = RGB_74_74_74;
    company.titleFont = [UIFont systemFontOfSize:15];
    self.company = company;
    
    
    NSMutableArray *section0 = [NSMutableArray arrayWithObjects:header,name,sex,birth,company, nil];
    [self.hs_dataArry addObject:section0];
  
    
    [self setupDatePicker];
}

- (void)setupDatePicker {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    // 设置当前显示时间
    [datePicker setDate:[NSDate date] animated:YES];
    // 设置显示最大时间（此处为当前时间）
    [datePicker setMaximumDate:[NSDate date]];
    //监听DataPicker的滚动
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];

    self.datePicker = datePicker;
    
    self.inputAccessoryView= [[UIToolbar alloc]init];
    
    self.inputAccessoryView.barStyle=UIBarStyleDefault;
    self.inputAccessoryView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:ZPMyOrderDetailFontColor forKey:NSForegroundColorAttributeName];
    
    [self.inputAccessoryView sizeToFit];
    
    
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    [cancelBtn setTitleTextAttributes:dic forState:UIControlStateNormal];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    [doneBtn setTitleTextAttributes:dic forState:UIControlStateNormal];
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *array = [NSArray arrayWithObjects:cancelBtn,flexibleSpaceLeft, doneBtn,nil];
    
    [self.inputAccessoryView setItems:array];
    
    [self.view addSubview:self.inputAccessoryView];
    
    self.datePicker.frame=CGRectMake(0,kSCREEN_HEIGHT+44,kSCREEN_WIDTH,236);
    self.inputAccessoryView.frame=CGRectMake(0,kSCREEN_HEIGHT,kSCREEN_WIDTH,44);
 
}
@end
