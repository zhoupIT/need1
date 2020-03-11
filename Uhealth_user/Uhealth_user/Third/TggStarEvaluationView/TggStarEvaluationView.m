//
//  TggAppraiseView.m
//  StarAppraiseDemo
//
//  Created by 铁哥哥 on 16/7/15.
//  Copyright © 2016年 铁拳科技. All rights reserved.
//

#import "TggStarEvaluationView.h"

typedef void(^EvaluateViewDidChooseStarBlock)(NSUInteger count);
@interface TggStarEvaluationView ()

@property (nonatomic, assign)   NSUInteger index;
@property (nonatomic, copy)     EvaluateViewDidChooseStarBlock evaluateViewChooseStarBlock;

@end


@implementation TggStarEvaluationView

/**************初始化TggEvaluationView*************/
+ (instancetype)evaluationViewWithChooseStarBlock:(void(^)(NSUInteger count))evaluateViewChoosedStarBlock {
    TggStarEvaluationView *evaluationView = [[TggStarEvaluationView alloc] init];
    evaluationView.backgroundColor = [UIColor clearColor];
    evaluationView.evaluateViewChooseStarBlock = ^(NSUInteger count) {
        if (evaluateViewChoosedStarBlock) {
            evaluateViewChoosedStarBlock(count);
        }
    };
    return evaluationView;
}



#pragma mark - AccessorMethod

- (void)setStarCount:(NSUInteger)starCount {
    if (starCount == 0) {
        return;
    }
    if (_starCount != starCount) {
        _starCount = starCount;
        if (starCount > 5) {
            starCount = 5;
        }
        self.index = starCount;
        [self setNeedsDisplay];
        if (self.evaluateViewChooseStarBlock) {
            self.evaluateViewChooseStarBlock(self.index);
        }
    }
}


- (void)setTapEnabled:(BOOL)tapEnabled {
    _tapEnabled = tapEnabled;
    self.userInteractionEnabled = tapEnabled;
}

- (void)setSpacing:(CGFloat)spacing {
    if (_spacing != spacing) {
        _spacing = spacing;
        [self setNeedsDisplay];
    }
}



#pragma mark - DrawStarsMethod

/**************重写*************/
- (void)drawRect:(CGRect)rect {
    UIImage *norImage = [UIImage imageNamed:@"star_nor"];
    UIImage *selImage = [UIImage imageNamed:@"star_sel"];
    // 图片没间隙自己画
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 默认间隙为星星一半
    CGFloat spacing = self.frame.size.width / 20;
    CGFloat top = 0;
    CGFloat starWidth = spacing * 2;
    if (self.spacing != 0) {
        if (self.spacing > 1) {
            self.spacing = 1;
        }
        starWidth = self.frame.size.width / (self.spacing * 10 + 5);
        spacing = starWidth * self.spacing;
    }
    // 如果高度过高则居中
    if (self.frame.size.height > starWidth) {
        top = (self.frame.size.height - starWidth) / 2;
    }
    NSArray *fontArray = @[@"不好",@"一般",@"良好",@"优秀",@"完美"];
    // 画图
    for (NSInteger i = 0; i < 5; i ++) {
        UIImage *drawImage = i < self.index ? selImage : norImage;
        
       
        UIImage *fontImage = [self createShareImage:@"" Context:fontArray[i]];
        
        [self drawImage:context CGImageRef:drawImage.CGImage CGRect:CGRectMake((i == 0) ? spacing : 2 * i * spacing + spacing + starWidth * i, top-10, starWidth, starWidth)];
        
        
        [self drawImage:context CGImageRef:fontImage.CGImage CGRect:CGRectMake((i == 0) ? spacing : 2 * i * spacing + spacing + starWidth * i, top+starWidth-5, 25, 14)];
    }
    // 瞬间画满,需要图片有间隙
    //CGContextDrawTiledImage(context, CGRectMake(0, 0, 30, 30), image.CGImage);
}


- (UIImage *)createShareImage:(NSString *)imageName Context:(NSString *)text
{
    UIImage *sourceImage = [UIImage imageNamed:imageName];
    CGSize imageSize = CGSizeMake(25, 14); //画的背景 大小
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    [sourceImage drawAtPoint:CGPointMake(0, 0)];
    //获得 图形上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextDrawPath(context, kCGPathStroke);
    CGFloat nameFont = 12.f;
    //画 自己想要画的内容
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:nameFont]};
    CGRect sizeToFit = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, nameFont) options:NSStringDrawingUsesDeviceMetrics attributes:attributes context:nil];
    NSLog(@"图片: %f %f",imageSize.width,imageSize.height);
    NSLog(@"sizeToFit: %f %f",sizeToFit.size.width,sizeToFit.size.height);
    CGContextSetFillColorWithColor(context, RGB(170, 170, 170).CGColor);
    [text drawAtPoint:CGPointMake((imageSize.width-sizeToFit.size.width)/2,0) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:nameFont]}];
    //返回绘制的新图形
    
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

/**************将坐标翻转画图*************/
- (void)drawImage:(CGContextRef)context
       CGImageRef:(CGImageRef)image
           CGRect:(CGRect)rect {
        CGContextSaveGState(context);
    
        CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
        CGContextTranslateCTM(context, 0, rect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
        CGContextDrawImage(context, rect, image);
    
        CGContextRestoreGState(context);
}


#pragma mark - TouchGestureMethod

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.index = point.x / (self.frame.size.width / 5) + 1;
    if (self.index == 6) {
        self.index --;
    }
    [self setNeedsDisplay];
    if (self.evaluateViewChooseStarBlock) {
        self.evaluateViewChooseStarBlock(self.index);
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}
















@end
