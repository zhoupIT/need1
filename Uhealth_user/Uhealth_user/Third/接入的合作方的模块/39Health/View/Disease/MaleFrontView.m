//
//  MaleFrontView.m
//  YYK
//
//  Created by xiexianyu on 4/23/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "MaleFrontView.h"

@interface MaleFrontView ()

// entire
@property (weak, nonatomic) IBOutlet UIImageView *maleFrontAll;
// part
@property (weak, nonatomic) IBOutlet UIImageView *maleFrontArm;
@property (weak, nonatomic) IBOutlet UIImageView *maleFrontLeg;
@property (weak, nonatomic) IBOutlet UIImageView *maleFrontHead;
@property (weak, nonatomic) IBOutlet UIImageView *maleFrontChest;
@property (weak, nonatomic) IBOutlet UIImageView *maleFrontBelly;
@property (weak, nonatomic) IBOutlet UIImageView *maleFrontBasin;

@end

@implementation MaleFrontView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.entireImageView = _maleFrontAll;
    
    // big part need below small part
    // check whtich part to hit:head,chest,belly,basin,leg,arm
    self.partList = @[_maleFrontHead, _maleFrontChest, _maleFrontBelly, _maleFrontBasin, _maleFrontLeg, _maleFrontArm];
    
    // hide all part at first
    for (UIImageView *partImageView in self.partList) {
        partImageView.hidden = YES; // hide
    } //for
    
    // body infos
    self.partInfos = @[@{@"name":@"头",@"param":@"头部"}, @{@"name":@"胸",@"param":@"胸部"}, @{@"name":@"腹",@"param":@"腹部"}, @{@"name":@"男性生殖",@"param":@"男性生殖"}, @{@"name":@"下肢",@"param":@"下肢"}, @{@"name":@"上肢",@"param":@"上肢"}];
}


@end
