//
//  ZPUserViewFlowLayout.m
//  ZPealth
//
//  Created by Biao Geng on 2018/3/20.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPUserViewFlowLayout.h"

@implementation ZPUserViewFlowLayout
- (void)prepareLayout {
    [super prepareLayout];
    
    self.sectionInset = UIEdgeInsetsMake(8, 0, 0, 0);
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
}
@end
