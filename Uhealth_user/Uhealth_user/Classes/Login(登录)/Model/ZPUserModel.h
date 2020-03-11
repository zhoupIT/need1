//
//  ZPUserModel.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPUserModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *portrait;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,strong) ZPCommonEnumType *gender;
@property (nonatomic,copy) NSString *birthday;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *signature;
@property (nonatomic,copy) NSString *areaId;
@property (nonatomic,copy) NSString *areaFull;
@property (nonatomic,copy) NSString *companyAddress;
@property (nonatomic,copy) NSString *companyId;
@property (nonatomic,copy) NSString *companyName;
@property (nonatomic,copy) NSString *welcomeMessage;
/* 个人手机号码(后台没有返回) */
@property (nonatomic,copy) NSString *phone;
@end

NS_ASSUME_NONNULL_END
