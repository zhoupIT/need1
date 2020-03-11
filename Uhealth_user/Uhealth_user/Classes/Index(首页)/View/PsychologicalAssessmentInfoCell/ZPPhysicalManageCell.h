//
//  UHPhysicalManageCell.h
//  Uhealth
//
//  Created by Biao Geng on 2018/7/23.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPPhysicalManageCell : UITableViewCell
@property (nonatomic,copy) void (^startBlock) (void);
@property (nonatomic,strong) NSDictionary *dict;
@end
