//
//  ZPSettleView.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/2.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPSettleView.h"

@interface ZPSettleView()
@property (strong, nonatomic) IBOutlet UIButton *payButton;

@end

@implementation ZPSettleView

+ (instancetype)addSettleView {
    NSArray* nibView = [[NSBundle mainBundle] loadNibNamed:@"ZPSettleView" owner:nil options:nil];
    return [nibView firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (IS_IPHONE5) {
        self.payButton.sd_layout.widthIs(80)
        .rightSpaceToView(self, 0);
        self.priceLabel.sd_layout.rightSpaceToView(self.payButton, 10);
        [self.priceLabel setSingleLineAutoResizeWithMaxWidth:200];
        self.tiplabel.sd_layout.rightSpaceToView(self.priceLabel, 10)
        .widthIs(29);
    }
}

- (void)setPriceLabel:(UILabel *)priceLabel {
    _priceLabel = priceLabel;
    
}

- (IBAction)selectAllEvent:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.selectAllBlock) {
        self.selectAllBlock(sender);
    }
}
- (IBAction)settleEvent:(UIButton *)sender {
    if (self.settleBlock) {
        self.settleBlock(sender);
    }
}


@end
