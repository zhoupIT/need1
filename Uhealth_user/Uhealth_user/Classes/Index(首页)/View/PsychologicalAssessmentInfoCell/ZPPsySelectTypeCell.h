//
//  ZPPsySelectTypeCell.h
//  ZPealth
//
//  Created by Biao Geng on 2018/6/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPPsySelectTypeCell : UITableViewCell
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,copy) NSString *cellTitleStr;
@property (nonatomic,assign) BOOL isSel;

@property (nonatomic,copy) void (^updateSelBlock) (UIButton *btn);

@end
