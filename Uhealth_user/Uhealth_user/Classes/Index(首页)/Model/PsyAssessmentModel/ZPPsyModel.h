//
//  ZPPsyModel.h
//  ZPealth
//
//  Created by Biao Geng on 2018/6/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM (NSInteger,ZPGenderType) {
    ZPGenderTypeNone,
    ZPGenderTypeMale,
    ZPGenderTypeFeMale
};
typedef NS_ENUM (NSInteger,ZPRetiredType) {
    ZPRetiredTypeNone,
    ZPRetiredTypeYes,
    ZPRetiredTypeNo
};
@interface ZPPsyModel : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *birth;
@property (nonatomic,copy) NSString *companyName;

@property (nonatomic,assign) ZPGenderType genderType;
@property (nonatomic,assign) ZPRetiredType retiredType;

@property (nonatomic,assign) BOOL isExpandSmoke;
@property (nonatomic,assign) BOOL isExpandDrink;
@property (nonatomic,assign) BOOL isExpandRetire;
@end
