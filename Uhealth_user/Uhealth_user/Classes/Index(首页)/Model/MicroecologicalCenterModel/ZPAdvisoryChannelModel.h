//
//  ZPAdvisoryChannel.h
//  ZPealth
//
//  Created by Biao Geng on 2018/8/10.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPAdvisoryChannelModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *imgUrl;
@property (nonatomic,strong) ZPCommonEnumType *channelStatus;
@property (nonatomic,strong) ZPCommonEnumType *channelType;
@end
