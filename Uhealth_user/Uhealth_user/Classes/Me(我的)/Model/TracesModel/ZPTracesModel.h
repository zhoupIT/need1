//
//  ZPTracesModel.h
//  ZPealth
//
//  Created by Biao Geng on 2018/8/21.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CellStyle) {
    CellStyleCommon = 0,
    CellStyleFirst,
    CellStyleLast
};
@interface ZPTracesModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *logisiticsId;
@property (nonatomic,copy) NSString *acceptStation;
@property (nonatomic,copy) NSString *acceptTime;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,strong) ZPCommonEnumType *goodsStatus;
@property (nonatomic,assign) CellStyle cellstyle;
@end
