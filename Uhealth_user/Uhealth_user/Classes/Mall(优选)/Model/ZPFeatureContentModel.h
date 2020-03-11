//
//  ZPFeatureContentModel.h
//  ZPealth
//
//  Created by Biao Geng on 2018/10/24.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPFeatureContentModel : NSObject
/** 是否点击(默认没有点击) */
@property (nonatomic,assign)BOOL isSelect;
/** 是否可以被点击(默认都可以) */
@property (nonatomic,assign)BOOL isDisableSelect;
/** 属性名 */
@property (nonatomic, copy) NSString *infoName;
@end

NS_ASSUME_NONNULL_END
