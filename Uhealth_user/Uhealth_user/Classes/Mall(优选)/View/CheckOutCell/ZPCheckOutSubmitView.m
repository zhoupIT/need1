//
//  ZPCheckOutSubmitView.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/3.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPCheckOutSubmitView.h"

@implementation ZPCheckOutSubmitView

+ (instancetype)addSubmitView {
    NSArray* nibView = [[NSBundle mainBundle] loadNibNamed:@"ZPCheckOutSubmitView" owner:nil options:nil];
    return [nibView firstObject];
}

- (IBAction)checkOutSubmitEvent:(UIButton *)sender {
    if (self.submitBlock) {
        self.submitBlock(sender);
    }
}


@end
