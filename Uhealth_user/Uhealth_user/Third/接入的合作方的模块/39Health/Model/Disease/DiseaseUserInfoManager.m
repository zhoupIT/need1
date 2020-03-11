//
//  DiseaseUserInfoManager.m
//  YYK
//
//  Created by xiexianyu on 5/15/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "DiseaseUserInfoManager.h"

@implementation DiseaseUserInfoManager

#pragma mark - access methods

- (void)setFemale:(BOOL)isFemale
{
    // save
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isFemale forKey:@"DiseaseGender"];
    [userDefaults synchronize];
}

- (BOOL)isFemale
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:@"DiseaseGender"];
}

- (void)setAgeInfo:(NSDictionary *)ageInfo
{
    // save
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:ageInfo forKey:@"DiseaseAge"];
    [userDefaults synchronize];
}

- (NSDictionary*)ageInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:@"DiseaseAge"];
}

- (void)setWorkInfo:(NSDictionary *)workInfo
{
    // save
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:workInfo forKey:@"DiseaseWork"];
    [userDefaults synchronize];
}

- (NSDictionary*)workInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:@"DiseaseWork"];
}


@end
