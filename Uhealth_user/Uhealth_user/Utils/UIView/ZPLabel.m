//
//  ZPLabel.m
//  ZPealth
//
//  Created by Biao Geng on 2018/6/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPLabel.h"

@implementation ZPLabel

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}

@end
