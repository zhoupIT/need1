//
//  QISBaseCell.m
//  YYK
//
//  Created by xiexianyu on 1/20/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "QISBaseCell.h"

@implementation QISBaseCell

// override it
- (void)configureWithInfo:(NSDictionary*)info
{
    // default cell
    self.textLabel.text = [info valueForKey:@"name"];
    
    // for update label preferredMaxLayoutWidth
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

// override it
- (void)configureWithInfo:(NSDictionary*)info textKey:(NSString*)key
{
    // default cell
    self.textLabel.text = [info valueForKey:key];
    
    // for update label preferredMaxLayoutWidth
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

// override it
- (void)updateTip:(NSString*)tip {
    /**TODO nothing
     */
}

// override it
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.textLabel.preferredMaxLayoutWidth = self.textLabel.bounds.size.width;
}

// custom cell, override it in iOS8 and later
- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

@end
