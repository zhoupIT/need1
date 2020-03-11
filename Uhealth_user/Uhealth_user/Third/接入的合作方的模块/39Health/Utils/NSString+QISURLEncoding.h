//
//  NSString+QISURLEncoding.h
//  Ask
//
//  Created by xianyuxie on 10/9/14.
//  Copyright (c) 2014 SQN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QISURLEncoding)

// url encoded/decoded string
- (NSString*)urlDecodedString;
- (NSString*)urlEncodedString;

// CFStringEncoding
- (NSString*)urlDecodedStringUsingEncoding:(CFStringEncoding)encodeing;
- (NSString*)urlEncodedStringUsingEncoding:(CFStringEncoding)encodeing;

@end
