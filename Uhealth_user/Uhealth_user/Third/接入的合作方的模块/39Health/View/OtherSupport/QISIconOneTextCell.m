//
//  QISIconOneTextCell.m
//  YYK
//
//  Created by xiexianyu on 1/19/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "QISIconOneTextCell.h"

@interface QISIconOneTextCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end


@implementation QISIconOneTextCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.iconImageView.hidden = YES;
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    //self.contentView.backgroundColor = [UIColor clearColor];
    
    // bk view
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    UIImage *image = [UIImage imageNamed:@"common_cell_bk" inBundle:bundle compatibleWithTraitCollection:nil];
    UIImage *selImage = [UIImage imageNamed:@"common_cell_bk_sel" inBundle:bundle compatibleWithTraitCollection:nil];
    
    UIImageView *bkView = [[UIImageView alloc] initWithImage:image];
    UIImageView *selectBkView = [[UIImageView alloc] initWithImage:selImage];
    self.backgroundView = bkView;
    self.selectedBackgroundView = selectBkView;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.iconImageView.hidden = !selected;
}

// override
- (void)configureWithInfo:(NSDictionary*)info textKey:(NSString*)key
{
    self.nameLabel.text = [info valueForKey:key];
    
    // for update label preferredMaxLayoutWidth
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    //DebugLog(@"layoutSubviews label width %f", self.nameLabel.bounds.size.width);
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.bounds.size.width;
}

- (void)updateTip:(NSString*)tip
{
    self.nameLabel.text = tip;
    
    // for update label preferredMaxLayoutWidth
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
