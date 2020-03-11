//
//  ZPCommentsModel.h
//  ZPealth
//
//  Created by Biao Geng on 2018/4/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPCommentsModel : NSObject
@property (nonatomic,copy) NSString *avaUrl;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,strong) NSArray *urlArray;
@property (nonatomic,assign) int starNum;
@end
