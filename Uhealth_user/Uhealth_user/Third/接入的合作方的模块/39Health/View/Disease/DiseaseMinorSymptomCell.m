//
//  DiseaseMinorSymptomCell.m
//  YYK
//
//  Created by xiexianyu on 4/24/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "DiseaseMinorSymptomCell.h"

@interface DiseaseMinorSymptomCell ()

@property (weak, nonatomic) IBOutlet UILabel *symptomLabel;
@property (weak, nonatomic) IBOutlet UIImageView *circleIcon;
@property (weak, nonatomic) IBOutlet UIImageView *checkIcon;

@end

@implementation DiseaseMinorSymptomCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    if (selected) {
        self.checkIcon.image = [UIImage imageNamed:@"minor_sel" inBundle:bundle compatibleWithTraitCollection:nil];
    }
    else {
       self.checkIcon.image = [UIImage imageNamed:@"minor_unsel" inBundle:bundle compatibleWithTraitCollection:nil];
    }
}

// override
- (void)configureWithItem:(MinorSymptom *)item
{
    self.symptomLabel.text = item.name;
    
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
    self.symptomLabel.preferredMaxLayoutWidth = self.symptomLabel.bounds.size.width;
}

@end
