//
//  ZPNetWork.h
//  Uhealth
//
//  Created by Biao Geng on 2018/5/24.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "singleton.h"
@interface ZPNetWork : NSObject

ZPSingletonH(ZPNetWork)

- (void)requestWithUrl:(NSString *)urlStr andHTTPMethod:(NSString *)httpMethod andDict:(NSDictionary *)dict success:(void(^)(NSDictionary *response))success failed:(void (^)(NSError *error))failed withClassName:(NSString *)classString;
@end
