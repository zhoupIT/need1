//
//  DiseaseDetailTextCell.m
//  YYK
//
//  Created by xiexianyu on 5/4/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "DiseaseDetailTextCell.h"
#import "NSString+QISMatchAttributedString.h"

@interface DiseaseDetailTextCell ()

@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *matchColor;
//
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation DiseaseDetailTextCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.textColor = _descLabel.textColor;
    self.matchColor = [UIColor colorWithRed:102./255. green:102./255. blue:102./255. alpha:1.0];
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

// v5.2
- (void)configureWithDesc:(nonnull NSString*)desc tips:(nonnull)tips
{
    UIFont *font = _descLabel.font;
    
    NSAttributedString *attributedString = [desc buildParagraphStyleAttributedStringWithColor:_textColor font:font lineSpace:2.0 paragraphSpace:8.0 matchColor:_matchColor matchTexts:tips];
    self.descLabel.text = nil;
    self.descLabel.attributedText = attributedString;
    
    // for update label preferredMaxLayoutWidth
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.descLabel.preferredMaxLayoutWidth = self.descLabel.bounds.size.width;
}

@end
