//
//  ZPAddAddressView.h
//  ZPealth
//
//  Created by Biao Geng on 2018/3/22.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPAddAddressView : UIView
+ (instancetype)addAddressView;
@property (strong, nonatomic) IBOutlet ZPTextView *textView;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;

@property (strong, nonatomic) IBOutlet UIButton *isSelcted;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic,copy) NSString *provinceId;
@property (nonatomic,copy) NSString *cityId;
@property (nonatomic,copy) NSString *counntryId;
@property (nonatomic,copy) NSString *provinceName;
@property (nonatomic,copy) NSString *cityName;
@property (nonatomic,copy) NSString *countryName;

@end
