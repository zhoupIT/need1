//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Convenience)

+ (instancetype)zp_barButtonItemWithTarget:(id)target action:(SEL)action icon:(NSString *)icon highlighticon:(NSString *)highlighticon backgroundImage:(UIImage *)backgroundImage;

@end
