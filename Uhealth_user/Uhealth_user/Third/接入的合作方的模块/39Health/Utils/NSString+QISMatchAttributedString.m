//
//  NSString+QISMatchAttributedString.m
//  YYK
//
//  Created by xiexianyu on 1/14/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import "NSString+QISMatchAttributedString.h"

NSString * QISPercentEscapedStringFromString(NSString *string) {
    static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
    
    // FIXME: https://github.com/AFNetworking/AFNetworking/pull/3028
    // return [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < string.length) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wgnu"
        NSUInteger length = MIN(string.length - index, batchSize);
#pragma GCC diagnostic pop
        NSRange range = NSMakeRange(index, length);
        
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [string rangeOfComposedCharacterSequencesForRange:range];
        
        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    
    return escaped;
}


@implementation NSString (QISMatchAttributedString)

// text
- (NSAttributedString*)buildAttributedStringWithTextFont:(UIFont*)textFont
                                               textColor:(UIColor*)textColor
{
    if (self.length == 0) { // nil or ''
        return nil;
    }
    
    // default font and color
    if (textFont == nil) {
        textFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    if (textColor == nil) {
        textColor = [UIColor darkGrayColor];
    }
    
    NSDictionary *textAttributes = @{NSForegroundColorAttributeName:textColor, NSFontAttributeName:textFont};
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self attributes:textAttributes];
    return attrString;
}

// under line text
- (NSAttributedString*)buildUnderlineAttributedStringWithTextFont:(UIFont*)textFont
                                                        textColor:(UIColor*)textColor
{
    if (self.length == 0) { // nil or ''
        return nil;
    }
    
    // default font and color
    if (textFont == nil) {
        textFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    if (textColor == nil) {
        textColor = [UIColor darkGrayColor];
    }
    
    NSDictionary *textAttributes = @{NSForegroundColorAttributeName:textColor, NSFontAttributeName:textFont, NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self attributes:textAttributes];
    return attrString;
}

- (NSAttributedString*)buildAttributedStringWithKeyword:(NSString*)keyword
                                               textFont:(UIFont*)textFont
                                              textColor:(UIColor*)textColor
                                             matchColor:(UIColor*)matchColor
{
    if (self.length == 0) { // nil or ''
        return nil;
    }
    
    // default font and color
    if (textFont == nil) {
        textFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    if (textColor == nil) {
        textColor = [UIColor darkGrayColor];
    }
    if (matchColor == nil) {
        // orange color
        matchColor = [UIColor colorWithRed:255./255. green:195./255. blue:60./255. alpha:1.0];
    }
    
    NSMutableArray *ranges = [[NSMutableArray alloc] init]; //save all match range
    
    // scan match ranges
    NSScanner *scanner = [NSScanner scannerWithString:self];
    while ([keyword length] > 0 && ![scanner isAtEnd])
    {
        NSString *scanText = nil;
        BOOL didScan = [scanner scanUpToString:keyword intoString:&scanText];
        //DebugLog(@"scan location %ld, text %@", scanner.scanLocation, scanText);
        
        if (scanText.length > 0) { // did scan
            if (scanner.scanLocation < self.length) {
                // match
                NSValue *value = [NSValue valueWithRange:NSMakeRange(scanner.scanLocation, keyword.length)];
                [ranges addObject:value];
                
                scanner.scanLocation += keyword.length; //skip it
            }
        }
        else if (!didScan) {
            // matching at the begin
            NSValue *value = [NSValue valueWithRange:NSMakeRange(scanner.scanLocation, keyword.length)];
            [ranges addObject:value];
            
            scanner.scanLocation += keyword.length; // skip it
        }
    } //while
    
    // build attributed string
    
    NSMutableDictionary *attrsDictionary = [[NSMutableDictionary alloc] init];
    
    // Font
    [attrsDictionary setObject:textFont forKey:NSFontAttributeName];
    
    // Foreground color, text color
    [attrsDictionary setObject:textColor forKey:NSForegroundColorAttributeName];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self attributes:attrsDictionary];
    
    // match text attributed info
    for (NSValue *value in ranges) {
        NSRange range = [value rangeValue];
        [attrString addAttribute:NSForegroundColorAttributeName value:matchColor range:range];
    } //for
    
    return attrString;
}

- (NSAttributedString*)buildParagraphStyleAttributedStringWithColor:(UIColor*)color font:(UIFont*)font
{
    if (self.length == 0) {
        return nil;
    }
    
    NSAttributedString *attrString = [self buildParagraphStyleAttributedStringWithColor:color font:font lineSpace:0.0 paragraphSpace:8.0];
    return attrString;
}

- (NSAttributedString*)buildParagraphStyleAttributedStringWithColor:(UIColor*)color
                                                               font:(UIFont*)font
                                                          lineSpace:(CGFloat)lineSpace
                                                     paragraphSpace:(CGFloat)paragraphSpace
{
    if (self.length == 0) {
        return nil;
    }
    
    // trim at both sides
    NSString *baseString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.paragraphSpacing = paragraphSpace;
    NSDictionary *textAttributes = @{NSForegroundColorAttributeName:color, NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:baseString attributes:textAttributes];
    return attrString;
}

- (NSAttributedString*)buildParagraphStyleAttributedStringWithColor:(UIColor*)color
                                                               font:(UIFont*)font
                                                          lineSpace:(CGFloat)lineSpace
                                                     paragraphSpace:(CGFloat)paragraphSpace
                                                      lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    if (self.length == 0) {
        return nil;
    }
    
    // trim at both sides
    NSString *baseString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.paragraphSpacing = paragraphSpace;
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary *textAttributes = @{NSForegroundColorAttributeName:color, NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:baseString attributes:textAttributes];
    return attrString;
}

