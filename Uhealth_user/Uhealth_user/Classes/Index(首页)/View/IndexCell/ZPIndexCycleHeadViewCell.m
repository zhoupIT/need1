//
//  ZPIndexCycleHeadViewCell.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPIndexCycleHeadViewCell.h"
#import "SDCycleScrollView.h"
@interface ZPIndexCycleHeadViewCell()<SDCycleScrollViewDelegate>
{
    SDCycleScrollView *_imgCycleView;//图片轮播
}
@end
@implementation ZPIndexCycleHeadViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *contentView = self.contentView;
    _imgCycleView = [SDCycleScrollView new];
 
    [contentView sd_addSubviews:@[_imgCycleView]];
    _imgCycleView.sd_layout
    .topSpaceToView(contentView, 0)
    .leftSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 0)
    .heightIs(ZPHeight(180));
    _imgCycleView.delegate = self;
    _imgCycleView.autoScrollTimeInterval = 3;
}

- (void)setData:(NSArray *)data {
    _data = data;
    _imgCycleView.imageURLStringsGroup = data;
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.bannerImgClickBlock) {
        self.bannerImgClickBlock(index);
    }
}
@end
