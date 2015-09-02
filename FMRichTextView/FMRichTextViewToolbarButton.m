//
//  FMRichTextViewToolbarButton.m
//  FMRichTextView
//
//  Created by Maciek Gierszewski on 02.09.2015.
//  Copyright (c) 2015 Future Mind sp. z o. o. All rights reserved.
//

#import "FMRichTextViewToolbarButton.h"

@implementation FMRichTextViewToolbarButton

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		
	}
	return self;
}

- (void)setTintColor:(UIColor *)tintColor
{
	[super setTintColor:tintColor];
	
	self.selectedBackgroundColor = tintColor;
}

- (void)setSelectedBackgroundColor:(UIColor *)color
{
	CALayer *layer = [CALayer layer];
	layer.backgroundColor = color.CGColor;
	layer.cornerRadius = 4.0f;
	layer.frame = self.bounds;
	
	UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, 0.0f);
	[layer renderInContext:UIGraphicsGetCurrentContext()];
	[self setBackgroundImage:UIGraphicsGetImageFromCurrentImageContext() forState:UIControlStateSelected];
	UIGraphicsEndImageContext();
}

@end
