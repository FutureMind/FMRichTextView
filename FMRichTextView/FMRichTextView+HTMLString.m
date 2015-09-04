//
//  FMRichTextView+HTMLString.m
//  FMRichTextView
//
//  Created by Maciek Gierszewski on 03.09.2015.
//  Copyright (c) 2015 Future Mind sp. z o. o. All rights reserved.
//

#import "FMRichTextView+HTMLString.h"
#import "FMHTMLParser.h"

#define OPEN_TAG(flag, tag) if(flag){ [output appendFormat:@"<%@>", tag]; }
#define CLOSE_TAG(flag, tag) if(flag){ [output appendFormat:@"</%@>", tag]; }
#define NEW_LINE [output appendString:@"\n"]

@implementation FMRichTextView (HTMLString)

- (NSString *)HTMLString
{
	NSMutableString *output = [NSMutableString stringWithString:@""];
//	OPEN_TAG(YES, @"html");
//	OPEN_TAG(YES, @"body");
//	NEW_LINE;
	
	[self.attributedText.string enumerateSubstringsInRange:NSMakeRange(0, self.attributedText.string.length) options:NSStringEnumerationByParagraphs usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {

		OPEN_TAG(YES, HTMLParagraphTag);
		NEW_LINE;
		
		// enumerate substrings in paragraph
		NSAttributedString *paragraphAttributedString = [self.attributedText attributedSubstringFromRange:substringRange];
		[paragraphAttributedString enumerateAttributesInRange:NSMakeRange(0, paragraphAttributedString.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
			
			UIFont *font = attrs[NSFontAttributeName];
			BOOL bold = (font.fontDescriptor.symbolicTraits & UIFontDescriptorTraitBold) > 0;
			BOOL italic = (font.fontDescriptor.symbolicTraits & UIFontDescriptorTraitItalic) > 0;
			BOOL underline = [attrs[NSUnderlineStyleAttributeName] boolValue];
			
			OPEN_TAG(underline, HTMLUnderlineTag);
			OPEN_TAG(bold, HTMLBoldTag);
			OPEN_TAG(italic, HTMLItalicTag);
			
			[output appendString:[paragraphAttributedString.string substringWithRange:range]];
			
			CLOSE_TAG(italic, HTMLItalicTag);
			CLOSE_TAG(bold, HTMLBoldTag);
			CLOSE_TAG(underline, HTMLUnderlineTag);
			
			NEW_LINE;
		}];
		
		CLOSE_TAG(YES, HTMLParagraphTag);
		NEW_LINE;
	}];

//	CLOSE_TAG(YES, @"body");
//	CLOSE_TAG(YES, @"html");

	return output;
}

- (void)setHTMLString:(NSString *)HTMLString
{
	FMHTMLParser *parse = [[FMHTMLParser alloc] initWithHTML:HTMLString baseFont:self.font];
	self.attributedText = parse.attributedString;
}

@end
