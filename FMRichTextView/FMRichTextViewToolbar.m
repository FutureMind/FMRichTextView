//
//  FMRichTextViewToolbar.m
//  FMRichTextView
//
//  Created by Maciek Gierszewski on 02.09.2015.
//  Copyright (c) 2015 Future Mind sp. z o. o. All rights reserved.
//

#import "FMRichTextViewToolbar.h"
#import "FMRichTextViewToolbarButton.h"

@implementation FMRichTextViewToolbar

- (void)setTintColor:(UIColor *)tintColor
{
	[super setTintColor:tintColor];
	
	for (UIBarButtonItem *item in self.items)
	{
		item.customView.tintColor = tintColor;
	}
}

- (NSArray *)buttonsWithAttributeName;
{
	return [[self.items valueForKeyPath:@"customView"] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
		return [evaluatedObject isKindOfClass:[FMRichTextViewToolbarButton class]] && [(FMRichTextViewToolbarButton *)evaluatedObject attributeName] != nil;
	}]];
}

- (NSArray *)buttonsWithFontDescriptorTrait
{
	return [[self.items valueForKeyPath:@"customView"] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
		return [evaluatedObject isKindOfClass:[FMRichTextViewToolbarButton class]] && [(FMRichTextViewToolbarButton *)evaluatedObject attributeName] == nil;
	}]];
}

@end
