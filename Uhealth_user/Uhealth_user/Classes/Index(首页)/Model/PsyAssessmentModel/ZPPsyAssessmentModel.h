//
//  ZPPsyAssessmentModel.h
//  Uhealth
//
//  Created by Biao Geng on 2018/6/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPPsyAssessmentModel : NSObject
@property (nonatomic,copy) NSString *companyCode;
@property (nonatomic,copy) NSString *vipUrlImg;
@property (nonatomic,copy) NSString *activatedAt;
@property (nonatomic,copy) NSString *beerPerDay;
@property (nonatomic,copy) NSString *birthday;
@property (nonatomic,copy) NSString *company;
@property (nonatomic,copy) NSString *customerId;
@property (nonatomic,copy) NSString *drinking;
@property (nonatomic,copy) NSString *expiresAt;
@property (nonatomic,copy) NSString *foreignLiquorPerDay;
@property (nonatomic,copy) NSString *gender;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,assign) BOOL infoFilled;
@property (nonatomic,copy) NSString *liquorPerDay;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) BOOL retired;
@property (nonatomic,copy) NSString *retiredAge;
@property (nonatomic,copy) NSString *smoking;
@property (nonatomic,copy) NSString *smokingPerDay;
@property (nonatomic,copy) NSString *smokingYears;
@property (nonatomic,copy) NSString *tel;
@property (nonatomic,assign) BOOL ticketDone;
@property (nonatomic,copy) NSString *ticketEntry;
@property (nonatomic,copy) NSString *ticketId;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *winePerDay;

@property (nonatomic,copy) NSString *department;
@property (nonatomic,copy) NSString *position;
@property (nonatomic,copy) NSString *workYears;
@property (nonatomic,copy) NSString *education;
@property (nonatomic,copy) NSString *marriage;
@property (nonatomic,copy) NSString *livingSituation;

@property (nonatomic,assign) BOOL isExpandSmoke;
@property (nonatomic,assign) BOOL isExpandDrink;
@property (nonatomic,assign) BOOL isExpandRetire;
@end
