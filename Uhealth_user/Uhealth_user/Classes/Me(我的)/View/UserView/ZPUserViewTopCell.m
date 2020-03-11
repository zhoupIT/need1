//
//  ZPUserViewTopCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/3/20.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPUserViewTopCell.h"

@interface ZPUserViewTopCell()
@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *subTitleLabel;

@property (nonatomic, weak) UIImageView *accessoryImageView;
@end
@implementation ZPUserViewTopCell
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
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"xxx";
    titleLabel.textColor = [UIColor darkTextColor];
     titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *subTitleLabel = [UILabel  new];
    subTitleLabel.font = [UIFont systemFontOfSize:13];
    subTitleLabel.text = @"xxx";
     subTitleLabel.adjustsFontSizeToFitWidth = YES;
    subTitleLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:subTitleLabel];
    self.subTitleLabel = subTitleLabel;
    
    UIImageView *accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    [self.contentView addSubview:accessoryImageView];
    self.accessoryImageView = accessoryImageView;
    
    titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 20)
    .centerYEqualToView(self.contentView)
    .widthIs(59)
    .heightIs(15);
    
    accessoryImageView.sd_layout
   .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, 16)
    .widthIs(18)
    .heightIs(18);
    
   subTitleLabel.sd_layout
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, 32)
    .heightIs(13)
    .widthIs(71);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    
    self.subTitleLabel.text = subTitle;
}

- (void)setIsAccessoryHidden:(BOOL)isAccessoryHidden {
    _isAccessoryHidden = isAccessoryHidden;
    
    if (isAccessoryHidden) {
        self.accessoryImageView.hidden = true;
    } else {
        self.accessoryImageView.hidden = false;
    }
}

@end
