//
//  ZPUserHeaderView.m
//  ZPealth
//
//  Created by Biao Geng on 2018/3/20.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPUserHeaderView.h"
#import "ZPUserModel.h"
@interface ZPUserHeaderView()
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *avaImageView;
@property (strong, nonatomic) IBOutlet UIButton *personButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@end
@implementation ZPUserHeaderView

+ (instancetype)headerView {
    NSArray* nibView = [[NSBundle mainBundle] loadNibNamed:@"ZPUserHeaderView" owner:nil options:nil];
    return [nibView firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.loginButton.hidden = NO;
    self.personButton.hidden = YES;
    self.nameLabel.hidden = YES;
    self.avaImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avaImageView.clipsToBounds = YES;
    if (IS_IPhoneX) {
        self.aboutButton.sd_layout.topSpaceToView(self, 40);
    }
}

- (IBAction)aboutButtonClick:(UIButton *)sender {
    if (self.aboutBlock) {
        self.aboutBlock();
    }
}
- (IBAction)personalInfoButtonClick:(UIButton *)sender {
    if (self.perosonalInfoBlock) {
        self.perosonalInfoBlock();
    }
}

- (IBAction)collectionGoodButtonClick:(UIButton *)sender {
    if (self.collectionGoodBlock) {
        self.collectionGoodBlock();
    }
}

- (IBAction)collectionStoreButtonClick:(UIButton *)sender {
    if (self.collectionStoreBlock) {
        self.collectionStoreBlock();
    }
}
- (IBAction)loginButtonClick:(UIButton *)sender {
    if (self.loginBlock) {
        self.loginBlock();
    }
}

- (void)setModel:(ZPUserModel *)model {
    _model = model;
    self.loginButton.hidden = YES;
    self.personButton.hidden = NO;
    self.nameLabel.hidden = NO;
    UIImage *placeholderImage;
    if ([model.gender.name isEqualToString:@"FEMALE"]) {
        placeholderImage = [UIImage imageNamed:@"common_userFemale_icon"];
    } else {
        placeholderImage = [UIImage imageNamed:@"common_userMale_icon"];
    }
    [self.avaImageView sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:placeholderImage];
    self.nameLabel.text = ([model.nickName isEqualToString:@""]?@"":model.nickName);
}

@end
