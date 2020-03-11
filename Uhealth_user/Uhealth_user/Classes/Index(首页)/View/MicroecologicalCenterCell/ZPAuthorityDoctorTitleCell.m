//
//  ZPAuthorityDoctorTitleCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/8/10.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPAuthorityDoctorTitleCell.h"
#import "ZPChannelDoctorModel.h"
@interface ZPAuthorityDoctorTitleCell()
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *doctorTitleLabel;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIButton *tempbtn;

@end
@implementation ZPAuthorityDoctorTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *contentView = self.contentView;
    self.iconView = [UIImageView new];
    self.nameLabel = [UILabel new];
    self.doctorTitleLabel = [UILabel new];
    self.lineView = [UIView new];
    [contentView sd_addSubviews:@[self.iconView,self.nameLabel,self.doctorTitleLabel,self.lineView]];
    
    self.iconView.sd_cornerRadius = @25;
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.sd_layout
    .leftSpaceToView(contentView, 15)
    .topSpaceToView(contentView, 15)
    .heightIs(50)
    .widthIs(50);
    

    self.nameLabel.textColor = ZPMyOrderDetailFontColor;
    self.nameLabel.font = [UIFont fontWithName:ZPPFSCRegular size:15];
    self.nameLabel.sd_layout
    .leftSpaceToView(self.iconView, 20)
    .rightSpaceToView(contentView, 15)
    .topEqualToView(self.iconView)
    .autoHeightRatio(0);
    
    self.doctorTitleLabel.textColor = RGB(153, 153, 153);
    self.doctorTitleLabel.font = [UIFont fontWithName:ZPPFSCLight size:12];
    self.doctorTitleLabel.sd_layout
    .leftSpaceToView(self.iconView, 20)
    .rightSpaceToView(contentView, 15)
    .topSpaceToView(self.nameLabel, 11)
    .autoHeightRatio(0);
    
    self.lineView.backgroundColor = RGB_242_242_242;
    self.lineView.sd_layout
    .topSpaceToView(self.doctorTitleLabel, 15)
    .leftSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 0)
    .heightIs(1);
    
    UIButton *tempbtn;
    NSArray *titleArray = @[@"直播讲堂",@"图文咨询",@"在线沟通"];
    for (int i = 0; i<3; i++) {
        UIButton *btn = [UIButton new];
        [contentView addSubview:btn];
        if (i==0) {
            btn.sd_layout
            .leftSpaceToView(contentView, 15)
            .heightIs(62)
            .topSpaceToView(self.lineView, 15)
            .widthIs((kSCREEN_WIDTH-15*2-2*47)/3);
            //(SCREEN_WIDTH-15*2-4*22)/5
            self.tempbtn = btn;
            
        } else {
            btn.sd_layout
            .leftSpaceToView(tempbtn, 47)
            .heightIs(62)
            .topSpaceToView(self.lineView, 15)
            .centerYEqualToView(tempbtn)
            .widthIs((kSCREEN_WIDTH-15*2-2*47)/3);
            //
        }
        btn.imageView.sd_layout.centerXEqualToView(btn);
        btn.titleLabel.sd_layout.centerXEqualToView(btn)
        .leftSpaceToView(btn, 0)
        .widthIs((kSCREEN_WIDTH-15*2-2*47)/3);
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGB(74, 74, 74) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:13];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [btn setImage:[UIImage imageNamed:titleArray[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:titleArray[i]] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:titleArray[i]] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:RGB_242_242_242] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:RGB_242_242_242] forState:UIControlStateHighlighted];
        [btn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:12];
        
        btn.tag = 10000+i;
        [btn addTarget:self action:@selector(didClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        tempbtn = btn;
    }
    
    [self setupAutoHeightWithBottomView:tempbtn bottomMargin:15];
}

- (void)didClickEvent:(UIButton *)btn {
    if (self.imgClickBlock) {
        self.imgClickBlock(btn);
    }
}

- (void)setModel:(ZPChannelDoctorModel *)model {
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.doctorHeadimg] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
    self.nameLabel.text = model.doctorName;
    self.doctorTitleLabel.text = model.doctorTitle;
    if (model.lectureCount > 0) {
        [self.tempbtn setImage:[UIImage imageNamed:@"直播讲堂"] forState:UIControlStateNormal];
        [self.tempbtn setImage:[UIImage imageNamed:@"直播讲堂"] forState:UIControlStateSelected];
        [self.tempbtn setImage:[UIImage imageNamed:@"直播讲堂"] forState:UIControlStateHighlighted];
    } else {
        [self.tempbtn setImage:[UIImage imageNamed:@"直播讲堂_dis"] forState:UIControlStateNormal];
        [self.tempbtn setImage:[UIImage imageNamed:@"直播讲堂_dis"] forState:UIControlStateSelected];
        [self.tempbtn setImage:[UIImage imageNamed:@"直播讲堂_dis"] forState:UIControlStateHighlighted];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
