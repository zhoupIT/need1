//
//  QISBaseCell.h
//  YYK
//
//  Created by xiexianyu on 1/20/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QISBaseCellDelegate <NSObject>

@optional
- (void)didSelectRow:(NSDictionary*)info;
@end

@interface QISBaseCell : UITableViewCell

@property (nonatomic, weak) id<QISBaseCellDelegate> delegate;

// override it
- (void)configureWithInfo:(NSDictionary*)info;
// text string from param key.
- (void)configureWithInfo:(NSDictionary*)info textKey:(NSString*)key;
    
- (void)updateTip:(NSString*)tip;

@end
