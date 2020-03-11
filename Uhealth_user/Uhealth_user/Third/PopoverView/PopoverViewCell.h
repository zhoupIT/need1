

#import <UIKit/UIKit.h>
#import "PopoverAction.h"

UIKIT_EXTERN float const PopoverViewCellHorizontalMargin; ///< 水平间距边距
UIKIT_EXTERN float const PopoverViewCellVerticalMargin; ///< 垂直边距
UIKIT_EXTERN float const PopoverViewCellTitleLeftEdge; ///< 标题左边边距

@interface PopoverViewCell : UITableViewCell

@property (nonatomic, assign) PopoverViewStyle style;
@property (nonatomic,copy) NSString *selStr;
/*! @brief 标题字体
 */
+ (UIFont *)titleFont;

/*! @brief 底部线条颜色
 */
+ (UIColor *)bottomLineColorForStyle:(PopoverViewStyle)style;

+ (UIColor *)titleColor;

- (void)setSelColor:(NSString *)str;

- (void)setAction:(PopoverAction *)action;

- (void)showBottomLine:(BOOL)show;

@end
