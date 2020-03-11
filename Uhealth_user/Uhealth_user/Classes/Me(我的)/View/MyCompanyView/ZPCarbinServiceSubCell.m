//
//  ZPCarbinServiceSubCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/9/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPCarbinServiceSubCell.h"
#import "ZPCabinServiceModel.h"
@interface ZPCarbinServiceSubCell()
@property (nonatomic,strong) UIImageView *iconView;
@end
@implementation ZPCarbinServiceSubCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.iconView = [[UIImageView alloc] init];
    self.iconView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.iconView];
    self.iconView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = 4;
}

- (void)setModel:(ZPCabinServiceModel *)model {
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.serviceImg] placeholderImage:[UIImage imageNamed:@"placeholder_cart"]];
}
@end
