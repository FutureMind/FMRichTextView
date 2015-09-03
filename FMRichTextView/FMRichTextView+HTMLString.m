//
//  FMRichTextView+HTMLString.m
//  FMRichTextView
//
//  Created by Maciek Gierszewski on 03.09.2015.
//  Copyright (c) 2015 Future Mind sp. z o. o. All rights reserved.
//

#import "FMRichTextView+HTMLString.h"

static NSString * const BoldTag = @"b";
static NSString * const ItalicTag = @"i";
static NSString * const UnderlineTag = @"u";

@implementation FMRichTextView (HTMLString)

- (NSString *)HTMLString
{
	NSMutableString *output = [NSMutableString stringWithString:@"<html><body>\n"];
	
	BOOL (^openCloseTag)(NSString *, BOOL, BOOL) = ^(NSString *tag, BOOL shouldOpen, BOOL isOpened) {
		if (shouldOpen && !isOpened)
		{
			[output appendFormat:@"<%@>", tag];
		}
		else if (!shouldOpen && isOpened)
		{
			[output appendFormat:@"</%@>", tag];
		}
		
		return shouldOpen;
	};
	
	__block BOOL underlineTagOpen = NO;
	__block BOOL boldTagOpen = NO;
	__block BOOL italicTagOpen = NO;
	
	[self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
		UIFont *font = attrs[NSFontAttributeName];
		BOOL bold = (font.fontDescriptor.symbolicTraits & UIFontDescriptorTraitBold) > 0;
		BOOL italic = (font.fontDescriptor.symbolicTraits & UIFontDescriptorTraitItalic) > 0;
		BOOL underline = [attrs[NSUnderlineStyleAttributeName] boolValue];
		
		underlineTagOpen = openCloseTag(UnderlineTag, underline, underlineTagOpen);
		boldTagOpen = openCloseTag(BoldTag, bold, boldTagOpen);
		italicTagOpen = openCloseTag(ItalicTag, italic, italicTagOpen);
		
		[output appendString:[self.attributedText.string substringWithRange:range]];
		
		underlineTagOpen = openCloseTag(UnderlineTag, NO, underlineTagOpen);
		boldTagOpen = openCloseTag(BoldTag, NO, boldTagOpen);
		italicTagOpen = openCloseTag(ItalicTag, NO, italicTagOpen);
		
		[output appendString:@"\n"];
		
		#warning HANDLE NEW LINES AND PARAGRAPHS!!!
	}];
	
	[output appendString:@"</body></html>"];
	return output;
}

@end
