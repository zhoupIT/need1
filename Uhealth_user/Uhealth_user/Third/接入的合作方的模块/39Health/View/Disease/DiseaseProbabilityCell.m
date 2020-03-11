//
//  DiseaseProbabilityCell.m
//  YYK
//
//  Created by xiexianyu on 4/24/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "DiseaseProbabilityCell.h"
#import "QISProgressView.h"

@interface DiseaseProbabilityCell ()

@property (weak, nonatomic) IBOutlet UILabel *diseaseNameLabel;
@property (weak, nonatomic) IBOutlet QISProgressView *progressView;

@end

@implementation DiseaseProbabilityCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

// override
- (void)configureWithInfo:(NSDictionary*)info textKey:(NSString*)key
{
    self.diseaseNameLabel.text = [info valueForKey:key];
    
    CGFloat progress = [[info valueForKey:@"Score"] floatValue];
    self.progressView.progress = progress;
}

@end
