//
//  ZPIndexCenterCell.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPIndexCenterCell : UITableViewCell
@property (nonatomic,copy) void (^didClickBlock) (void);
@end

NS_ASSUME_NONNULL_END
