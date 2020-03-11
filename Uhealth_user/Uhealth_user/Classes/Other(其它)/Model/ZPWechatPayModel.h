//
//  ZPWechatPayModel.h
//  ZPealth
//
//  Created by Biao Geng on 2018/4/17.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPWechatPayModel : NSObject
@property (nonatomic,copy) NSString *appId;
@property (nonatomic,copy) NSString *nonceStr;
@property (nonatomic,copy) NSString *wxPackage;
@property (nonatomic,copy) NSString *partnerId;
@property (nonatomic,copy) NSString *prepayId;
@property (nonatomic,copy) NSString *sign;
@property (nonatomic,copy) NSString *timestamp;
@end
