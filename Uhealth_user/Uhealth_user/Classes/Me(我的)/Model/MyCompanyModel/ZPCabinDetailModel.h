//
//  ZPCabinDetailModel.h
//  ZPealth
//
//  Created by Biao Geng on 2018/9/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPCabinDetailModel : NSObject
/** 小屋服务特色集合 */
@property (nonatomic,strong) NSArray *cabinServiceList;
/** 健康小屋护士集合 */
@property (nonatomic,strong) NSArray *nurseList;
/** 小屋详情介绍，可以是一个长度地址或者是一个链接 */
@property (nonatomic,copy) NSString *cabinDetail;
/** 小屋的logo图片 */
@property (nonatomic,copy) NSString *healthCabinLogo;
/** 小屋内景图片，json字符串 */
@property (nonatomic,strong) NSArray *innerImgList;
/** 小屋名称 */
@property (nonatomic,copy) NSString *healthCabinName;
@end
