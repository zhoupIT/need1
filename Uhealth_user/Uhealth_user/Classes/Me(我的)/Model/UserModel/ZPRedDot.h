//
//  ZPRedDot.h
//  ZPealth
//
//  Created by Biao Geng on 2018/4/26.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPRedDot : NSObject
@property (nonatomic,copy) NSString *nonPayMentNum;
@property (nonatomic,copy) NSString *nonSendNum;
@property (nonatomic,copy) NSString *nonReceiveNum;
@property (nonatomic,copy) NSString *nonEvaluatedNum;
@property (nonatomic,assign) BOOL shoppingCartStatus;
@end
