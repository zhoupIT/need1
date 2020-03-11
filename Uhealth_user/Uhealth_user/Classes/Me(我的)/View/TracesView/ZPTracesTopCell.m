//
//  ZPTracesTopCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/8/21.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPTracesTopCell.h"
#import "YYLabel.h"
#import "ZPTracesModel.h"
@interface ZPTracesTopCell()
@property (nonatomic,strong) UIImageView *IconView;
@property (nonatomic,strong) UILabel *acceptStationLabel;
@property (nonatomic,strong) UILabel *acceptTimeLabel;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UIView *topline;
@property (nonatomic,strong) UIView *bottomline;
@end
@implementation ZPTracesTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *contentView = self.contentView;
    self.IconView = [UIImageView new];
    self.acceptStationLabel = [UILabel new];
    self.acceptTimeLabel = [UILabel new];
    [contentView sd_addSubviews:@[self.IconView,self.acceptStationLabel,self.acceptTimeLabel]];
    
    self.IconView.sd_layout
    .widthIs(17)
    .heightIs(17)
    .leftSpaceToView(contentView, 16)
    .topSpaceToView(contentView, 15);
    self.IconView.image = [UIImage imageNamed:@"trace_deal_icon"];
    
    self.acceptStationLabel.textColor = ZPMyOrderDeleteBorderColor;
    self.acceptStationLabel.font = [UIFont fontWithName:ZPPFSCRegular size:13];
    self.acceptStationLabel.sd_layout
    .leftSpaceToView(self.IconView, 16)
    .topEqualToView(self.IconView)
    .rightSpaceToView(contentView, 27)
    .autoHeightRatio(0);
    
    self.acceptTimeLabel.textColor = ZPMyOrderDeleteBorderColor;
    self.acceptTimeLabel.font = [UIFont fontWithName:ZPPFSCRegular size:13];
    self.acceptTimeLabel.sd_layout
    .topSpaceToView(self.acceptStationLabel, 10)
    .leftSpaceToView(self.IconView, 16)
    .rightSpaceToView(contentView, 27)
    .autoHeightRatio(0);
    
    self.line = [UIView new];
    self.line.backgroundColor = RGB(244, 244, 244);
    [contentView addSubview:self.line];
    self.line.sd_layout
    .leftSpaceToView(contentView, 48)
    .rightSpaceToView(contentView, 15)
    .heightIs(1)
    .topSpaceToView(self.acceptTimeLabel, 15);
    
    self.topline = [UIView new];
    self.bottomline = [UIView new];
    [contentView sd_addSubviews:@[self.topline,self.bottomline]];
    self.topline.backgroundColor = RGB(244, 244, 244);
    self.topline.sd_layout
    .topSpaceToView(contentView, 0)
    .centerXEqualToView(self.IconView)
    .widthIs(1)
    .bottomSpaceToView(self.IconView, 0);
    
    self.bottomline.backgroundColor = RGB(244, 244, 244);
    self.bottomline.sd_layout
    .topSpaceToView(self.IconView, 0)
    .centerXEqualToView(self.IconView)
    .widthIs(1)
    .bottomSpaceToView(contentView, 0);
    
    
    [self setupAutoHeightWithBottomView:self.line bottomMargin:15];
}

- (void)setModel:(ZPTracesModel *)model {
    _model = model;
    self.acceptStationLabel.text = model.acceptStation;
    self.acceptTimeLabel.text = model.acceptTime;
    
    switch (model.cellstyle) {
        case 0:
        {
           //普通
            self.IconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"trace_%@_icon",model.goodsStatus.name.lowercaseString]];
            self.topline.hidden = NO;
            self.bottomline.hidden = NO;
            self.line.hidden = NO;
        }
            break;
        case 1:
        {
            //第一个
            self.IconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"trace_%@_icon_sel",model.goodsStatus.name.lowercaseString]];
            self.topline.hidden = YES;
            self.bottomline.hidden = NO;
            self.line.hidden = NO;
        }
            break;
        case 2:
        {
            //最后一个
            self.IconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"trace_%@_icon",model.goodsStatus.name.lowercaseString]];
            self.topline.hidden = NO;
            self.bottomline.hidden = YES;
            self.line.hidden = YES;
        }
            break;
        default:
            break;
    }
    if ([model.goodsStatus.name isEqualToString:@"SIGN"]) {
        self.acceptStationLabel.textColor = ZPMyOrderDetailFontColor;
        self.acceptTimeLabel.textColor = ZPMyOrderDetailFontColor;
    } else {
        self.acceptStationLabel.textColor = ZPMyOrderDeleteBorderColor;
        self.acceptTimeLabel.textColor = ZPMyOrderDeleteBorderColor;
    }
   
}

@end
