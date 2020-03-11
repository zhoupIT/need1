//
//  UHCheckOutModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPCheckOutModel : NSObject

@property (nonatomic , copy) NSString *title;
@property (nonatomic , copy) NSString *details;
@property (nonatomic , assign) NSInteger cellHeight;
@property (nonatomic , assign) ZPOrderDetailsCellType cellType;
+ (NSMutableArray *)creatDetailsData;
@end
