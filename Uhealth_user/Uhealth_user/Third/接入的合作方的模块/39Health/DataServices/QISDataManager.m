//
//  QISDataManager.m
//  QISDiseaseDemo
//
//  Created by xiexianyu on 5/28/18.
//  Copyright © 2018 39. All rights reserved.
//

#import "QISDataManager.h"
#import "NSString+QISURLEncoding.h"
#import "Reachability.h"
// for MD5
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

// error tip
NSString * const kQISNetNotReachableError = @"网络无法连接或未允许应用使用数据";
NSString * const kQISDataJsonError = @"数据出现异常";

// for open api, disease module
NSString * const kQISOpenAPIURLString = @"https://interface.39.net/";
NSString * const kQISOpenAppKey = @"yyk";
NSString * const kQISOpenSign = @"A82CC16938C08ED6BCE9D3B5512C7393";
// for yyk api
NSString * const kQISUUID = @"iosv2";


@implementation QISDataManager

#pragma mark - API requests

+ (nullable NSURLRequest*)requestSymptomsByBodyWithParameters:(NSDictionary*)parameters
{
    NSString *link = [QISDataManager openAPIURLString:@"openapi/getsymptomsbybody"];
    return [QISDataManager buildRequestWithMethod:@"GET"
                                          urlLink:link
                                       parameters:parameters
                                        isOpenAPI:YES];
}

+ (nullable NSURLRequest*)requestDiagnosisResultWithParameters:(NSDictionary*)parameters
{
    NSString *link = [QISDataManager openAPIURLString:@"openapi/getdiagnosisresult"];
    return [QISDataManager buildRequestWithMethod:@"GET"
                                          urlLink:link
                                       parameters:parameters
                                        isOpenAPI:YES];
}

+ (nullable NSURLRequest*)requestDiseaseDetailWithParameters:(NSDictionary*)parameters
{
    NSString *link = [QISDataManager openAPIURLString:@"apiyyk/v1/app/disease/detail.jsonp"];
    return [QISDataManager buildRequestWithMethod:@"GET"
                                          urlLink:link
                                       parameters:parameters
                                        isOpenAPI:NO];
}

+ (nullable NSURLRequest*)requestDiseaseGuideWithParameters:(NSDictionary*)parameters
{
    NSString *link = [QISDataManager openAPIURLString:@"apiyyk/v1/app/disease/guide.jsonp"];
    return [QISDataManager buildRequestWithMethod:@"GET"
                                          urlLink:link
                                       parameters:parameters
                                        isOpenAPI:NO];
}

