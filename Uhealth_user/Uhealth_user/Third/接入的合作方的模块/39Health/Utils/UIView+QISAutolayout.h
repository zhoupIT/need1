//
//  UIView+QISAutolayout.h
//  YYK
//
//  Created by xiexianyu on 3/7/16.
//  Copyright (c) 2016 39.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (QISAutolayout)

// pin view width
- (nonnull NSLayoutConstraint*)pinViewWidth:(CGFloat)width;
// pin view height
- (nonnull NSLayoutConstraint*)pinViewHeight:(CGFloat)height;

// pin view in center x/y of view
- (nonnull NSLayoutConstraint*)pinSubViewInCenterX:(nonnull UIView*)subView;
- (nonnull NSLayoutConstraint*)pinSubViewInCenterY:(nonnull UIView*)subView;

// pin top sibling view, self is common parent view
- (nonnull NSLayoutConstraint*)pinSiblingView:(nonnull UIView*)siblingView
                                    toTopView:(nonnull UIView*)topView
                                       offset:(CGFloat)distance;
// pin bottom sibling view, self is common parent view
- (nonnull NSLayoutConstraint*)pinSiblingView:(nonnull UIView*)siblingView
                                 toBottomView:(nonnull UIView*)bottomView
                                       offset:(CGFloat)distance;
// pin lead sibling view, self is common parent view
- (nonnull NSLayoutConstraint*)pinSiblingView:(nonnull UIView*)siblingView
                                   toLeadView:(nonnull UIView*)leadView
                                       offset:(CGFloat)distance;
// pin trail sibling view, self is common parent view
- (nonnull NSLayoutConstraint*)pinSiblingView:(nonnull UIView*)siblingView
                                  toTrailView:(nonnull UIView*)trailView
                                       offset:(CGFloat)distance;
// zero edge
- (nonnull NSLayoutConstraint*)pinSubview:(nonnull UIView *)subview
                           toEdge:(NSLayoutAttribute)attribute;
// offset edge
- (nonnull NSLayoutConstraint*)pinSubview:(nonnull UIView *)subview
                           toEdge:(NSLayoutAttribute)attribute
                           offset:(CGFloat)distance;
// pin subview, offset
- (nonnull NSLayoutConstraint*)pinSubview:(nonnull UIView *)subview
                                 fromEdge:(NSLayoutAttribute)fromAttribute
                                   toEdge:(NSLayoutAttribute)toAttribute
                                   offset:(CGFloat)distance;

// 
- (void)pinAllEdgesOfSubview:(nonnull UIView *)subview;
//
- (void)pinAllEdgesOfSubview:(nonnull UIView *)subview edgeInsets:(UIEdgeInsets)insets;

@end
