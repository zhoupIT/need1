//
//  ZPCheckOutHeaderView.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPCheckOutHeaderView.h"
@interface ZPCheckOutHeaderView()
/** 位置 */
@property (nonatomic , strong) UIImageView *position;
/** 收货人 */
@property (nonatomic , strong) UILabel *receiver;
/** 向右箭头 */
@property (nonatomic , strong) UIImageView *arrow;
/** 电话号码 */
@property (nonatomic , strong) UILabel *phoneNum;
/** 地址 */
@property (nonatomic , strong) UILabel *address;
@end
@implementation ZPCheckOutHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupUI];
     
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.position];
    [self addSubview:self.arrow];
    [self addSubview:self.receiver];
    [self addSubview:self.phoneNum];
    [self addSubview:self.address];
}

- (UILabel *)address {
    if (_address == nil) {
        _address = [[UILabel alloc]init];
        _address.text = @"地址: 开始计算价钱开始计算价钱开始计算价钱开始计算价钱";
        _address.numberOfLines = 0;
        _address.textColor = [UIColor lightGrayColor];
        _address.font = [UIFont systemFontOfSize:14];
        
    }
    return _address;
}
- (UILabel *)phoneNum {
    if (_phoneNum == nil) {
        _phoneNum = [[UILabel alloc]init];
        _phoneNum.text = @"18288888888";
        _phoneNum.textColor = [UIColor lightGrayColor];
        _phoneNum.font = [UIFont systemFontOfSize:14];
        
        
    }
    return _phoneNum;
}
- (UIImageView *)arrow {
    if (_arrow == nil) {
        _arrow = [[UIImageView alloc]init];
        _arrow.image = [UIImage imageNamed:@"detail_arrow"];
    }
    return _arrow;
}
- (UILabel *)receiver {
    if (_receiver == nil) {
        _receiver = [[UILabel alloc]init];
        _receiver.text = @"收货人";
        _receiver.textColor = [UIColor lightGrayColor];
        _receiver.font = [UIFont systemFontOfSize:14];
    }
    return _receiver;
}
- (UIImageView *)position {
    if (_position == nil) {
        _position = [[UIImageView alloc]init];
        _position.image = [UIImage imageNamed:@"Detail_position"];
    }
    return _position;
}

@end
