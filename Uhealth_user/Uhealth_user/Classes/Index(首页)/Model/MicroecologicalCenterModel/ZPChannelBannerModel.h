//
//  ZPChannelBannerModel.h
//  ZPealth
//
//  Created by Biao Geng on 2018/8/10.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPChannelBannerModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *companyName;
@property (nonatomic,strong) ZPCommonEnumType *launchPlatform;
@property (nonatomic,strong) ZPCommonEnumType *position;
@property (nonatomic,copy) NSString *banner;
@property (nonatomic,strong) ZPCommonEnumType *bannerType;
@property (nonatomic,copy) NSString *bannerAim;
@end
