//
//  ZPSelectOrderParamController.h
//  ZPealth
//
//  Created by Biao Geng on 2018/10/23.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZPCommodity,ZPCommodityItemModel;
@interface ZPSelectOrderParamController : UIViewController
/* 属性数组 */
@property (nonatomic,strong) NSArray *featureAttr;
/* 选中的属性数组 */
@property (nonatomic,strong) NSMutableArray *selfeatureAttr;
@property (nonatomic,strong) ZPCommodity *commodity;
/**
 自定义init方法
 
 @param cHeight 要弹出的控制器的高度(设置为0或负数则默认为500)
 @param dimAlpha 顶部留空处黑色蒙版的透明度 0-透明 1-不透明(全黑)(设置为负数则默认为0.5,>1则默认为1)
 @return 对象实例
 */
- (instancetype)initWithCHeight:(CGFloat)cHeight andDimAlpha:(CGFloat)dimAlpha;

/* 选中的属性模型 */
@property (nonatomic,strong) ZPCommodityItemModel *selCommodityItemModel;
/* 选择的商品属性文字 */
@property (nonatomic,copy) NSString *featurestr;
/* 用来存储用户的勾选项 */
@property (nonatomic,strong) NSMutableDictionary *choosedOptionMap;
/* 进入购物车回调 */
@property (nonatomic,copy) void (^cartBlock) (void);
/* 购买回调 */
@property (nonatomic,copy) void (^buyActionBlock) (NSArray *array,ZPCommodityItemModel *selModel);
/* 加入购物车回调 */
@property (nonatomic,copy) void (^addToCartActionBlock) (ZPCommodityItemModel *selModel);
/* 选择属性的回调 */
@property (nonatomic,copy) void (^selectAttachBlock) (ZPCommodityItemModel *selModel,NSString *selStr,NSMutableDictionary *choosedOptionMap);
@end

NS_ASSUME_NONNULL_END
