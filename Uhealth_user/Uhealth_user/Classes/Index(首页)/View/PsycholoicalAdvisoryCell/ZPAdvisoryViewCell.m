//
//  ZPAdvisoryViewCell.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPAdvisoryViewCell.h"

@interface ZPAdvisoryViewCell()
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;
@end
@implementation ZPAdvisoryViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //添加自己需要个子视图控件
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.backgroundColor = [UIColor whiteColor];
    UIView *contentView = self.contentView;
    self.iconView = [UIImageView new];
    self.titleLabel = [UILabel new];
    self.subTitleLabel = [UILabel new];
    [contentView sd_addSubviews:@[self.iconView,self.titleLabel,self.subTitleLabel]];
    
    self.titleLabel.sd_layout
    .topSpaceToView(contentView, 20)
    .leftSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 0)
    .heightIs(14);
    self.titleLabel.font = [UIFont fontWithName:ZPPFSCMedium size:14];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = RGB_74_74_74;
    
    self.subTitleLabel.sd_layout
    .topSpaceToView(self.titleLabel, 13)
    .leftSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 0)
    .heightIs(13);
    self.subTitleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:13];
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subTitleLabel.textColor = RGB(102, 102, 102);
    
    self.iconView.sd_layout
    .centerXEqualToView(contentView)
    .topSpaceToView(self.subTitleLabel, 2)
    .widthIs(ZPHeight(104))
    .autoHeightRatio(1);
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.clipsToBounds = YES;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    self.titleLabel.text = dict[@"title"];
    self.subTitleLabel.text = dict[@"subTitle"];
    self.iconView.image = [UIImage imageNamed:dict[@"iconName"]];
}
@end
