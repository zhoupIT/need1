//
//  ZPTracesHeaderCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/8/21.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPTracesHeaderCell.h"

@interface ZPTracesHeaderCell()
@property (nonatomic,strong) UILabel *shipperNameLabel;
@property (nonatomic,strong) UILabel *logisticCodeLabel;
@property (nonatomic,strong) UIImageView *bottomIconView;
@end
@implementation ZPTracesHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.shipperNameLabel = [UILabel new];
    self.logisticCodeLabel = [UILabel new];
    self.bottomIconView = [UIImageView new];
    UIView *contentView = self.contentView;
    [contentView sd_addSubviews:@[self.shipperNameLabel,self.logisticCodeLabel,self.bottomIconView]];
    
    self.shipperNameLabel.textColor = ZPMyOrderDetailFontColor;
    self.shipperNameLabel.font = [UIFont fontWithName:ZPPFSCRegular size:14];
    self.shipperNameLabel.sd_layout
    .topSpaceToView(contentView, 22)
    .leftSpaceToView(contentView, 16)
    .rightSpaceToView(contentView, 16)
    .autoHeightRatio(0);
    self.shipperNameLabel.text = @"配送方式:";
    
    self.logisticCodeLabel.textColor = ZPMyOrderDetailFontColor;
    self.logisticCodeLabel.font = [UIFont fontWithName:ZPPFSCRegular size:14];
    self.logisticCodeLabel.sd_layout
    .topSpaceToView(self.shipperNameLabel, 17)
    .leftSpaceToView(contentView, 16)
    .rightSpaceToView(contentView, 16)
    .autoHeightRatio(0);
    self.logisticCodeLabel.text = @"运单号:";
    
    self.bottomIconView.image = [UIImage imageNamed:@"prefer_locborder"];
    self.bottomIconView.sd_layout
    .topSpaceToView(self.logisticCodeLabel, 22)
    .heightIs(2)
    .leftSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 0);
    
    
    [self setupAutoHeightWithBottomView:self.bottomIconView bottomMargin:0];
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    if (dict[@"shipperName"] && ![dict[@"shipperName"] isKindOfClass:[NSNull class]]) {
        self.shipperNameLabel.text = [NSString stringWithFormat:@"配送方式:%@",dict[@"shipperName"]];
    }
    if (dict[@"logisticCode"] && ![dict[@"logisticCode"] isKindOfClass:[NSNull class]]) {
    self.logisticCodeLabel.text = [NSString stringWithFormat:@"运单号:%@",dict[@"logisticCode"]];
    }
}
@end
