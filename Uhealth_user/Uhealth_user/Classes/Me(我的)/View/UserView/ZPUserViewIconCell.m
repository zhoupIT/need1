//
//  ZPUserViewIconCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/3/20.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPUserViewIconCell.h"
#import "WZLBadgeImport.h"
@interface ZPUserViewIconCell()
@property (nonatomic, weak) UIImageView *iconImageView;

@property (nonatomic, weak) UILabel *iconTitleLabel;
@end

@implementation ZPUserViewIconCell
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
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UILabel *iconTitleLabel = [UILabel new];
    iconTitleLabel.font = [UIFont systemFontOfSize:13];
    iconTitleLabel.text = @"xxx";
    iconTitleLabel.textColor = RGB(153, 153, 153);
    iconTitleLabel.numberOfLines = 0;
//    iconTitleLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:iconTitleLabel];
    self.iconTitleLabel = iconTitleLabel;
    
    iconImageView.sd_layout
    .centerXEqualToView(self.contentView)
    .topSpaceToView(self.contentView, 12)
    .heightIs(27)
    .widthIs(27);
     [iconImageView showBadgeWithStyle:WBadgeStyleNumber value:10 animationType:WBadgeAnimTypeNone];
    
    iconTitleLabel.sd_layout
    .centerXEqualToView(self.contentView)
    .topSpaceToView(iconImageView,12)
    .heightIs(13)
    .widthIs(40);
}

- (void)setIconImageName:(NSString *)iconImageName {
    _iconImageName = iconImageName;
    
    [self.iconImageView setImage:[UIImage imageNamed:iconImageName]];
}

- (void)setIconTitle:(NSString *)iconTitle {
    _iconTitle = iconTitle;
    
    [self.iconTitleLabel setText:iconTitle];
}

- (void)setNum:(NSString *)num {
    _num = num;
     [self.iconImageView showBadgeWithStyle:WBadgeStyleNumber value:[num integerValue] animationType:WBadgeAnimTypeNone];
}
@end
