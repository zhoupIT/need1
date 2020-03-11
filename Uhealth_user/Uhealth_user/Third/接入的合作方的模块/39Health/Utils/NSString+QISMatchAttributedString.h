//
//  NSString+QISMatchAttributedString.h
//  YYK
//
//  Created by xiexianyu on 1/14/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (QISMatchAttributedString)

// text
- (NSAttributedString*)buildAttributedStringWithTextFont:(UIFont*)textFont
                                               textColor:(UIColor*)textColor;

// link text


// under line text
- (NSAttributedString*)buildUnderlineAttributedStringWithTextFont:(UIFont*)textFont
                                                        textColor:(UIColor*)textColor;

// highlight one text
- (NSAttributedString*)buildAttributedStringWithKeyword:(NSString*)keyword
                                               textFont:(UIFont*)textFont
                                              textColor:(UIColor*)textColor
                                             matchColor:(UIColor*)matchColor;

// lineSpace 0.0 and paragraphSpace 8.0
- (NSAttributedString*)buildParagraphStyleAttributedStringWithColor:(UIColor*)color font:(UIFont*)font;
//
- (NSAttributedString*)buildParagraphStyleAttributedStringWithColor:(UIColor*)color
                                                               font:(UIFont*)font
                                                          lineSpace:(CGFloat)lineSpace
                                                     paragraphSpace:(CGFloat)paragraphSpace;

// custom line break mode
- (NSAttributedString*)buildParagraphStyleAttributedStringWithColor:(UIColor*)color
                                                               font:(UIFont*)font
                                                          lineSpace:(CGFloat)lineSpace
                                                     paragraphSpace:(CGFloat)paragraphSpace
                                                      lineBreakMode:(NSLineBreakMode)lineBreakMode;

// link info
// default scheme is https
- (nullable NSAttributedString*)buildAttributedStringWithColor:(UIColor*)color
                                                          font:(UIFont*)font
                                                     textAlign:(NSTextAlignment)way
                                                     lineSpace:(CGFloat)lineSpace
                                                paragraphSpace:(CGFloat)paragraphSpace
                                                     linkInfos:(nullable NSArray*)linkInfos
                                                    linkScheme:(nullable NSString*)scheme;

// delete line
- (NSAttributedString*)buildParagraphStyleAttributedStringWithColor:(UIColor*)color
                                                               font:(UIFont*)font
                                                          lineSpace:(CGFloat)lineSpace
                                                     paragraphSpace:(CGFloat)paragraphSpace
                                                     showDeleteLine:(BOOL)isDisplay;

// highlight text list
- (NSAttributedString*)buildParagraphStyleAttributedStringWithColor:(UIColor*)color
                                                               font:(UIFont*)font
                                                          lineSpace:(CGFloat)lineSpace
                                                     paragraphSpace:(CGFloat)paragraphSpace
                                                         matchColor:(UIColor*)matchColor
                                                         matchTexts:(NSArray*)keywords;


@end

NS_ASSUME_NONNULL_END
