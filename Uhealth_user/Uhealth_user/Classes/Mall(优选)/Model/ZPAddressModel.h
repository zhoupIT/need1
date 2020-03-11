//
//  ZPAddressModel.h
//  ZPealth
//
//  Created by Biao Geng on 2018/4/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPAddressModel : NSObject
/** 收货人id */
@property (nonatomic,copy) NSString *ID;
/** 当前用户id */
@property (nonatomic,copy) NSString *customerId;
/** 收货人姓名 */
@property (nonatomic,copy) NSString *receiver;
/** 收货人关系类型 */
@property (nonatomic,strong) ZPCommonEnumType *relation;
/** 联系方式 */
@property (nonatomic,copy) NSString *phone;
/** 省的Code */
@property (nonatomic,copy) NSString *provinceId;
/** 省 */
@property (nonatomic,copy) NSString *provinceName;
/** 市的Code */
@property (nonatomic,copy) NSString *cityId;
/** 市 */
@property (nonatomic,copy) NSString *cityName;
/** 区的Code */
@property (nonatomic,copy) NSString *countryId;
/** 区 */
@property (nonatomic,copy) NSString *countryName;
/** 地址 */
@property (nonatomic,copy) NSString *address;
/** 是否为默认地址 */
@property (nonatomic,strong) ZPCommonEnumType *addressStatus;
/** 标签 */
@property (nonatomic,strong) ZPCommonEnumType *tag;
@end