// link info
// default scheme is https
- (nullable NSAttributedString*)buildAttributedStringWithColor:(UIColor*)color
                                                          font:(UIFont*)font
                                                     textAlign:(NSTextAlignment)way
                                                     lineSpace:(CGFloat)lineSpace
                                                paragraphSpace:(CGFloat)paragraphSpace
                                                     linkInfos:(nullable NSArray*)linkInfos
                                                    linkScheme:(nullable NSString*)scheme
{
    if (self.length == 0) {
        return nil;
    }
    
    // trim at both sides
    NSString *baseString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = way;
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.paragraphSpacing = paragraphSpace;
    NSDictionary *textAttributes = @{NSForegroundColorAttributeName:color, NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    
    if ([linkInfos count] == 0) { // non link info
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:baseString attributes:textAttributes];
        return attrString;
    }
    
    // default scheme is https
    if (scheme.length == 0) {
        scheme = @"https";
    }
    
    // all text
    NSMutableAttributedString *allAttributedString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:textAttributes];
    
    NSMutableArray *matchInfos = [[NSMutableArray alloc] init];
    
    // scan match string
    for (NSDictionary *linkInfo in linkInfos) {
        NSString *matchString = nil;
        NSString *encodedLink = nil;
        
        NSString *matchWord = linkInfo[@"key"];
        if ([matchWord isKindOfClass:[NSString class]] && matchWord.length > 0 ) {
            matchString = matchWord;
        }
        
        NSString *link = linkInfo[@"href"];
        if ([link isKindOfClass:[NSString class]] && link.length > 0
            && [link hasPrefix:scheme]) {
            // net.39.yyk://39yyk/14/xxx
            // first decode url, then encode url, avoid can not create NSURL by link.
            NSString *decodeLink = [link stringByRemovingPercentEncoding];
            
            NSString *begin = [scheme stringByAppendingString:@"://"];
            NSString *part = [decodeLink stringByReplacingOccurrencesOfString:begin withString:@""];
            part =  QISPercentEscapedStringFromString(part); // avoid encode '://'
            encodedLink = [begin stringByAppendingString:part];
        }
        else { //skip it
            continue ;
        }
        
        // scan each link
        NSScanner *scanner = [NSScanner scannerWithString:baseString];
        while (![scanner isAtEnd])
        {
            NSRange range = NSMakeRange(0, NSNotFound);
            
            NSString *scanText = nil;
            BOOL didScan = [scanner scanUpToString:matchString intoString:&scanText];
            
            if (!didScan) {
                // match at the begin
                range = NSMakeRange(0, matchString.length);
                scanner.scanLocation += matchString.length; // skip it
            }
            else if (scanner.scanLocation < baseString.length) {
                // match
                range = NSMakeRange(scanner.scanLocation, matchString.length);
                scanner.scanLocation += matchString.length; // skip it
            }
            else {
                // not match, at the end of text.
                break;
            }
            
            // set attributed link
            if (range.length != NSNotFound) {
                NSValue *rangeValue = [NSValue valueWithRange:range];
                NSDictionary *matchInfo = @{@"link":encodedLink, @"range":rangeValue};
                [matchInfos addObject:matchInfo]; //save match location
                //[allAttributedString addAttribute:NSLinkAttributeName value:encodedLink range:range];
            }
        } //while
    }//for
    
    // remove small link,
    // such as '感冒冲剂'有'感冒'和'感冒冲剂'2个匹配，则保留最长的'感冒冲剂'
    NSMutableArray *remainMatchInfos = [[NSMutableArray alloc] init];
    for (NSDictionary *matchInfo in matchInfos) {
        NSValue *rangeValue = matchInfo[@"range"];
        NSRange range = [rangeValue rangeValue];
        
        BOOL isOK = YES;
        for (NSInteger index = 0; index<[remainMatchInfos count]; ++index) {
            NSDictionary *oldMatchInfo = remainMatchInfos[index];
            NSValue *oldRangeValue = oldMatchInfo[@"range"];
            NSRange oldRange = [oldRangeValue rangeValue];
            
            if (range.location == oldRange.location) {
                // some begin location
                isOK = NO;
                // keep long match
                if (range.length > oldRange.length) {
                    [remainMatchInfos replaceObjectAtIndex:index withObject:matchInfo];
                }
                break ;
            }
        }//for
        
        if (isOK) { //diffrent begin location
            [remainMatchInfos addObject:matchInfo];
        }
    }//for
    
    // set attributed link
    for (NSDictionary *matchInfo in remainMatchInfos) {
        NSString *encodedLink = matchInfo[@"link"];
        NSValue *rangeValue = matchInfo[@"range"];
        NSRange range = [rangeValue rangeValue];
        //
        [allAttributedString addAttribute:NSLinkAttributeName value:encodedLink range:range];
    } //for
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithAttributedString:allAttributedString];
    return attrString;
}


