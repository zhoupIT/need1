//
//  ZPNurseListModel.h
//  ZPealth
//
//  Created by Biao Geng on 2018/9/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPNurseModel : NSObject
/** 护士ID */
@property (nonatomic,copy) NSString *ID;
/** 小屋ID */
@property (nonatomic,copy) NSString *cabinId;
/** 公司ID */
@property (nonatomic,copy) NSString *companyCode;
/** 护士头像 */
@property (nonatomic,copy) NSString *nurseImg;
/** 护士姓名 */
@property (nonatomic,copy) NSString *nurseName;
/** 护士简介 */
@property (nonatomic,copy) NSString *nurseIntroduction;
/** 护士职位 */
@property (nonatomic,copy) NSString *nursePosition;
/** 联系方式 */
@property (nonatomic,copy) NSString *nursePhone;
/** 优先级，正序排列 */
@property (nonatomic,copy) NSString *priority;
/** 地址 */
@property (nonatomic,copy) NSString *adress;
@end
