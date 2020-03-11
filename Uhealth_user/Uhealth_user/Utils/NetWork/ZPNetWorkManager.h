//
//  ZPNetWorkManager.h
//  Uhealth
//
//  Created by Biao Geng on 2018/3/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface ZPNetWorkManager : AFHTTPSessionManager
+ (instancetype)shareNetWorkManager;
/*!**销毁单例***/
+ (void)destroyInstance;
@end