#pragma mark - build request
// GET method
+ (nullable NSURLRequest*)buildRequestWithMethod:(NSString *)method
                                         urlLink:(NSString*)urlLink
                                      parameters:(NSDictionary*)parameters
                                       isOpenAPI:(BOOL)isOpenAPI
{
    NSString *methodString = [method uppercaseString];
    NSString *encodedURLString = [urlLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *apiURL = [NSURL URLWithString:encodedURLString];
    if (apiURL == nil) {
        return nil;
    }
    
    NSDictionary *paramInfo = nil;
    if (isOpenAPI) {
        paramInfo = [QISDataManager openAPIEncryptWithParam:parameters];
    }
    else {
        paramInfo = [QISDataManager addSignStringParam:parameters];
    }
    
    
    NSString *paramValue = nil;
    if ([methodString isEqualToString:@"GET"]) {
        NSMutableString *queryString = [[NSMutableString alloc] init];
        
        NSArray *keys = [paramInfo allKeys];
        NSArray *sortedKeys = [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        
        for (NSInteger index = 0; index < sortedKeys.count; index++) {
            NSString *key = [sortedKeys objectAtIndex:index];
            paramValue = paramInfo[key];
            if ([paramValue isKindOfClass:[NSString class]]) {
                // encode
                if (isOpenAPI) {
                    paramValue = [paramValue urlEncodedStringUsingEncoding:kCFStringEncodingUTF8];
                }
                else {
                    // GB2312
                    paramValue = [paramValue urlEncodedStringUsingEncoding:kCFStringEncodingGB_18030_2000];
                    // for space encode encode to '+' in java API
                    paramValue = [paramValue stringByReplacingOccurrencesOfString:@"%20" withString:@"+"];
                }
            }
            
            if (queryString.length > 0) {
                [queryString appendFormat:@"&%@=%@", key, paramValue];
            }
            else {
                [queryString appendFormat:@"%@=%@", key, paramValue];
            }
        }//for
        
        NSString *queryLink = [encodedURLString stringByAppendingFormat:@"?%@", queryString];
        NSURL *url = [NSURL URLWithString:queryLink];
        
        NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        mutableRequest.HTTPMethod = methodString;
        mutableRequest.timeoutInterval = 15.0;
        
        [mutableRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        return mutableRequest;
    }
    else {
        return nil;
    }
    
    return nil;
}

+ (BOOL)checkNetworkStatus {
    // check network status
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        // network error
        return NO;
    }
    return YES;
}

// network error tip
+ (NSString*)netTipWithError:(NSError*)error
{
    NSString *errorText = @"网络出现异常";
    if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorNotConnectedToInternet) {
        errorText = [error.localizedDescription stringByRemovingPercentEncoding];
        if (errorText.length == 0) { // nil or @""
            errorText = kQISNetNotReachableError;
        }
        else if (errorText.length > 32) {
            // too more text
            errorText = kQISNetNotReachableError;
        }
    }
    else if (error.code == NSURLErrorTimedOut) {
        errorText = @"请求超时";
    }
    
    return errorText;
}

// status error tip
+ (nullable NSString*)statusErrorTipWithResponseInfo:(NSDictionary*)info
{
    if (![info isKindOfClass:[NSDictionary class]]) {
        NSString *tipString = @"数据出现异常";
        if ([info isKindOfClass:[NSError class]]) {
            tipString = @"服务器接口出现异常";
        }
        return tipString;
    }
    
    // status
    id statusValue = [info valueForKey:@"status"];
    if (statusValue == nil) {
        // response->status
        NSDictionary *responseInfo = [info valueForKey:@"response"];
        if ([responseInfo isKindOfClass:[NSDictionary class]]) {
            statusValue = [responseInfo valueForKey:@"status"];
        }
    }
    
    if ([statusValue isKindOfClass:[NSString class]]) {
        NSString *statusString = [statusValue uppercaseString];
        if ([statusString isEqualToString:@"OK"]) {
            // Good data
            return nil;
        }
    }
    else if ([statusValue isKindOfClass:[NSNumber class]]) {
        NSInteger status = [statusValue integerValue];
        if (status == 0) {
            // Good data
            return nil;
        }
    }
    
    // Bad data
    NSString *tipString = @"数据出现异常";
    return tipString;
}

#pragma mark - params sign

+ (NSString*)openAPIURLString:(NSString*)api
{
    return [NSString stringWithFormat:@"%@%@", kQISOpenAPIURLString, api];
}

+ (NSDictionary *)openAPIEncryptWithParam:(NSDictionary *)param
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:param];
    
    [dict setObject:kQISOpenAppKey forKey:@"app_key"];
    
    NSArray *keys = [dict allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    NSMutableString *signedString = [[NSMutableString alloc] init];
    for (int i = 0; i < sortedKeys.count; i++) {
        NSString *keyName = [sortedKeys objectAtIndex:i];
        NSString *lowerKey = [keyName lowercaseString];
        id keyValue = [dict objectForKey:keyName];
        [signedString appendFormat:@"%@=%@,", lowerKey, keyValue];
    }
    
    [signedString appendFormat:@"%@", [kQISOpenSign lowercaseString]];
    //DebugLog(@"signedString : %@",signedString);
    
    [dict setObject:[QISDataManager md5WithBaseString:signedString] forKey:@"sign"];
    
    return dict;
}

+ (NSDictionary *)addSignStringParam:(NSDictionary *)param
{
    NSMutableDictionary *dict = nil;
    if (param == nil) {
        dict = [[NSMutableDictionary alloc] init];
    }else {
        dict = [[NSMutableDictionary alloc] initWithDictionary:param];
    }
    
    [dict setObject:kQISUUID forKey:@"uuid"];
        
    return dict;
}

// util helper
+ (nullable NSString *)md5WithBaseString:(NSString*)baseString
{
    if(baseString == nil || [baseString length] == 0) {
        return nil;
    }
    
    const char *value = [baseString UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}


@end
