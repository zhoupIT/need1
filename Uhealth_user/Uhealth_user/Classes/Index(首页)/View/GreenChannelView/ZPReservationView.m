//
//  ZPReservationView.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPReservationView.h"
/* view */
#import "ZPButton.h"
/* 模型 */
#import "ZPPriceModel.h"
#import "ZPPatientListModel.h"
/* 三方 */
#import "YYText.h"
@interface ZPReservationView()
{
    UIButton   *_addPerButton;
    UIView *_patientView;
    UILabel *_patientNameLabel;
    UILabel *_patientPhoneLabel;
    UILabel *_patientTypeLabel;
    UILabel *_patientCodeLabel;
    UIButton *_deleteButton;
    UIView *_lineView;
    
    UILabel    *_tipLabel;
    
    
    
    UIView     *_moneyBackView;
    UILabel    *_moneyLabel;
    UILabel    *_discountMoneyLabel;
    UILabel    *_finalPayLabel;
    UILabel    *_moneyValueLabel;
    UILabel    *_discountMoneyValueLabel;
    UILabel    *_finalPayValueLabel;
    
    
    ZPButton   *_commitButton;
    
    
    UIImageView *_processImg;
    
    
}
@end
@implementation ZPReservationView
- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    _addPerButton = [UIButton new];
    _patientView = [UIView new];
    _patientNameLabel = [UILabel new];
    _patientCodeLabel = [UILabel new];
    _patientTypeLabel = [UILabel new];
    _patientPhoneLabel = [UILabel new];
    _deleteButton = [UIButton new];
    _lineView = [UIView new];
    
    
    _tipLabel = [UILabel new];
    _moneyBackView = [UIView new];
    
    _descTextView = [ZPTextView new];
    
    _moneyLabel = [UILabel new];
    _discountMoneyLabel = [UILabel new];
    _finalPayLabel = [UILabel new];
    _moneyValueLabel = [UILabel new];
    _discountMoneyValueLabel = [UILabel new];
    _finalPayValueLabel = [UILabel new];
    
    _commitButton = [ZPButton new];
    
    _processImg = [UIImageView new];
    
    
    [self sd_addSubviews:@[_addPerButton,_tipLabel,_moneyBackView,_commitButton,_descTextView,_patientView,_processImg]];
    _addPerButton.sd_layout
    .widthIs(262)
    .heightIs(38)
    .topSpaceToView(self, 21)
    .centerXEqualToView(self);
    [_addPerButton setTitle:@"+添加就医人" forState:UIControlStateNormal];
    _addPerButton.titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(14)];
    _addPerButton.layer.cornerRadius = 10;
    _addPerButton.layer.masksToBounds = YES;
    _addPerButton.backgroundColor = RGB_78_178_255;
    [_addPerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_addPerButton addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    
    _patientView.sd_layout
    .topSpaceToView(self, 21)
    .heightIs(0)
    .leftEqualToView(self)
    .rightEqualToView(self);
    _patientView.backgroundColor = [UIColor whiteColor];
    [_patientView sd_addSubviews:@[_patientPhoneLabel,_patientTypeLabel,_patientCodeLabel,_patientNameLabel,_lineView,_deleteButton]];
    //就医人信息
    _patientNameLabel.sd_layout
    .topEqualToView(_patientView)
    .heightIs(44)
    .leftSpaceToView(_patientView, 15)
    .widthIs(60);
    _patientNameLabel.textColor = RGB(74,68,74);
    _patientNameLabel.font = [UIFont systemFontOfSize:14];
    
    _deleteButton.sd_layout
    .rightSpaceToView(_patientView, 15)
    .heightIs(24)
    .widthIs(24)
    .centerYEqualToView(_patientNameLabel);
    [_deleteButton setImage:[UIImage imageNamed:@"index_delete_blue"] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    
    _patientPhoneLabel.sd_layout
    .centerYEqualToView(_patientNameLabel)
    .leftSpaceToView(_patientNameLabel, 16)
    .rightSpaceToView(_deleteButton, 5)
    .heightIs(44);
    _patientPhoneLabel.textColor = RGB_74_74_74;
    _patientPhoneLabel.font = [UIFont systemFontOfSize:14];
    
    _patientTypeLabel.sd_layout
    .topSpaceToView(_patientNameLabel, 1)
    .leftSpaceToView(_patientView, 15)
    .heightIs(44)
    .widthIs(60);
    _patientTypeLabel.textColor = RGB_170_170_170;
    _patientTypeLabel.font = [UIFont systemFontOfSize:14];
    
    _patientCodeLabel.sd_layout
    .centerYEqualToView(_patientTypeLabel)
    .leftSpaceToView(_patientTypeLabel, 16)
    .rightSpaceToView(_patientView, 50)
    .heightIs(44);
    _patientCodeLabel.textColor = RGB_74_74_74;
    _patientCodeLabel.font = [UIFont systemFontOfSize:14];
    
    _lineView.sd_layout
    .centerYEqualToView(_patientView)
    .leftEqualToView(_patientView)
    .rightEqualToView(_patientView)
    .heightIs(1);
    _lineView.backgroundColor = RGB_242_242_242;
    
    
    _tipLabel.sd_layout
    .topSpaceToView(@[_addPerButton,_patientView], 21)
    .leftSpaceToView(self, 16)
    .rightSpaceToView(self, 16)
    .heightIs(14);
    _tipLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(14)];
    _tipLabel.textColor = RGB_74_74_74;
    _tipLabel.text = @"预约服务描述:";
    
    
    _descTextView.sd_layout
    .topSpaceToView(_tipLabel, 15)
    .leftSpaceToView(self, 16)
    .rightSpaceToView(self, 16)
    .heightIs(100);
    _descTextView.layer.cornerRadius = 5;
    _descTextView.layer.masksToBounds = YES;
    _descTextView.layer.borderWidth = 0.5;
    _descTextView.backgroundColor = [UIColor whiteColor];
    _descTextView.layer.borderColor = RGB(229, 229, 229).CGColor;
    _descTextView.placeholder = @"约定的时间要根据所服务的具体状况决定，请提前2-3个工作日预约。详细写出您要预约的时间，医院，医生（专家）。方便我们工作人员进行统计。";
    [_descTextView setPlaceholderColor:RGB_170_170_170];
    _descTextView.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(13)];
    
    
    CGFloat w = kSCREEN_WIDTH;
    CGFloat height = 0;
    if ( w <= self.processImage.width) {
        height = (w / self.processImage.width) * self.processImage.height;
    } else{
        height = self.processImage.height;
    }
    _processImg.sd_layout
    .topSpaceToView(_descTextView, 10)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(height);
    [_processImg sd_setImageWithURL:[NSURL URLWithString:self.processImage.url] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
    
    _moneyBackView.sd_layout
    .leftSpaceToView(self, 16)
    .rightSpaceToView(self, 16)
    .heightIs(71)
    .topSpaceToView(_processImg, 21);
    _moneyBackView.backgroundColor = [UIColor whiteColor];
    _moneyBackView.layer.borderColor = RGB_170_170_170.CGColor;
    _moneyBackView.layer.borderWidth = 0.5;
    _moneyBackView.layer.masksToBounds = YES;
    _moneyBackView.layer.cornerRadius = 5;
    [_moneyBackView sd_addSubviews:@[_moneyLabel,_discountMoneyLabel,_finalPayLabel,_moneyValueLabel,_discountMoneyValueLabel,_finalPayValueLabel]];
    _moneyLabel.sd_layout
    .leftSpaceToView(_moneyBackView, 0)
    .topSpaceToView(_moneyBackView, 0)
    .heightIs(34)
    .widthIs((kSCREEN_WIDTH-32)/3);
    _moneyLabel.backgroundColor = RGB(204, 204, 204);
    _moneyLabel.textColor = [UIColor whiteColor];
    _moneyLabel.font = [UIFont systemFontOfSize:13];
    _moneyLabel.text = @"金额";
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    
    
    _discountMoneyLabel.sd_layout
    .leftSpaceToView(_moneyLabel, 0)
    .topSpaceToView(_moneyBackView, 0)
    .heightIs(34)
    .widthIs((kSCREEN_WIDTH-32)/3);
    _discountMoneyLabel.backgroundColor = RGB(204, 204, 204);
    _discountMoneyLabel.textColor = [UIColor whiteColor];
    _discountMoneyLabel.font = [UIFont systemFontOfSize:13];
    _discountMoneyLabel.text = @"优惠金额";
    _discountMoneyLabel.textAlignment = NSTextAlignmentCenter;
    
    _finalPayLabel.sd_layout
    .leftSpaceToView(_discountMoneyLabel, 0)
    .topSpaceToView(_moneyBackView, 0)
    .heightIs(34)
    .rightSpaceToView(_moneyBackView, 0);
    _finalPayLabel.backgroundColor = RGB(204, 204, 204);
    _finalPayLabel.textColor = [UIColor whiteColor];
    _finalPayLabel.font = [UIFont systemFontOfSize:13];
    _finalPayLabel.text = @"实际应付金额";
    _finalPayLabel.textAlignment = NSTextAlignmentCenter;
    
    _moneyValueLabel.sd_layout
    .topSpaceToView(_moneyLabel, 0)
    .leftSpaceToView(_moneyBackView, 0)
    .bottomSpaceToView(_moneyBackView, 0)
    .widthRatioToView(_moneyLabel, 1);
    _moneyValueLabel.textColor = RGB_74_74_74;
    _moneyValueLabel.font = [UIFont systemFontOfSize:13];
    _moneyValueLabel.text = @"- -";
    _moneyValueLabel.textAlignment = NSTextAlignmentCenter;
    
    _discountMoneyValueLabel.sd_layout
    .topSpaceToView(_discountMoneyLabel, 0)
    .leftSpaceToView(_moneyValueLabel, 0)
    .bottomSpaceToView(_moneyBackView, 0)
    .widthRatioToView(_moneyLabel, 1);
    _discountMoneyValueLabel.textColor = RGB_74_74_74;
    _discountMoneyValueLabel.font = [UIFont systemFontOfSize:13];
    _discountMoneyValueLabel.text = @"- -";
    _discountMoneyValueLabel.textAlignment = NSTextAlignmentCenter;
    
    _finalPayValueLabel.sd_layout
    .topSpaceToView(_finalPayLabel, 0)
    .leftSpaceToView(_discountMoneyValueLabel, 0)
    .bottomSpaceToView(_moneyBackView, 0)
    .rightSpaceToView(_moneyBackView, 0);
    _finalPayValueLabel.textColor = RGB_74_74_74;
    _finalPayValueLabel.font = [UIFont systemFontOfSize:13];
    _finalPayValueLabel.text = @"- -";
    _finalPayValueLabel.textAlignment = NSTextAlignmentCenter;
    
    _commitButton.sd_layout
    .topSpaceToView(_moneyBackView, 34)
    .heightIs(50)
    .leftSpaceToView(self, 30)
    .rightSpaceToView(self, 30);
    _commitButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _commitButton.layer.masksToBounds = YES;
    _commitButton.layer.cornerRadius = 8;
    [_commitButton setBackgroundGradientColors:@[RGB_78_178_255,RGB(99,205,255)]];
    [_commitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [_commitButton setTitle:@"提交预约" forState:UIControlStateNormal];
    [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _patientView.hidden = YES;

    
    NSString *text = @"注：付款后，专人电话跟您协商具体事宜（24小时内）";
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString: text];
    /**
     *  设置整段文本size
     */
    one.yy_font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(13)];
    one.yy_color = RGB(78,178,255);
    /**
     *  获得range， 只设置标记文字的size、下划线
     */

    YYLabel *bottomlabel = [[YYLabel alloc] init];
    bottomlabel.attributedText = one;
    bottomlabel.textAlignment = NSTextAlignmentCenter;
    bottomlabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    bottomlabel.numberOfLines = 0;
    [self addSubview:bottomlabel];
    bottomlabel.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(_commitButton, 23)
    .heightIs(15);
    
    
    [self setupAutoHeightWithBottomView:_commitButton bottomMargin:98];
}

