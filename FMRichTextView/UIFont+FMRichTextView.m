//
//  UIFont+FMRichTextView.m
//  FMRichTextView
//
//  Created by Maciek Gierszewski on 02.09.2015.
//  Copyright (c) 2015 Future Mind sp. z o. o. All rights reserved.
//

#import "UIFont+FMRichTextView.h"

static CGFloat const DefaultFontSize = 16.0f;

static NSString * const NormalFontName = @"HelveticaNeue";
static NSString * const BoldFontName = @"HelveticaNeue-Bold";
static NSString * const ItalicFontName = @"HelveticaNeue-Italic";
static NSString * const BoldItalicFontName = @"HelveticaNeue-BoldItalic";

@implementation UIFont (FMRichTextView)

+ (UIFont *)fontWithType:(FMRichTextViewFontType)type
{
	BOOL bold = type & FMRichTextViewFontTypeBold;
	BOOL italic= type & FMRichTextViewFontTypeItalic;
	
	if (bold && italic)
	{
		return [UIFont fontWithName:BoldItalicFontName size:DefaultFontSize];
	}
	else if (bold)
	{
		return [UIFont fontWithName:BoldFontName size:DefaultFontSize];
	}
	else if (italic)
	{
		return [UIFont fontWithName:ItalicFontName size:DefaultFontSize];
	}
	
	return [UIFont fontWithName:NormalFontName size:DefaultFontSize];
}

- (FMRichTextViewFontType)fontType
{
	if ([self.fontName isEqualToString:BoldItalicFontName])
	{
		return FMRichTextViewFontTypeBold|FMRichTextViewFontTypeItalic;
	}
	else if ([self.fontName isEqualToString:BoldFontName])
	{
		return FMRichTextViewFontTypeBold;
	}
	else if ([self.fontName isEqualToString:ItalicFontName])
	{
		return FMRichTextViewFontTypeItalic;
	}
	
	return FMRichTextViewFontTypeNormal;
}

@end
