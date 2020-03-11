//
//  DiseaseGuideNameCell.m
//  YYK
//
//  Created by xiexianyu on 5/7/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "DiseaseGuideNameCell.h"
#import "NSString+QISMatchAttributedString.h"

@interface DiseaseGuideNameCell ()

@property (nonatomic, strong) UIColor *textColor;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation DiseaseGuideNameCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textColor = _tipLabel.textColor; //save
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

// override
- (void)configureWithInfo:(NSDictionary *)info
{
    UIColor *matchColor = [UIColor colorWithRed:48.0/255.0 green:134.0/255.0 blue:242.0/255.0 alpha:1.0];
    UIFont *font = _tipLabel.font;
    
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    self.icon.image = [UIImage imageNamed:[info valueForKey:@"icon"] inBundle:bundle compatibleWithTraitCollection:nil];
    
    NSString *name = [info valueForKey:@"name"];
    NSString *nameType = [NSString stringWithFormat:@"%@就诊指南", name];
    NSAttributedString *attributedString = [nameType buildAttributedStringWithKeyword:@"就诊指南" textFont:font textColor:_textColor matchColor:matchColor];
    self.tipLabel.text = nil;
    self.tipLabel.attributedText = attributedString;
    
    // for update label preferredMaxLayoutWidth
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.tipLabel.preferredMaxLayoutWidth = self.tipLabel.bounds.size.width;
}

@end
