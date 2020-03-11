//
//  ZPDrinkModel.h
//  ZPealth
//
//  Created by Biao Geng on 2018/6/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPDrinkModel : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) BOOL isSel;
@property (nonatomic,strong) NSMutableArray *smokeResultArray;
@property (nonatomic,strong) NSMutableArray *drinkResultArray;
@end
