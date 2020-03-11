//
//  ZPHospitalModel.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPHospitalModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *cityServiceId;
@property (nonatomic,copy) NSString *hospitalName;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,assign) BOOL isSel;//是否被选中
@end

NS_ASSUME_NONNULL_END
