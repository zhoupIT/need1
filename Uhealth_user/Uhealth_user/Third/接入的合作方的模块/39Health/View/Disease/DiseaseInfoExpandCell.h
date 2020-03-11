//
//  DiseaseInfoExpandCell.h
//  YYK
//
//  Created by xiexianyu on 12/14/16.
//  Copyright © 2016 39.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiseaseInfoExpandCell : UITableViewCell

@property (assign, nonatomic, setter=setExpand:) BOOL didExpand;

// keys: name; content;
- (void)configureWithInfo:(NSDictionary*)info
               hideExpand:(BOOL)isHide
                didExpand:(BOOL)didExpand;

@end
