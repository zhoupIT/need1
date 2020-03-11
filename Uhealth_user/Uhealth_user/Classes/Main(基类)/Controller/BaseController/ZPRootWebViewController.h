//
//  ZPRootWebViewController.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/7.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPRootWebViewController : UIViewController
/** 标题 */
@property (nonatomic,copy) NSString *titleString;
/** url链接 */
@property (nonatomic,copy) NSString *url;
/** 是否初始化关闭按钮 */
@property (nonatomic,assign) BOOL initCloseBtn;
/** 是否是本地html */
@property (nonatomic,assign) BOOL localHtml;
/** 是否是 心理测评界面 */
@property (nonatomic,assign) BOOL isPsyAssessPage;
/** 心理测评 个人信息是否填好*/
@property (nonatomic,assign) BOOL infoFilled;
/** 可用来调整webview的位置 */
@property(nonatomic, assign) UIEdgeInsets webViewContentInsets;

@end

NS_ASSUME_NONNULL_END
