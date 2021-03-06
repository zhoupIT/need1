//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"

@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvPaymentResponse:)]) {
            PayResp *messageResp = (PayResp *)resp;
            [_delegate managerDidRecvPaymentResponse:messageResp];
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvLoginResponse:)]) {
            SendAuthResp *messageResp = (SendAuthResp *)resp;
            [_delegate managerDidRecvLoginResponse:messageResp];
        }
    }
}

@end
