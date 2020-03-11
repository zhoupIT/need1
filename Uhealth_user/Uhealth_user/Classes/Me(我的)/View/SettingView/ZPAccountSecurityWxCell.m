//
//  ZPAccountSecurityWxCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/8/8.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPAccountSecurityWxCell.h"
#import "HSSetTableViewController.h"
#import "ZPBdingCellModel.h"
@interface ZPAccountSecurityWxCell()<UITextFieldDelegate>
@property (nonatomic, weak)UIImageView *leftIconView;  ///<
@property (nonatomic, weak)UILabel *leftLabel;  ///<
@property (nonatomic,weak) UILabel *rightLabel;
@property (nonatomic,weak) UIImageView *rightArrow;
@end
@implementation ZPAccountSecurityWxCell

+ (HSBaseTableViewCell *)cellWithIdentifier:(NSString *)cellIdentifier tableView:(UITableView *)tableView
{
    ZPAccountSecurityWxCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        //这里重写父类方法 仅仅是因为需要改写下cell样式，实际情况可以自己管理布局
        cell = [[ZPAccountSecurityWxCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)setupUI
{
    [super setupUI];
    
    UIImageView *leftIconView = [UIImageView new];
    leftIconView.image = [UIImage imageNamed:@"account_icon_bdingwx"];
    [self.contentView addSubview:leftIconView];
    leftIconView.sd_layout
    .centerYEqualToView(self.contentView)
    .widthIs(23)
    .heightIs(23)
    .leftSpaceToView(self.contentView, IS_IPhone6P?HS_KCellMargin+5:HS_KCellMargin);
    self.leftIconView = leftIconView;
    
    
    UILabel *leftLabel = [UILabel new];
    leftLabel.text = @"微信";
    leftLabel.textColor = ZPMyOrderDetailFontColor;
    leftLabel.font = [UIFont fontWithName:ZPPFSCRegular size:14];
    [self.contentView addSubview:leftLabel];
    leftLabel.sd_layout
    .leftSpaceToView(leftIconView, 9)
    .heightIs(13)
    .centerYEqualToView(self.contentView);
    [leftLabel setSingleLineAutoResizeWithMaxWidth:30];
    self.leftLabel = leftLabel;
    
    UILabel *rightLabel = [UILabel new];
    rightLabel.text = @"未绑定";
    rightLabel.textColor = RGB(99,187,255);
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.font = [UIFont fontWithName:ZPPFSCRegular size:13];
    CGSize sizeWord = [rightLabel.text sizeWithFont:rightLabel.font constrainedToSize:CGSizeMake(100, 1000.0) lineBreakMode:UILineBreakModeWordWrap];
    CGFloat width = sizeWord.width;
    [self.contentView addSubview:rightLabel];
    rightLabel.sd_layout
    .rightSpaceToView(self.contentView, 35)
    .widthIs(width+24)
    .heightIs(24)
    .centerYEqualToView(self.contentView);
    rightLabel.sd_cornerRadius = @12;
    rightLabel.layer.borderColor = ZPMyOrderDetailValueFontColor.CGColor;
    rightLabel.layer.borderWidth = 1;
    rightLabel.layer.masksToBounds = YES;
    rightLabel.backgroundColor = RGB(240, 249, 250);
    self.rightLabel = rightLabel;
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[NSBundle hs_imageNamed:@"ic_hs_tableView_arrow"]];
    [self.contentView addSubview:arrowView];
    arrowView.sd_layout
    .widthIs(8)
    .heightIs(15)
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, 15);
    
}


- (void)setupDataModel:(HSCustomCellModel *)model
{
    [super setupDataModel:model];
    ZPBdingCellModel *cellmodel = (ZPBdingCellModel *)model;
    if (cellmodel.bding == YES) {
        self.rightLabel.text = @"解绑";
    } else {
        self.rightLabel.text = @"未绑定";
    }
    CGSize sizeWord = [self.rightLabel.text sizeWithFont:self.rightLabel.font constrainedToSize:CGSizeMake(100, 1000.0) lineBreakMode:UILineBreakModeWordWrap];
    CGFloat width = sizeWord.width;
    self.rightLabel.sd_layout
    .widthIs(width+24);
    
}
@end
