//
//  ZPUserViewTopCell.h
//  ZPealth
//
//  Created by Biao Geng on 2018/3/20.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPUserViewTopCell : UICollectionViewCell
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, assign) BOOL isAccessoryHidden;
@end
