//
//  ZPCabinServiceModel.h
//  ZPealth
//
//  Created by Biao Geng on 2018/9/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * 小屋特色服务
 */
@interface ZPCabinServiceModel : NSObject
/** 特色服务ID */
@property (nonatomic,copy) NSString *ID;
/** 小屋ID */
@property (nonatomic,copy) NSString *cabinId;
/** 服务名称 */
@property (nonatomic,copy) NSString *serviceName;
/** 服务简介 */
@property (nonatomic,copy) NSString *serviceIntroduction;
/** 服务图片地址 */
@property (nonatomic,copy) NSString *serviceImg;
@end
