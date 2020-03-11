//
//  DiseaseMajorSelectedCell.m
//  YYK
//
//  Created by xiexianyu on 5/30/18.
//  Copyright © 2018 39.net. All rights reserved.
//

#import "DiseaseMajorSelectedCell.h"

@interface DiseaseMajorSelectedCell ()
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@end

@implementation DiseaseMajorSelectedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (void)configureWithMajorInfo:(NSDictionary*)majorInfo
{
    self.majorLabel.text = [majorInfo valueForKey:@"Name"];
}

@end
