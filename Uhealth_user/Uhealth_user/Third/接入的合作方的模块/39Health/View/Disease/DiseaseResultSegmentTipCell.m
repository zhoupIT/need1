//
//  DiseaseResultSegmentTipCell.m
//  YYK
//
//  Created by xiexianyu on 4/28/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "DiseaseResultSegmentTipCell.h"

@interface DiseaseResultSegmentTipCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation DiseaseResultSegmentTipCell

// override
- (void)configureWithInfo:(NSDictionary*)info textKey:(NSString*)key
{
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *name = [info valueForKey:@"icon"];
    self.icon.image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    
    self.tipLabel.text = [info valueForKey:key];
    
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
    self.tipLabel.preferredMaxLayoutWidth = self.tipLabel.bounds.size.width;
}

@end
