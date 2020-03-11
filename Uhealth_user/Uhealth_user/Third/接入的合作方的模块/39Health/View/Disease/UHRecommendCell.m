//
//  UHRecommendCell.m
//  Uhealth
//
//  Created by Biao Geng on 2018/8/22.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "UHRecommendCell.h"

@interface UHRecommendCell()
@property (strong, nonatomic) IBOutlet UILabel *leftLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightLabel;

@end
@implementation UHRecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// override
- (void)configureWithInfo:(NSDictionary*)info textKey:(NSString*)key
{
    self.leftLabel.text = [info valueForKey:@"Name"];
    self.rightLabel.text = [info valueForKey:@"subName"];
}

@end
