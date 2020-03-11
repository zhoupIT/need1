//
//  ZPPatientListModel.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPPatientListModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *customerId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,strong) ZPCommonEnumType *relation;
@property (nonatomic,copy) NSString *telephone;
@property (nonatomic,strong) ZPCommonEnumType *idCardType;
@property (nonatomic,copy) NSString *idCardNo;
@property (nonatomic,assign) BOOL isSel;
@end

NS_ASSUME_NONNULL_END
