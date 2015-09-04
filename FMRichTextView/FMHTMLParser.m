//
//  FMXMLParsingOperation.m
//  FMRichTextView
//
//  Created by Maciek Gierszewski on 04.09.2015.
//  Copyright (c) 2015 Future Mind sp. z o. o. All rights reserved.
//

#import "FMHTMLParser.h"

NSString * const HTMLBoldTag = @"b";
NSString * const HTMLItalicTag = @"em";
NSString * const HTMLUnderlineTag = @"u";
NSString * const HTMLParagraphTag = @"p";

@interface FMHTMLParser ()
@property (nonatomic, strong) NSXMLParser *parser;

@property (nonatomic, strong) UIFont *baseFont;
@property (nonatomic, strong) NSMutableAttributedString *mutableAttributedString;
@property (nonatomic, strong) NSMutableString *charactersBuffer;
@property (nonatomic, strong) NSMutableDictionary *attributes;

- (void)flushBuffer;
@end

@implementation FMHTMLParser

- (instancetype)initWithHTML:(NSString *)HTMLString baseFont:(UIFont *)font
{
	self = [super init];
	if (self)
	{
		_baseFont = font;
		_mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:@"" attributes:nil];
		_charactersBuffer = [NSMutableString new];
		_attributes = [NSMutableDictionary dictionaryWithDictionary:@{NSFontAttributeName: self.baseFont,
																	  NSUnderlineStyleAttributeName: @0
																	  }];

		NSData *HTMLData = [[NSString stringWithFormat:@"<html>%@</html>", HTMLString] dataUsingEncoding:NSUTF8StringEncoding];
		
		_parser = [[NSXMLParser alloc] initWithData:HTMLData];
		_parser.delegate = self;
		[_parser parse];
	}
	return self;
}

#pragma mark - Getters

- (NSAttributedString *)attributedString
{
	return [[NSAttributedString alloc] initWithAttributedString:self.mutableAttributedString];
}

#pragma mark - Actions

- (void)flushBuffer
{
	// append the buffer to the output
	if (self.charactersBuffer.length > 0)
	{
		NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.charactersBuffer attributes:self.attributes];
		[self.mutableAttributedString appendAttributedString:attributedString];
		
		// clear the buffer
		[self.charactersBuffer deleteCharactersInRange:NSMakeRange(0, self.charactersBuffer.length)];
	}
}

#pragma mark - NSXMLParser

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:HTMLParagraphTag])
	{
		return;
	}

	// flush buffer before style change
	[self flushBuffer];
	
	// style change
	if ([elementName isEqualToString:HTMLBoldTag])
	{
		UIFontDescriptorSymbolicTraits traits = [self.attributes[NSFontAttributeName] fontDescriptor].symbolicTraits | UIFontDescriptorTraitBold;
		self.attributes[NSFontAttributeName] = [UIFont fontWithDescriptor:[self.baseFont.fontDescriptor fontDescriptorWithSymbolicTraits:traits] size:0.0f] ?: self.baseFont;
	}
	else if ([elementName isEqualToString:HTMLItalicTag])
	{
		UIFontDescriptorSymbolicTraits traits = [self.attributes[NSFontAttributeName] fontDescriptor].symbolicTraits | UIFontDescriptorTraitItalic;
		self.attributes[NSFontAttributeName] = [UIFont fontWithDescriptor:[self.baseFont.fontDescriptor fontDescriptorWithSymbolicTraits:traits] size:0.0f] ?: self.baseFont;
	}
	else if ([elementName isEqualToString:HTMLUnderlineTag])
	{
		self.attributes[NSUnderlineStyleAttributeName] = @1;
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:HTMLParagraphTag])
	{
		// append newline
		[self.charactersBuffer appendString:@"\n"];
	}

	// flush buffer after appending \n and/or before style change
	[self flushBuffer];
	
	if ([elementName isEqualToString:HTMLBoldTag])
	{
		UIFontDescriptorSymbolicTraits traits = [self.attributes[NSFontAttributeName] fontDescriptor].symbolicTraits ^ UIFontDescriptorTraitBold;
		self.attributes[NSFontAttributeName] = [UIFont fontWithDescriptor:[self.baseFont.fontDescriptor fontDescriptorWithSymbolicTraits:traits] size:0.0f] ?: self.baseFont;
	}
	else if ([elementName isEqualToString:HTMLItalicTag])
	{
		UIFontDescriptorSymbolicTraits traits = [self.attributes[NSFontAttributeName] fontDescriptor].symbolicTraits ^ UIFontDescriptorTraitItalic;
		self.attributes[NSFontAttributeName] = [UIFont fontWithDescriptor:[self.baseFont.fontDescriptor fontDescriptorWithSymbolicTraits:traits] size:0.0f] ?: self.baseFont;
	}
	else if ([elementName isEqualToString:HTMLUnderlineTag])
	{
		self.attributes[NSUnderlineStyleAttributeName] = @0;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"\t\n\r"];
	[self.charactersBuffer appendString:[string stringByTrimmingCharactersInSet:characterSet]];
}

@end
