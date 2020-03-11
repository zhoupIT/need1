//
//  ImageCheckHitView.m
//  YYK
//
//  Created by xiexianyu on 4/23/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "ImageCheckHitView.h"
#import "UIImage+QISCompressToJPG.h"

@interface ImageCheckHitView ()

// avoid push next page again for delay show it.
@property (nonatomic, assign) BOOL isTransitioning;

@end


@implementation ImageCheckHitView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // UITapGestureRecognizer
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self addGestureRecognizer:singleTap];
}

- (void)reset
{
    for (UIImageView *partImageView in _partList) {
        partImageView.hidden = YES; //reset old selected
    } //for
}

#pragma mark - handle gensture recognizer
- (void)handleSingleTap:(UIGestureRecognizer*)recognizer
{
    //DebugLog(@"handle tap");
    if (_isTransitioning) {
        // will push next page, not need check hit.
        return ;
    }
    
    CGRect frame = self.entireImageView.bounds;
    CGPoint hitPoint = [recognizer locationInView:self.entireImageView];
    //DebugLog(@"hit x%f y%f", hitPoint.x, hitPoint.y);
    if (CGRectContainsPoint(frame, hitPoint)) {
        //DebugLog(@"inside");
        
        BOOL isTransparent = [self.entireImageView.image isTransparentAtPoint:hitPoint];
        if (!isTransparent) {
            //DebugLog(@"did hit");
            
            // need highlight one part
            // big part need below small part
            NSUInteger selectedIndex = 0;
            CGPoint point;
            BOOL didHit = NO;
            for (UIImageView *partImageView in _partList) {
                partImageView.hidden = YES; //reset old selected
                
                if (!didHit) { // hit only one part, avoid overlay.
                    point = [recognizer locationInView:partImageView];
                    if (CGRectContainsPoint(partImageView.bounds, point)) {
                        // inside of this part, then check transparent or not
                        BOOL isPartTransp = [partImageView.image isTransparentAtPoint:point];
                        if (!isPartTransp) { // hit this part, show it
                            didHit = YES;
                            partImageView.hidden = NO;
                            
                            self.isTransitioning = YES;
                            NSDictionary *info = [self.partInfos objectAtIndex:selectedIndex];
                            // for showing selected part at first, then open next page.
                            //[self didSelectOnePartWithPartInfo:info];
                            [self performSelector:@selector(didSelectOnePartWithPartInfo:) withObject:info afterDelay:0.2];
                        }
                    } //if inside of part
                }
                
                selectedIndex++;
            } //for
            
        } //if space
    } //if inside
    
}

- (void)didSelectOnePartWithPartInfo:(NSDictionary*)info
{
    self.isTransitioning = NO; //reset
    
    // delegate
    if (_delegate != nil && [_delegate respondsToSelector:@selector(didSelectOnePart:)]) {
        [_delegate didSelectOnePart:info];
    }
}

@end
