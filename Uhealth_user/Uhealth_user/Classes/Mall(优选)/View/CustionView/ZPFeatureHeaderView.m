//
//  ZPFeatureHeaderView.m
//  ZPealth
//
//  Created by Biao Geng on 2018/10/23.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPFeatureHeaderView.h"

@interface ZPFeatureHeaderView()
/* 属性标题 */
@property (strong , nonatomic)UILabel *headerLabel;
@end
@implementation ZPFeatureHeaderView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    _headerLabel = [[UILabel alloc] init];
    _headerLabel.font  = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(14)];
    _headerLabel.textColor  = ZPMyOrderDetailFontColor;
    [self addSubview:_headerLabel];
    _headerLabel.sd_layout
    .leftSpaceToView(self, 10)
    .topSpaceToView(self, 0)
    .rightSpaceToView(self, 10)
    .bottomSpaceToView(self, 0);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _headerLabel.text = title;
}
@end
