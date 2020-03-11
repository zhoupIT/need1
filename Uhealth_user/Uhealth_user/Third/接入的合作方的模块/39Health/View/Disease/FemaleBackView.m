//
//  FemaleBackView.m
//  YYK
//
//  Created by xiexianyu on 4/23/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "FemaleBackView.h"

@interface FemaleBackView ()
@property (weak, nonatomic) IBOutlet UIImageView *entire;
@property (weak, nonatomic) IBOutlet UIImageView *arm;
@property (weak, nonatomic) IBOutlet UIImageView *leg;
@property (weak, nonatomic) IBOutlet UIImageView *back;
@property (weak, nonatomic) IBOutlet UIImageView *butt;
@property (weak, nonatomic) IBOutlet UIImageView *head;
@property (weak, nonatomic) IBOutlet UIImageView *neck;
@end


@implementation FemaleBackView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.entireImageView = _entire;
    
    // big part need below small part
    // check whtich part to hit
    self.partList = @[_arm, _leg, _back, _butt, _neck, _head];
    
    // hide all part at first
    for (UIImageView *partImageView in self.partList) {
        partImageView.hidden = YES; // hide
    } //for
    
    self.partInfos = @[@{@"name":@"上肢",@"param":@"上肢"}, @{@"name":@"下肢",@"param":@"下肢"}, @{@"name":@"背部",@"param":@"背部"}, @{@"name":@"臀",@"param":@"臀部"}, @{@"name":@"肩部",@"param":@"肩部"}, @{@"name":@"头",@"param":@"头部"}];
}

@end
