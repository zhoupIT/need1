//
//  ZPUserViewBottomCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/3/20.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPUserViewBottomCell.h"
@interface ZPUserViewBottomCell()
@property (nonatomic, weak) UIImageView *iconImageView;

@property (nonatomic, weak) UILabel *iconTitleLabel;

@property (nonatomic, weak) UIImageView *accessoryImageView;

@property (nonatomic,strong) UILabel *rightTitleLabel;
@end

@implementation ZPUserViewBottomCell
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
    
    UIImageView *accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    [self.contentView addSubview:accessoryImageView];
    self.accessoryImageView = accessoryImageView;
    
    UILabel *iconTitleLabel = [UILabel new];
    iconTitleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(15)];
    iconTitleLabel.text = @"xxx";
    iconTitleLabel.textColor = ZPMyOrderDetailFontColor;
    iconTitleLabel.numberOfLines = 0;
//    iconTitleLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:iconTitleLabel];
    self.iconTitleLabel = iconTitleLabel;
    
    self.rightTitleLabel = [UILabel new];
    [self.contentView addSubview:self.rightTitleLabel];
    self.rightTitleLabel.textColor = [UIColor lightGrayColor];
    self.rightTitleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:13];
    self.rightTitleLabel.textAlignment = NSTextAlignmentRight; 
    
    accessoryImageView.sd_layout
    .rightSpaceToView(self.contentView, 16)
    .widthIs(18)
    .heightIs(18)
    .centerYEqualToView(self.contentView);
    
    iconImageView.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 12)
    .heightIs(20)
    .widthIs(20);
    
    iconTitleLabel.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(iconImageView,18)
    .heightIs(15)
    .widthIs(60);
    [iconTitleLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    self.rightTitleLabel.sd_layout
    .rightSpaceToView(accessoryImageView, 5)
    .centerYEqualToView(self.contentView)
    .heightIs(13)
    .leftSpaceToView(iconTitleLabel, 5);
}

- (void)setIconImageName:(NSString *)iconImageName {
    _iconImageName = iconImageName;
    
    [self.iconImageView setImage:[UIImage imageNamed:iconImageName]];
}

- (void)setIconTitle:(NSString *)iconTitle {
    _iconTitle = iconTitle;
    
    [self.iconTitleLabel setText:iconTitle];
}

- (void)setRightTitle:(NSString *)rightTitle {
    _rightTitle = rightTitle;
    [self.rightTitleLabel setText:rightTitle];
}
@end
