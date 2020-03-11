//
//  ZPRegisterBirthController.h
//  Uhealth
//
//  Created by Biao Geng on 2018/5/15.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPRegisterBirthController : UIViewController
@property (nonatomic,copy) NSString *phoneNumber;
@property (nonatomic,copy) NSString *authCode;
@property (nonatomic,copy) NSString *password;

@property (nonatomic,copy) NSString *companyRegisterCode;

@property (nonatomic,assign) BOOL isPersonalReg;

@property (nonatomic,copy) NSString *authId;
@property (nonatomic,copy) NSString *accessToken;
@end