- (NSAttributedString*)buildParagraphStyleAttributedStringWithColor:(UIColor*)color
                                                               font:(UIFont*)font
                                                          lineSpace:(CGFloat)lineSpace
                                                     paragraphSpace:(CGFloat)paragraphSpace
                                                     showDeleteLine:(BOOL)isDisplay
{
    if (self.length == 0) {
        return nil;
    }
    
    // trim at both sides
    NSString *baseString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.paragraphSpacing = paragraphSpace;
    
    NSDictionary *textAttributes = nil;
    if (isDisplay) {
        textAttributes = @{NSForegroundColorAttributeName:color, NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle, NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)};
    }
    else {
        textAttributes = @{NSForegroundColorAttributeName:color, NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    }
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:baseString attributes:textAttributes];
    return attrString;
}

- (NSAttributedString*)buildParagraphStyleAttributedStringWithColor:(UIColor*)color
                                                               font:(UIFont*)font
                                                          lineSpace:(CGFloat)lineSpace
                                                     paragraphSpace:(CGFloat)paragraphSpace
                                                         matchColor:(UIColor*)matchColor
                                                         matchTexts:(NSArray*)keywords
{
    if (self.length == 0) {
        return nil;
    }
    
    // trim at both sides
    NSString *baseString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.paragraphSpacing = paragraphSpace;
    NSDictionary *textAttributes = @{NSForegroundColorAttributeName:color, NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    
    NSMutableArray *ranges = [[NSMutableArray alloc] init];
    for (NSString *keyword in keywords) {
        NSRange range = [self rangeOfString:keyword];
        NSValue *value = [NSValue valueWithRange:range];
        [ranges addObject:value];
    } //for
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:textAttributes];
    
    // match text attributed info
    for (NSValue *value in ranges) {
        NSRange range = [value rangeValue];
        [attrString addAttribute:NSForegroundColorAttributeName value:matchColor range:range];
    } //for
    
    return attrString;
}

@end