- (void)add {
    if (self.addPerBlock) {
        self.addPerBlock();
    }
}

- (void)submit {
    if (self.commitAppointmentBlock) {
        self.commitAppointmentBlock();
    }
}

- (void)delete {
    _addPerButton.sd_layout
    .heightIs(38);
    _patientView.sd_layout
    .heightIs(0);
    _patientView.hidden = YES;
    [self setupAutoHeightWithBottomView:_commitButton bottomMargin:60];
    [self layoutSubviews];
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

- (void)updateUIWithModel:(ZPPatientListModel *)model {
    _patientNameLabel.text = model.name;
    _patientPhoneLabel.text = model.telephone;
    _patientTypeLabel.text = model.idCardType.text;
    _patientCodeLabel.text = model.idCardNo;
    
    _addPerButton.sd_layout
    .heightIs(0);
    _patientView.sd_layout
    .heightIs(89);
    _patientView.hidden = NO;
    [self setupAutoHeightWithBottomView:_commitButton bottomMargin:60];
    [self layoutSubviews];
}

- (void)setModel:(ZPPriceModel *)model {
    _model = model;
    _moneyValueLabel.text = model.totalPay;
    _discountMoneyValueLabel.text  = model.discountMoney;
    _finalPayValueLabel.text  =model.finalPay;
}

- (void)setProcessImage:(ZPImg *)processImage {
    _processImage = processImage;
    CGFloat w = kSCREEN_WIDTH;
    CGFloat height = 0;
    if ( w <= processImage.width) {
        height = (w / processImage.width) * processImage.height;
    } else{
        height = processImage.height;
    }
    _processImg.sd_layout
    .heightIs(height);
    [_processImg sd_setImageWithURL:[NSURL URLWithString:processImage.url] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
}

@end
