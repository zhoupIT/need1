//
//  ZPIndexFunctionCell.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPIndexFunctionCell.h"

@implementation ZPIndexFunctionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *contentView = self.contentView;
    NSArray *titleData = @[@"绿色通道",@"症状自查",@"身心咨询",@"健步走",@"健康资讯"];
    NSArray *imgData = @[@"index_fun_greenPath",@"index_fun_selfTest",@"index_fun_consult",@"index_fun_healthrun",@"index_fun_healthNews"];
    UIButton *tempBtn;
    for (int i = 0; i<5; i++) {
        UIButton *btn = [UIButton new];
        [btn setImage:[UIImage imageNamed:imgData[i]] forState:UIControlStateNormal];
        [btn setTitle:titleData[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGB_74_74_74 forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(12)];
        btn.tag = 10001+i;
        [btn addTarget:self action:@selector(didClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn];
        CGFloat w = (kSCREEN_WIDTH-ZPWidth(10)*2)/5;
        if (i == 0) {
            btn.sd_layout
            .widthIs(w)
            .heightIs(ZPHeight(66))
            .topSpaceToView(contentView, ZPHeight(20))
            .leftSpaceToView(contentView, ZPWidth(10));
            tempBtn = btn;
        } else if (i < 5) {
            btn.sd_layout
            .leftSpaceToView(tempBtn, 0)
            .widthIs(w)
            .topSpaceToView(contentView,ZPHeight(20))
            .heightIs(ZPHeight(66));
            tempBtn = btn;
        }
        __weak UIButton *weakBtn = btn;
        btn.didFinishAutoLayoutBlock = ^(CGRect frame) {
            [weakBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:ZPHeight(15)];
            //修正在iPhone5上图片过大的bug
            weakBtn.imageView.sd_layout
            .widthIs(ZPWidth(45))
            .heightIs(ZPHeight(45))
            .topSpaceToView(weakBtn, 0);
            weakBtn.titleLabel.sd_layout
            .bottomSpaceToView(weakBtn, 0);
        };
    }
    
}

- (void)didClickEvent:(UIButton *)btn {
    if (self.didClickBlock) {
        self.didClickBlock(btn.tag);
    }
}

@end
