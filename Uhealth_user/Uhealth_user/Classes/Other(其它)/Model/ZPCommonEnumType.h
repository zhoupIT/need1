//
//  ZPCommonEnumType.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPCommonEnumType : NSObject
/* 枚举值的code */
@property (nonatomic,assign) NSInteger code;
/* 英文字段,一般用这个来对比 */
@property (nonatomic,copy) NSString *name;
/* 中文显示字段 */
@property (nonatomic,copy) NSString *text;
@end

NS_ASSUME_NONNULL_END
