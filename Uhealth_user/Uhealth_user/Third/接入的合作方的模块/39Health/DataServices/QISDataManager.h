//
//  QISDataManager.h
//  QISDiseaseDemo
//
//  Created by xiexianyu on 5/28/18.
//  Copyright © 2018 39. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QISDataManager : NSObject

// error tip
extern NSString * const kQISNetNotReachableError;
extern NSString * const kQISDataJsonError;

+ (nullable NSURLRequest*)requestSymptomsByBodyWithParameters:(NSDictionary*)parameters;
+ (nullable NSURLRequest*)requestDiagnosisResultWithParameters:(NSDictionary*)parameters;
+ (nullable NSURLRequest*)requestDiseaseDetailWithParameters:(NSDictionary*)parameters;
+ (nullable NSURLRequest*)requestDiseaseGuideWithParameters:(NSDictionary*)parameters;


+ (NSString*)openAPIURLString:(NSString*)api;

+ (BOOL)checkNetworkStatus;
+ (NSString*)netTipWithError:(NSError*)error; //network error tip
+ (nullable NSString*)statusErrorTipWithResponseInfo:(NSDictionary*)info; //status error tip

@end

NS_ASSUME_NONNULL_END
