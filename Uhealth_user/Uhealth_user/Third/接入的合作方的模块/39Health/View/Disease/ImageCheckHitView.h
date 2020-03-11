//
//  ImageCheckHitView.h
//  YYK
//
//  Created by xiexianyu on 4/23/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageCheckHitViewDelegate <NSObject>

@optional
- (void)didSelectOnePart:(NSDictionary*)info;

@end


@interface ImageCheckHitView : UIView

@property (weak, nonatomic) id<ImageCheckHitViewDelegate> delegate;

@property (strong, nonatomic) UIImageView *entireImageView; // entire body
@property (strong, nonatomic) NSArray *partList; // part image view list
@property (strong, nonatomic) NSArray *partInfos; // part name, param

// hide all part of highlight image
- (void)reset;

@end
