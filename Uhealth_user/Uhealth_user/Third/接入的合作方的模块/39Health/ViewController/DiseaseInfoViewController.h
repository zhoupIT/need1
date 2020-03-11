//
//  DiseaseInfoViewController.h
//  YYK
//
//  Created by xiexianyu on 12/14/16.
//  Copyright © 2016 39.net. All rights reserved.
//

#import "QISBaseListViewController.h"

@interface DiseaseInfoViewController : QISBaseListViewController

// v5.7, default NO.
// it need fetch detail info if from chat ask
@property (assign, nonatomic) BOOL isFromChatAsk;

// disease info
// v5.7 keys:ID_YYK, NAME_CN
// for disease name, v5.6 and before
@property (strong, nonatomic) NSDictionary *diseaseInfo;

@property (copy, nonatomic) NSArray *descTips;
@property (copy, nonatomic) NSString *desc;
// have guide section or not, default NO.
@property (assign, nonatomic) BOOL isGuide;
// keys: name; content.  v5.6 
@property (strong, nonatomic) NSDictionary *introInfo;
@property (strong, nonatomic) NSDictionary *symptomInfo;
@property (strong, nonatomic) NSDictionary *diffInfo;

// for next guide page
@property (nonatomic, strong) NSDictionary *detailInfo;
@property (nonatomic, assign, setter=setCollected:) BOOL didCollected;

@end
