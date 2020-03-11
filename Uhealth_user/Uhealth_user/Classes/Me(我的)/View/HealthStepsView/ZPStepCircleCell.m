//
//  ZPStepCircleCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/9/25.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPStepCircleCell.h"
#import "XLCircleProgress.h"
#import "ZPStepModel.h"
@interface ZPStepCircleCell()
{
    UIImageView *_bgIcon;
    XLCircleProgress *_circleProgress;
    UIButton *_syncBtn;
}
@end
@implementation ZPStepCircleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsZero;
    UIView *contentView = self.contentView;
    _bgIcon = [UIImageView new];
    [contentView addSubview:_bgIcon];
    _bgIcon.sd_layout
    .topSpaceToView(contentView, 0)
    .leftSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 0)
    .heightIs(ZPHeight(412));
    _bgIcon.userInteractionEnabled = YES;
    _bgIcon.image = [UIImage imageNamed:@"step_bg_icon"];
    
    _circleProgress = [[XLCircleProgress alloc] initWithFrame:CGRectMake(0, ZPHeight(77), 225, 225)];
    _syncBtn = [UIButton new];
    [_bgIcon sd_addSubviews:@[_circleProgress,_syncBtn]];
    _circleProgress.sd_layout
    .centerXEqualToView(_bgIcon);
    
    _syncBtn.sd_layout
    .topSpaceToView(_circleProgress, ZPHeight(20))
    .widthIs(ZPWidth(90))
    .heightIs(ZPHeight(30))
    .centerXEqualToView(_circleProgress);
    [_syncBtn setTitle:@"数据同步" forState:UIControlStateNormal];
    [_syncBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _syncBtn.titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(14)];
    _syncBtn.layer.cornerRadius = 4;
    _syncBtn.layer.masksToBounds = YES;
    _syncBtn.layer.borderWidth = 1;
    _syncBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [_syncBtn setImage:[UIImage imageNamed:@"step_sync_icon"] forState:UIControlStateNormal];
    [_syncBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:ZPWidth(5)];
    [_syncBtn addTarget:self action:@selector(updateStepsAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupAutoHeightWithBottomView:_bgIcon bottomMargin:0];
}

- (void)setModel:(ZPStepModel *)model {
    _model = model;
     _circleProgress.progress = model.progress/100;
    _circleProgress.steps = model.stepsCount;
}

- (void)updateStepsAction {
    if (self.updateStepsBlock) {
        self.updateStepsBlock();
    }
}
@end
