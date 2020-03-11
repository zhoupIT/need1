//
//  ZPPsychologicalAssessmentController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/6/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPPsychologicalAssessmentController.h"
#import "ZPPsychologicalAssessmentInfoController.h"
#import "ZPPsychologicalAssessController.h"
@interface ZPPsychologicalAssessmentController ()
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UIImageView *tipIconView;
@property (nonatomic,strong) UILabel *codeLabel;
@property (nonatomic,strong) UIButton *nextBtn;
@end

@implementation ZPPsychologicalAssessmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
}

- (void)initAll {
    self.title = @"身心评估";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view sd_addSubviews:@[self.iconView,self.nextBtn,self.tipIconView]];
    self.iconView.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, 16)
    .widthIs(ZPWidth(325))
    .heightIs(ZPHeight(190));
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.clipsToBounds = YES;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.psyModel.vipUrlImg] placeholderImage:[UIImage imageNamed:@"placeholder_orderMain"]];
    
    [self.iconView addSubview:self.codeLabel];
    self.codeLabel.sd_layout
    .bottomSpaceToView(self.iconView, ZPHeight(15))
    .leftSpaceToView(self.iconView, ZPWidth(34))
    .heightIs(15);
    [self.codeLabel setSingleLineAutoResizeWithMaxWidth:150];
    if (self.psyModel.companyCode.length) {
        self.codeLabel.text = [NSString stringWithFormat:@"卡号:%@",self.psyModel.companyCode];
    }
    
    
    self.tipIconView.sd_layout
    .topSpaceToView(self.iconView, 27)
    .widthIs(ZPWidth(325))
    .centerXEqualToView(self.view)
    .heightIs(ZPHeight(184));
    
    
    self.nextBtn.sd_layout
    .bottomEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(50);
}

#pragma mark - 私有方法
- (void)nextAction {
//    ZPPsychologicalAssessmentInfoController *psyInfoControl = [[ZPPsychologicalAssessmentInfoController alloc] init];
//    psyInfoControl.psyModel = self.psyModel;
//    [self.navigationController pushViewController:psyInfoControl animated:YES];
    //跳转输入个人信息的界面
    ZPPsychologicalAssessController *psyControl = [[ZPPsychologicalAssessController alloc] init];
    psyControl.model = self.psyModel;
    [self.navigationController pushViewController:psyControl animated:YES];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
    }
    return _scrollView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [UIImageView new];
    }
    return _iconView;
}

- (UIImageView *)tipIconView {
    if (!_tipIconView) {
        _tipIconView = [UIImageView new];
        _tipIconView.image = [UIImage imageNamed:@"psychologicalAssessment"];
    }
    return _tipIconView;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton new];
        _nextBtn.backgroundColor = ZPMyOrderDetailValueFontColor;
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (UILabel *)codeLabel {
    if (!_codeLabel) {
        _codeLabel = [UILabel new];
        _codeLabel.textColor = ZPMyOrderDetailFontColor;
        _codeLabel.adjustsFontSizeToFitWidth = YES;
        if (IS_IPHONE5 || IS_IPHONE4) {
            _codeLabel.font = [UIFont fontWithName:ZPPFSCRegular size:12];
        } else {
          _codeLabel.font = [UIFont fontWithName:ZPPFSCRegular size:14];
        }
        
    }
    return _codeLabel;
}
@end
