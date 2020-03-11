//
//  ZPHealthNewsModel.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPHealthNewsModel : NSObject
@property (nonatomic,copy) NSString *informationId;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) ZPCommonEnumType *label;
@property (nonatomic,strong) NSArray *titleImgList;
@property (nonatomic,copy) NSString *author;
@property (nonatomic,copy) NSString *introduction;
@property (nonatomic,copy) NSString *mainBody;
@property (nonatomic,copy) NSString *mainBodyUrl;
@property (nonatomic,copy) NSString *pageviews;

@property (nonatomic,copy) NSString *commentCount;
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString *toatalCommentsCount;
@end

NS_ASSUME_NONNULL_END
