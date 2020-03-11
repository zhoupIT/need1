//
//  MaleBackView.m
//  YYK
//
//  Created by xiexianyu on 4/23/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "MaleBackView.h"

@interface MaleBackView ()

@property (weak, nonatomic) IBOutlet UIImageView *maleBackAll;
// part
@property (weak, nonatomic) IBOutlet UIImageView *back;
@property (weak, nonatomic) IBOutlet UIImageView *arm;
@property (weak, nonatomic) IBOutlet UIImageView *leg;
@property (weak, nonatomic) IBOutlet UIImageView *head;
@property (weak, nonatomic) IBOutlet UIImageView *butt;
@property (weak, nonatomic) IBOutlet UIImageView *neck;

@end

@implementation MaleBackView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.entireImageView = _maleBackAll;
    
    // big part need below small part
    // check whtich part to hit
    self.partList = @[_back, _arm, _leg, _neck, _head, _butt];
    
    // hide all part at first
    for (UIImageView *partImageView in self.partList) {
        partImageView.hidden = YES; // hide
    } //for
    
    self.partInfos = @[@{@"name":@"背部",@"param":@"背部"}, @{@"name":@"上肢",@"param":@"上肢"}, @{@"name":@"下肢",@"param":@"下肢"}, @{@"name":@"肩部",@"param":@"肩部"}, @{@"name":@"头",@"param":@"头部"}, @{@"name":@"臀",@"param":@"臀部"}];
}

@end
