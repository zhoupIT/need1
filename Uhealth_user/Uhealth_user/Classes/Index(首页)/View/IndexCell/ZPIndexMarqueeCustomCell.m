//
//  ZPIndexMarqueeCustomCell.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPIndexMarqueeCustomCell.h"
#import "ZPHealthDynamicModel.h"
@implementation ZPIndexMarqueeCustomCell
#pragma mark - 懒加载
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.layer.borderColor = [[UIColor redColor] CGColor];
        _imageView.layer.borderWidth = 0;
        _imageView.hidden = YES;
    }
    return _imageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"--";
        _titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(11)];
        _titleLabel.textColor = RGB_87_193_255;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.layer.borderWidth = 0.5;
        _titleLabel.layer.cornerRadius = 4;
        _titleLabel.backgroundColor = RGB_246_252_255;
        _titleLabel.layer.borderColor = RGB_87_193_255.CGColor;
        _titleLabel.layer.masksToBounds = YES;
    }
    return _titleLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.text = @"--";
        _contentLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(13)];
        _contentLabel.textColor = RGB_74_74_74;
    }
    return _contentLabel;
}

- (UIView *)circle {
    if (!_circle) {
        _circle = [UIView new];
//        _circle.backgroundColor =  RGB_87_193_255;
        _circle.layer.cornerRadius = 4;
        _circle.layer.masksToBounds = YES;
    }
    return _circle;
}
#pragma mark - 页面初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupViews];
    }
    return self;
}

#pragma mark - 添加子控件
- (void)setupViews {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.circle];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    
    self.imageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    self.circle.sd_layout
    .leftSpaceToView(self.contentView, 5)
    .heightIs(8)
    .widthIs(8)
    .centerYEqualToView(self.contentView);
    
    CAGradientLayer *gradientLayer0 = [[CAGradientLayer alloc] init];
    gradientLayer0.frame = self.circle.bounds;
    gradientLayer0.colors = @[
                              (id)[UIColor colorWithRed:255.0f/255.0f green:72.0f/255.0f blue:36.0f/255.0f alpha:1.0f].CGColor,
                              (id)[UIColor colorWithRed:255.0f/255.0f green:210.0f/255.0f blue:0.0f/255.0f alpha:1.0f].CGColor];
    gradientLayer0.locations = @[@0, @1];
    [gradientLayer0 setStartPoint:CGPointMake(1, 1)];
    [gradientLayer0 setEndPoint:CGPointMake(1, 0)];
    [self.circle.layer addSublayer:gradientLayer0];
    
    self.titleLabel.sd_layout
    .heightIs(ZPHeight(18))
    .widthIs(ZPWidth(38))
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 0);
    
    
    
    self.contentLabel.sd_layout
    .leftSpaceToView(@[self.titleLabel,self.circle], 5)
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, 5)
    .heightIs(ZPHeight(13));
}

- (void)setModel:(ZPHealthDynamicModel *)model {
    _model = model;
    if (!model.flag) {
        self.titleLabel.hidden = YES;
        self.titleLabel.sd_layout.widthIs(0);
    } else {
        self.titleLabel.hidden = NO;
        self.titleLabel.sd_layout.widthIs(ZPWidth(38));
        self.titleLabel.text = model.flag.text;
    }
    self.contentLabel.text = model.title;
}
@end
