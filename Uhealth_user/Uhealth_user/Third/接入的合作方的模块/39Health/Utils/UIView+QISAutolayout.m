//
//  UIView+QISAutolayout.m
//  YYK
//
//  Created by xiexianyu on 3/7/16.
//  Copyright (c) 2016 39.net. All rights reserved.
//

#import "UIView+QISAutolayout.h"

@implementation UIView (QISAutolayout)

// pin view width
- (nonnull NSLayoutConstraint*)pinViewWidth:(CGFloat)width
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f
                                                                   constant:width];
    
    [self addConstraint:constraint];
    return constraint;
}

// pin view height
- (nonnull NSLayoutConstraint*)pinViewHeight:(CGFloat)height
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f
                                                                   constant:height];
    
    [self addConstraint:constraint];
    return constraint;
}

// pin sub view in center x of super view
- (nonnull NSLayoutConstraint*)pinSubViewInCenterX:(nonnull UIView*)subView
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:subView
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1.0f
                                                                   constant:0.0];
    
    [self addConstraint:constraint];
    return constraint;
}

// pin sub view in center y of super view
- (nonnull NSLayoutConstraint*)pinSubViewInCenterY:(nonnull UIView*)subView
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:subView
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1.0f
                                                                   constant:0.0];
    
    [self addConstraint:constraint];
    return constraint;
}

// pin top sibling view, self is common parent view
- (nonnull NSLayoutConstraint*)pinSiblingView:(nonnull UIView*)siblingView
                                    toTopView:(nonnull UIView*)topView
                                       offset:(CGFloat)distance
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:siblingView
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:topView
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0f
                                                                   constant:distance];
    
    [self addConstraint:constraint];
    return constraint;
}

// pin bottom sibling view, self is common parent view
- (nonnull NSLayoutConstraint*)pinSiblingView:(nonnull UIView*)siblingView
                                 toBottomView:(nonnull UIView*)bottomView
                                       offset:(CGFloat)distance
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:siblingView
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:bottomView
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0f
                                                                   constant:distance];
    
    [self addConstraint:constraint];
    return constraint;
}

// pin lead sibling view, self is common parent view
- (nonnull NSLayoutConstraint*)pinSiblingView:(nonnull UIView*)siblingView
                                   toLeadView:(nonnull UIView*)leadView
                                       offset:(CGFloat)distance
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:siblingView
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:leadView
                                                                  attribute:NSLayoutAttributeTrailing
                                                                 multiplier:1.0f
                                                                   constant:distance];
    
    [self addConstraint:constraint];
    return constraint;
}

// pin trail sibling view, self is common parent view
- (nonnull NSLayoutConstraint*)pinSiblingView:(nonnull UIView*)siblingView
                                  toTrailView:(nonnull UIView*)trailView
                                       offset:(CGFloat)distance
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:siblingView
                                                                  attribute:NSLayoutAttributeTrailing
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:trailView
                                                                  attribute:NSLayoutAttributeLeading
                                                                 multiplier:1.0f
                                                                   constant:distance];
    
    [self addConstraint:constraint];
    return constraint;
}

// pin subview, zero offset
- (nonnull NSLayoutConstraint*)pinSubview:(nonnull UIView *)subview
                           toEdge:(NSLayoutAttribute)attribute
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:attribute
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:subview
                                                                  attribute:attribute
                                                                 multiplier:1.0f
                                                                   constant:0.0f];
    
    [self addConstraint:constraint];
    return constraint;
}

// pin subview, offset
- (nonnull NSLayoutConstraint*)pinSubview:(nonnull UIView *)subview
                           toEdge:(NSLayoutAttribute)attribute
                           offset:(CGFloat)distance
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:attribute
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:subview
                                                                  attribute:attribute
                                                                 multiplier:1.0f
                                                                   constant:distance];
    
    [self addConstraint:constraint];
    return constraint;
}

// pin subview, offset
- (nonnull NSLayoutConstraint*)pinSubview:(nonnull UIView *)subview
                                 fromEdge:(NSLayoutAttribute)fromAttribute
                                   toEdge:(NSLayoutAttribute)toAttribute
                                   offset:(CGFloat)distance
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:fromAttribute
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:subview
                                                                  attribute:toAttribute
                                                                 multiplier:1.0f
                                                                   constant:distance];
    
    [self addConstraint:constraint];
    return constraint;
}

- (void)pinAllEdgesOfSubview:(nonnull UIView *)subview
{
    [self pinSubview:subview toEdge:NSLayoutAttributeBottom];
    [self pinSubview:subview toEdge:NSLayoutAttributeTop];
    [self pinSubview:subview toEdge:NSLayoutAttributeLeading];
    [self pinSubview:subview toEdge:NSLayoutAttributeTrailing];
}

- (void)pinAllEdgesOfSubview:(nonnull UIView *)subview edgeInsets:(UIEdgeInsets)insets
{
    [self pinSubview:subview toEdge:NSLayoutAttributeBottom offset:insets.bottom];
    [self pinSubview:subview toEdge:NSLayoutAttributeTop offset:insets.top];
    [self pinSubview:subview toEdge:NSLayoutAttributeLeading offset:insets.left];
    [self pinSubview:subview toEdge:NSLayoutAttributeTrailing offset:insets.right];
}

@end
