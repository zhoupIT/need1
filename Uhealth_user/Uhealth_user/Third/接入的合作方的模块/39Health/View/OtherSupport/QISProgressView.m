//
//  QISProgressView.m
//  YYK
//
//  Created by xiexianyu on 4/29/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "QISProgressView.h"
#import "UIView+QISAutolayout.h"

@interface QISProgressView ()

@property (nonatomic, strong) UIImage *progressImage;
@property (nonatomic, strong) UIImage *trackImage;

@property (nonatomic, strong) UIImageView *progressImageView;
@property (nonatomic, strong) UIImageView *trackImageView; // not fill
// auto layout
@property (nonatomic, strong) NSLayoutConstraint *progressTrailConstraint;

@end


@implementation QISProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // init
        NSBundle *bundle = [NSBundle bundleForClass:self.class];
        self.progressImage = [UIImage imageNamed:@"bk_probability" inBundle:bundle compatibleWithTraitCollection:nil];
        self.trackImage = [UIImage imageNamed:@"bk_improbability" inBundle:bundle compatibleWithTraitCollection:nil];
        
        [self setupImageView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSBundle *bundle = [NSBundle bundleForClass:self.class];
        self.progressImage = [UIImage imageNamed:@"bk_probability" inBundle:bundle compatibleWithTraitCollection:nil];
        self.trackImage = [UIImage imageNamed:@"bk_improbability" inBundle:bundle compatibleWithTraitCollection:nil];
        
        [self setupImageView];
    }
    return self;
}

- (void)setupImageView
{
    self.trackImageView = [[UIImageView alloc] initWithImage:_trackImage];
    _trackImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_trackImageView];
    
    self.progressImageView = [[UIImageView alloc] initWithImage:_progressImage];
    _progressImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_progressImageView];
    
    _trackImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _progressImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self pinAllEdgesOfSubview:_trackImageView];
    //
    [self pinSubview:_progressImageView toEdge:NSLayoutAttributeLeading];
    self.progressTrailConstraint = [self pinSubview:_progressImageView toEdge:NSLayoutAttributeTrailing];
    [self pinSubview:_progressImageView toEdge:NSLayoutAttributeTop];
    [self pinSubview:_progressImageView toEdge:NSLayoutAttributeBottom];
    
    [self setNeedsLayout];
}

// access
- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    CGFloat fullWidth = self.bounds.size.width;
    CGFloat width = floor(fullWidth * _progress);
    if (_progress >= 1.0) { // if progress 1.0
        width = fullWidth; // full
    }
    self.progressTrailConstraint.constant = fullWidth-width;
    
    [self setNeedsLayout];
}


@end
