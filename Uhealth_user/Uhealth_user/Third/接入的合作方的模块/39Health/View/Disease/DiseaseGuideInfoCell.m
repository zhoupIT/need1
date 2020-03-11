//
//  DiseaseGuideInfoCell.m
//  YYK
//
//  Created by xiexianyu on 5/7/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "DiseaseGuideInfoCell.h"
#import "NSString+QISMatchAttributedString.h"

@interface DiseaseGuideInfoCell ()

@property (weak, nonatomic) IBOutlet UIView *tipBkView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) UIView *tipBkView2;

@end

@implementation DiseaseGuideInfoCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.tipBkView2 = [[UIView alloc] initWithFrame:CGRectZero];
    UIColor *bkColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    _tipBkView2.backgroundColor = bkColor;
    [self.contentView addSubview:_tipBkView2];
    [self.contentView bringSubviewToFront:_tipLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// override
- (void)configureWithInfo:(NSDictionary *)info
{
    UIColor *color = _descLabel.textColor;
    UIFont *font = _descLabel.font;
    
    NSString *text = [info valueForKey:@"desc"];
    NSAttributedString *attributedString = [text buildParagraphStyleAttributedStringWithColor:color font:font lineSpace:4.0 paragraphSpace:4.0];
    self.descLabel.text = nil;
    self.descLabel.attributedText = attributedString;
    
    self.tipLabel.text = [info valueForKey:@"name"];
    
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
    
    //[self setNeedsDisplay]; //draw
    self.tipBkView2.frame = CGRectInset(_tipBkView.frame, -2, 0);
}

//- (void)drawRect:(CGRect)rect
//{
//    // Drawing
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    
//    // Drawing lines with a gray stroke color
//    CGContextSetRGBStrokeColor(context, 245./255., 245./255., 245./255., 1.0);
//    // And drawing with a fill color
//    CGContextSetRGBFillColor(context, 245./255., 245./255., 245./255., 1.0);
//    
//    // line width
//    //CGContextSetLineWidth(context, 0.5);
//    CGContextFillRect(context, _tipBkView.frame);
//    
//    CGContextRestoreGState(context);
//}

@end
