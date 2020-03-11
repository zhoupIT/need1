//
//  DiseaseMajorListView.h
//  YYK
//
//  Created by xiexianyu on 4/27/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "QISTwoMenuView.h"

@protocol DiseaseMajorListViewDelegate <NSObject>

@optional
- (void)didSelectOneBodyPart:(NSDictionary*)info;
- (void)didSelectOneMajorSymptom:(NSDictionary*)info;

@end


@interface DiseaseMajorListView : QISTwoMenuView

@property (nonatomic, assign) id<DiseaseMajorListViewDelegate> symptomDelegate;

@property (nonatomic, assign, setter=setFemale:) BOOL isFemale;
// age, work
@property (nonatomic, strong) NSDictionary *genderInfo;
@property (nonatomic, strong) NSDictionary *ageInfo;
@property (nonatomic, strong) NSDictionary *workInfo;

// first body
- (void)fetchFirstBodyMajorSymptoms;
// fetch by body name
- (void)fetchMajorSymptomsWithBodyName:(NSString*)bodyName;
// reset and update
- (void)clearMajorSymptomsAndNeedUpdate:(BOOL)isNeed;

@end
