//
//  ZPLivingBroadcastImgCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/9/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPLivingBroadcastImgCell.h"
#import "ZPlectureIntroductionImg.h"
@interface ZPLivingBroadcastImgCell()
@property (nonatomic,strong) UIImageView *iconView;
@end
@implementation ZPLivingBroadcastImgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.iconView = [UIImageView new];
    self.iconView.clipsToBounds = YES;
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.iconView];
    self.iconView.sd_layout
    .topSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 5);
    [self setupAutoHeightWithBottomView:self.iconView bottomMargin:0];
}

- (void)setModel:(ZPlectureIntroductionImg *)model {
    _model = model;
    if (model.width < (kSCREEN_WIDTH-20)) {
        self.iconView.sd_layout
        .centerXEqualToView(self.contentView)
        .widthIs(model.width);
    } else {
        self.iconView.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0);
    }
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.url]];
}
@end
