//
//  ZPSpecificationsModel.h
//  ZPealth
//
//  Created by Biao Geng on 2018/10/23.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPFeatureContentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZPSpecificationsModel : NSObject
/** 属性名 */
@property (nonatomic,copy) NSString *attrname;
/** 属性值 */
@property (nonatomic,strong) NSArray *attrvalue;
@end

NS_ASSUME_NONNULL_END
