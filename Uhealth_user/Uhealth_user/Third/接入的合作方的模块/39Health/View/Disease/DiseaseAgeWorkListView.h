//
//  DiseaseAgeWorkListView.h
//  YYK
//
//  Created by xiexianyu on 4/23/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QISDiseaseListType){
    QISDiseaseListGender = 0,
    QISDiseaseListAge,
    QISDiseaseListWork
};

@protocol DiseaseAgeWorkListViewDelegate <NSObject>

@optional
- (void)didSelectGender:(NSDictionary*)genderInfo;
- (void)didSelectAge:(NSDictionary*)ageInfo;
- (void)didSelectWork:(NSDictionary*)workInfo;
- (void)didTapTransparentSpace; // will to hide self

@end

@interface DiseaseAgeWorkListView : UIView

@property (weak, nonatomic) id<DiseaseAgeWorkListViewDelegate> delegate;

// gender, age, work list
@property (assign, nonatomic) QISDiseaseListType listType; // default gender type

@property (assign, nonatomic, readonly) NSInteger genderSelectedIndex;
@property (assign, nonatomic, readonly) NSInteger ageSelectedIndex;
@property (assign, nonatomic, readonly) NSInteger workSelectedIndex;

- (void)configureWithGenderList:(NSArray*)genderInfos
                        AgeList:(NSArray*)ageInfos
                       workList:(NSArray*)workInfos
             defaultGenderIndex:(NSInteger)genderIndex
                defaultAgeIndex:(NSInteger)ageIndex
               defaultWorkIndex:(NSInteger)workIndex;

// for animate show
- (void)animateToShow;

@end
