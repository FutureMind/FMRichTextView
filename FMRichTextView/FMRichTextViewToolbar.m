//
//  FMRichTextViewToolbar.m
//  FMRichTextView
//
//  Created by Maciek Gierszewski on 02.09.2015.
//  Copyright (c) 2015 Future Mind sp. z o. o. All rights reserved.
//

#import "FMRichTextViewToolbar.h"

@implementation FMRichTextViewToolbar

- (void)setTintColor:(UIColor *)tintColor
{
	[super setTintColor:tintColor];
	
	for (UIBarButtonItem *item in self.items)
	{
		item.customView.tintColor = tintColor;
	}
}

@end
