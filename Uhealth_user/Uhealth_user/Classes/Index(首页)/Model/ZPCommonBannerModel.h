//
//  ZPCommonBannerModel.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPCommonBannerModel : NSObject
@property (nonatomic,copy) NSString *ID;
//用户所绑定的企业id，值为0代表个人用户
@property (nonatomic,copy) NSString *companyId;
//投放平台
@property (nonatomic,strong) ZPCommonEnumType *launchPlatform;
//所属前端位置
@property (nonatomic,strong) ZPCommonEnumType *position;
//banner的url
@property (nonatomic,copy) NSString *banner;
//banner的类型
@property (nonatomic,strong) ZPCommonEnumType *bannerType;
//banner所指向的内容
@property (nonatomic,copy) NSString *bannerAim;
//banner的名称
@property (nonatomic,copy) NSString *bannerName;
//banner状态：ENABLED 发布中，DISABLED下架
@property (nonatomic,strong) ZPCommonEnumType *advertStatus;
//优先级
@property (nonatomic,copy) NSString *priority;
@end

NS_ASSUME_NONNULL_END
