//
//  ZPHeaderView.m
//  ZPealth
//
//  Created by Biao Geng on 2018/8/21.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPHeaderView.h"

@interface ZPHeaderView()
@property (nonatomic,strong) UILabel *shipperNameLabel;
@property (nonatomic,strong) UILabel *logisticCodeLabel;
@property (nonatomic,strong) UIImageView *bottomIconView;
@end
@implementation ZPHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.shipperNameLabel = [UILabel new];
    self.logisticCodeLabel = [UILabel new];
    self.bottomIconView = [UIImageView new];
    [self sd_addSubviews:@[self.shipperNameLabel,self.logisticCodeLabel,self.bottomIconView]];
    
    self.shipperNameLabel.sd_layout
    .topSpaceToView(self, 22)
    .leftSpaceToView(self, 16)
    .rightSpaceToView(self, 16);
    
}
@end
