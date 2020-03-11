//
//  FemaleFrontView.m
//  YYK
//
//  Created by xiexianyu on 4/23/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "FemaleFrontView.h"

@interface FemaleFrontView ()

@property (weak, nonatomic) IBOutlet UIImageView *entire;
@property (weak, nonatomic) IBOutlet UIImageView *arm;
@property (weak, nonatomic) IBOutlet UIImageView *leg;
@property (weak, nonatomic) IBOutlet UIImageView *chest;
@property (weak, nonatomic) IBOutlet UIImageView *belly;
@property (weak, nonatomic) IBOutlet UIImageView *head;
@property (weak, nonatomic) IBOutlet UIImageView *basin;

@end

@implementation FemaleFrontView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.entireImageView = _entire;
    
    // big part need below small part
    // check whtich part to hit
    self.partList = @[_arm, _leg, _chest, _belly, _head, _basin];
    
    // hide all part at first
    for (UIImageView *partImageView in self.partList) {
        partImageView.hidden = YES; // hide
    } //for
    
    self.partInfos = @[@{@"name":@"上肢",@"param":@"上肢"}, @{@"name":@"下肢",@"param":@"下肢"}, @{@"name":@"胸",@"param":@"胸部"}, @{@"name":@"腹",@"param":@"腹部"}, @{@"name":@"头",@"param":@"头部"}, @{@"name":@"女性生殖",@"param":@"女性生殖"}];
    
}

@end
