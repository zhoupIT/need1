//
//  ZPBaseView.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/5.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPBaseView.h"

@interface ZPBaseView()
{
    /* 存储背景渐变色数组 */
    NSArray *_backgroundgradientColors;
}
@end
@implementation ZPBaseView

/* 设置颜色的set方法 */
- (void)setBackgroundGradientColors:(NSArray<UIColor *> *)colors {
    _backgroundgradientColors = [NSArray arrayWithArray:colors];
}

/* 绘制UIButton对象背景的渐变色特效 */
- (UIImage *)setBGGradientColors:(NSArray<UIColor *> *)colors {
    if (colors.count > 1) {
        //有多种颜色，需要渐变层对象来上色
        //创建渐变层对象
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        //设置渐变层的frame等同于按钮的frame（这里高度有个小误差，补上就可以了）
        gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height + 3);
        //将存储的渐变色数组（UIColor类）转变为CAGradientLayer对象的colors数组，并设置该数组为CAGradientLayer对象的colors属性
        NSMutableArray *gradientColors = [NSMutableArray array];
        for (UIColor *colorItem in colors) {
            [gradientColors addObject:(id)colorItem.CGColor];
        }
        gradientLayer.colors = [NSArray arrayWithArray:gradientColors];
        //下一步需要将CAGradientLayer对象绘制到一个UIImage对象上，以便使用这个UIImage对象来填充按钮的背景色
        UIImage *gradientImage = [self imageFromLayer:gradientLayer];
        //使用UIColor的如下方法，将字体颜色设为gradientImage模式，这样就可以将渐变色填充到背景色上了，同理可以设置按钮各状态的不同显示效果
        return gradientImage;
    }
    return nil;
}


/* 将一个CALayer对象绘制到一个UIImage对象上，并返回这个UIImage对象 */
- (UIImage *)imageFromLayer:(CALayer *)layer {
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.opaque, 0);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_backgroundgradientColors) {
        [self setBGGradientColors:_backgroundgradientColors];
    }
}

@end
