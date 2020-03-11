//
//  QISConditionSwitchPrivate.h
//  YYK
//
//  Created by xiexianyu on 10/12/15.
//  Copyright © 2015 xiexianyu. All rights reserved.
//

#ifndef QISConditionSwitchPrivate_h
#define QISConditionSwitchPrivate_h

typedef NS_ENUM(NSUInteger, QISSearchCondition){
    QISPlaceCondition = 1,   // single choice, two level
    QISBookCondition,       // single, one
    QISFilterCondition,  // multi choice, two
    QISSortCondition,    // single, one
    QISDeptCondition,    // single, two
    QISDiseaseCondition,  // single, two
    QISTitleCondition  // single, one
};

// doctor service type
typedef NS_ENUM(NSUInteger, QISDoctorCondition){
    QISAllDoctor = 1,
    QISBookDoctor,  //yuyue
    QISConsultDoctor  //zixun
};


@protocol QISConditionSwitchViewDelegate <NSObject>

@optional
- (void)didChangeSearchCondition;
// for update tab titles
- (void)didSelectConditionWithTabInfo:(NSDictionary*)tabInfo;
// for page list
- (void)requestHospitalDataWithParamInfo:(NSDictionary *)info
                         completionBlock:(QISFetchDataCompletionBlock)finishFetchBlock;
// for special expert list at hospital
// if selected one dept then refetch all condition info.
- (void)willChangeAllConditionInfo;

@end


#endif /* QISConditionSwitchPrivate_h */
