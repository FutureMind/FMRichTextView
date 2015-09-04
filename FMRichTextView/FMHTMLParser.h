//
//  FMXMLParsingOperation.h
//  FMRichTextView
//
//  Created by Maciek Gierszewski on 04.09.2015.
//  Copyright (c) 2015 Future Mind sp. z o. o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString * const HTMLBoldTag;
extern NSString * const HTMLItalicTag;
extern NSString * const HTMLUnderlineTag;
extern NSString * const HTMLParagraphTag;

@interface FMHTMLParser : NSObject<NSXMLParserDelegate>
@property (nonatomic, readonly) NSAttributedString *attributedString;

- (instancetype)initWithHTML:(NSString *)HTMLString baseFont:(UIFont *)font;
@end
