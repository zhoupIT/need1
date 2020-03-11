//
//  ZPAddPatientView.m
//  Uhealth
//
//  Created by Biao Geng on 2018/4/24.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPAddPatientView.h"

@interface ZPAddPatientView()


@end
@implementation ZPAddPatientView

+ (instancetype)addPatientView {
    NSArray* nibView = [[NSBundle mainBundle] loadNibNamed:@"ZPAddPatientView" owner:nil options:nil];
    return [nibView firstObject];
}
- (IBAction)staffSelAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.familyBtn.selected = NO;
}
- (IBAction)familyAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.staffBtn.selected = NO;
}



- (IBAction)btnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.jrBtn.selected = NO;
    self.hzBtn.selected = NO;
}
- (IBAction)jrbtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.sfzBtn.selected = NO;
    self.hzBtn.selected = NO;
}
- (IBAction)hzBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.sfzBtn.selected = NO;
    self.jrBtn.selected = NO;
}

@end
