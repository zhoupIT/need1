//
//  ZPFeatureItemCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/10/23.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPFeatureItemCell.h"
#import "ZPFeatureContentModel.h"
@interface ZPFeatureItemCell()
/* 属性 */
@property (strong , nonatomic)UILabel *attLabel;
@end
@implementation ZPFeatureItemCell
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
    _attLabel = [[UILabel alloc] init];
    _attLabel.textAlignment = NSTextAlignmentCenter;
    _attLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(12)];
    _attLabel.textColor = ZPMyOrderDetailFontColor;
    [self.contentView addSubview:_attLabel];
    _attLabel.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 10)
    .bottomSpaceToView(self.contentView, 0);
    
    
}
//
//- (void)setContent:(NSString *)content {
//    _content = content;
//    _attLabel.text = content;
//    self.sd_cornerRadius = @(25*0.5);
//    self.contentView.sd_cornerRadius = @(25*0.5);
//}

- (void)setContentModel:(ZPFeatureContentModel *)contentModel {
    _contentModel = contentModel;
    _attLabel.text = contentModel.infoName;
    self.contentView.layer.cornerRadius = 4;
    self.contentView.layer.masksToBounds = YES;
    if (contentModel.isDisableSelect) {
        _attLabel.textColor = RGB(170, 170, 170);
//        [DCSpeedy dc_chageControlCircularWith:_attLabel AndSetCornerRadius:(25*0.5) SetBorderWidth:0 SetBorderColor:[UIColor clearColor] canMasksToBounds:YES];
        self.contentView.backgroundColor = RGB(244, 244, 244);
    }else{
        _attLabel.textColor = ZPMyOrderDetailFontColor;
//        [DCSpeedy dc_chageControlCircularWith:_attLabel AndSetCornerRadius:(25*0.5) SetBorderWidth:0 SetBorderColor:[UIColor clearColor] canMasksToBounds:YES];
        self.contentView.backgroundColor =  RGB(244, 244, 244);
        if (contentModel.isSelect) {
            _attLabel.textColor = [UIColor whiteColor];
            //        [DCSpeedy dc_chageControlCircularWith:_attLabel AndSetCornerRadius:(25*0.5) SetBorderWidth:0 SetBorderColor:[UIColor clearColor] canMasksToBounds:YES];
            self.contentView.backgroundColor = RGB(255, 150, 0);
        }else{
            _attLabel.textColor = ZPMyOrderDetailFontColor;
            //        [DCSpeedy dc_chageControlCircularWith:_attLabel AndSetCornerRadius:(25*0.5) SetBorderWidth:0 SetBorderColor:[UIColor clearColor] canMasksToBounds:YES];
            self.contentView.backgroundColor = RGB(244, 244, 244);
        }
    }
    
}


@end
