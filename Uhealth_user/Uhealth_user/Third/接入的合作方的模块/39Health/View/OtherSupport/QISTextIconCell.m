//
//  QISTextIconCell.m
//  YYK
//
//  Created by xiexianyu on 1/20/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "QISTextIconCell.h"

@interface QISTextIconCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@end

@implementation QISTextIconCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.checkImageView.hidden = YES; // hide
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.checkImageView.hidden = !selected;
}

// override
- (void)configureWithInfo:(NSDictionary*)info
{
    [self configureWithInfo:info textKey:@"name"];
}

// override
- (void)configureWithInfo:(NSDictionary*)info textKey:(NSString*)key
{
    self.nameLabel.text = [info valueForKey:key];
    
    // for update label preferredMaxLayoutWidth
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

// override
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.bounds.size.width;
}


@end
