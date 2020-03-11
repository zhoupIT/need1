//
//  ZPFeatureItemNumCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/11/2.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPFeatureItemNumCell.h"
#import "PPNumberButton.h"
@interface ZPFeatureItemNumCell()
/* 属性标题 */
@property (strong , nonatomic)UILabel *headerLabel;
@property (nonatomic,strong) PPNumberButton *numButton;
@end
@implementation ZPFeatureItemNumCell
#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = RGB(244, 244, 244);
     _numButton = [PPNumberButton new];
    _headerLabel = [UILabel new];
    [self.contentView addSubview:_numButton];
    [self.contentView addSubview:_headerLabel];
    _headerLabel.font  = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(14)];
    _headerLabel.textColor  = ZPMyOrderDetailFontColor;
    _headerLabel.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
    _headerLabel.text = @"数量";
    
    _numButton.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .heightIs(25)
    .widthIs(ZPWidth(96))
    .topSpaceToView(_headerLabel, 15);
    // 开启抖动动画
    _numButton.shakeAnimation = NO;
    // 设置最小值
    _numButton.minValue = 1;
    // 设置输入框中的字体大小
    _numButton.inputFieldFont = 13;
    _numButton.increaseTitle = @"＋";
    _numButton.decreaseTitle = @"－";
    _numButton.currentNumber = 1;
    _numButton.borderColor = RGB(204, 204, 204);
    _numButton.longPressSpaceTime = CGFLOAT_MAX;
    __weak typeof(self) weakSelf = self;
    _numButton.resultBlock = ^(PPNumberButton *ppBtn, CGFloat number, BOOL increaseStatus){
        NSLog(@"%f %d",number,increaseStatus);
        if (weakSelf.refreshPriceBlock) {
            weakSelf.refreshPriceBlock(number);
        }
        
    };
}
@end
