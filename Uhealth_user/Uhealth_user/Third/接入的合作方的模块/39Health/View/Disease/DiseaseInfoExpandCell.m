//
//  DiseaseInfoExpandCell.m
//  YYK
//
//  Created by xiexianyu on 12/14/16.
//  Copyright © 2016 39.net. All rights reserved.
//

#import "DiseaseInfoExpandCell.h"
#import "NSString+QISMatchAttributedString.h"

@interface DiseaseInfoExpandCell ()
@property (strong, nonatomic) NSDictionary *diseaseInfo;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *expandLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end

@implementation DiseaseInfoExpandCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.contentLabel.preferredMaxLayoutWidth = screenWidth-(320.0-288.0);
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (void)configureWithInfo:(NSDictionary*)info
               hideExpand:(BOOL)isHide
                didExpand:(BOOL)didExpand
{
    self.diseaseInfo = info;
    
    [self setExpand:didExpand];
    [self handleExpandContent:didExpand];
    
    // name
    NSString *name = [info valueForKey:@"name"];
    if ([name isKindOfClass:[NSString class]] && [name length] > 0) {
        self.nameLabel.text = name;
    }
    else {
        self.nameLabel.text = nil;
    }
    
    self.expandLabel.hidden = isHide;
}

// helper
- (void)handleExpandContent:(BOOL)didExpand
{
    NSLineBreakMode lineBreakMode = NSLineBreakByWordWrapping;
    if (didExpand) {
        // did expand
        self.expandLabel.text = @"收起";
        
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    else {
        // not expand, show max 5 lines.
        self.expandLabel.text = @"展开";
        
        self.contentLabel.numberOfLines = 5;
        self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        lineBreakMode = NSLineBreakByTruncatingTail;
    }
    
    // content
    NSString *content = [_diseaseInfo valueForKey:@"content"];
    if ([content isKindOfClass:[NSString class]] && [content length] > 0) {
        self.contentLabel.text = content;
        
        UIColor *color = _contentLabel.textColor;
        UIFont *font = _contentLabel.font;
        NSAttributedString *attributedString = [self buildAttributedStringWithText:content textFont:font textColor:color lineSpace:4.0 paragraphSpace:1.0 lineBreakMode:lineBreakMode];
        self.contentLabel.attributedText = attributedString;
    }
    else {
        self.contentLabel.text = nil;
        self.contentLabel.attributedText = nil;
    }
    
    [self.contentLabel sizeToFit];
}

// helper
// paragraph style text
// NSLineBreakByWordWrapping or NSLineBreakByTruncatingTail
- (nullable NSAttributedString*)buildAttributedStringWithText:(nullable NSString*)text
                                                     textFont:(nullable UIFont*)textFont
                                                    textColor:(nullable UIColor*)textColor
                                                    lineSpace:(CGFloat)lineSpace
                                               paragraphSpace:(CGFloat)paragraphSpace
                                                lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    if (text.length == 0) {
        return nil;
    }
    
    // trim at both sides
    NSString *baseString = [text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.paragraphSpacing = paragraphSpace;
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary *textAttributes = @{NSFontAttributeName:textFont, NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:paragraphStyle};
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:baseString attributes:textAttributes];
    return attrString;
}

// custom cell, override it in iOS8 and later
- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

@end
