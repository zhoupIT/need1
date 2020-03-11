//
//  singleton.h
//  Uhealth
//
//  Created by Biao Geng on 2018/3/28.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#define ZPSingletonH(name) + (instancetype)shared##name;

#if __has_feature(objc_arc)

#define ZPSingletonM(name) \
static id _instance; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
\
+ (instancetype)shared##name { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
- (id)copyWithZone:(NSZone *)zone { \
return _instance; \
}

#else

#define ZPSingletonM(name) \
static id _instance; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
\
+ (instancetype)shared##name { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
\
- (id)copyWithZone:(NSZone *)zone { \
return _instance; \
} \
\
- (oneway void)release {} \
- (instancetype)retain { return _instance;} \
- (NSUInteger)retainCount { return 1;} \
- (instancetype)autorelease { return _instance;}


#endif

