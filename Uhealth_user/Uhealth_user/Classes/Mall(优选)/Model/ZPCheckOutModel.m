//
//  ZPCheckOutModel.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPCheckOutModel.h"

@implementation ZPCheckOutModel
+ (NSMutableArray *)creatDetailsData {
    NSArray *titleArray = @[@"商店名称",@"11",@"购买数量",@"配送方式",@"配送时间",@"运费险",@"买家留言"];
    NSArray *detailsArray = @[@"111",@"111",@"",@"快递免费",@"周五送达",@"退货前可赔",@""];
    NSArray *cellTypeArray = @[
                               @(ZPOrderDetailsCellType_shop),
                               /// 商品
                               @(ZPOrderDetailsCellType_goods),
                               /// 输入数量
                               @(ZPOrderDetailsCellType_inputNums),
                               /// 配送方式
                               @(ZPOrderDetailsCellType_delivery),
                               /// 配送时间
                               @(ZPOrderDetailsCellType_time),
                               /// 运费险
                               @(ZPOrderDetailsCellType_insurance),
                               /// 留言
                               @(ZPOrderDetailsCellType_message)];
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger index = 0; index < 7; index++) {
        
        ZPCheckOutModel *model = [[ZPCheckOutModel alloc] init];
        model.title = titleArray[index];
        model.details = detailsArray[index];
        NSNumber *typeNum = cellTypeArray[index];
        model.cellType = (ZPOrderDetailsCellType)typeNum.integerValue;
        if (model.cellType == ZPOrderDetailsCellType_goods) {
            model.cellHeight = 90;
        } else {
            model.cellHeight = 40;
        }
        [array addObject:model];
    }
    return array;
}
@end
