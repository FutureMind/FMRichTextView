//
//  FMRichTextViewToolbarButton.m
//  FMRichTextView
//
//  Created by Maciek Gierszewski on 02.09.2015.
//  Copyright (c) 2015 Future Mind sp. z o. o. All rights reserved.
//

#import "FMRichTextViewToolbarButton.h"

@interface FMRichTextViewToolbarButton ()
@property (nonatomic, readwrite) UIFontDescriptorSymbolicTraits fontDescriptorTrait;
@property (nonatomic, readwrite) id attributeName;
@property (nonatomic, readwrite) id normalValue;
@property (nonatomic, readwrite) id selectedValue;
@end

@implementation FMRichTextViewToolbarButton

+ (FMRichTextViewToolbarButton *)buttonWithAttributeName:(id)attributeName normalValue:(id)normalValue selectedValue:(id)selectedValue
{
	FMRichTextViewToolbarButton *button = [FMRichTextViewToolbarButton buttonWithType:UIButtonTypeCustom];
	button.attributeName = attributeName;
	button.normalValue = normalValue;
	button.selectedValue = selectedValue;
	
	return button;
}

+ (FMRichTextViewToolbarButton *)buttonWithFontDescriptorTrait:(UIFontDescriptorSymbolicTraits)trait
{
	FMRichTextViewToolbarButton *button = [FMRichTextViewToolbarButton buttonWithType:UIButtonTypeCustom];
	button.fontDescriptorTrait = trait;
	
	return button;
}

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		_fontDescriptorTrait = 0;
		_attributeName = nil;
		_normalValue = [NSNull null];
		_selectedValue = [NSNull null];
	}
	return self;
}

#pragma mark - Setters

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

- (void)setFont:(UIFont *)font
{
	self.titleLabel.font = font;
	
	[super setAttributedTitle:[self attributedTitleForState:UIControlStateNormal] forState:UIControlStateNormal];
	[super setAttributedTitle:[self attributedTitleForState:UIControlStateSelected] forState:UIControlStateSelected];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
	[super setTitleColor:color forState:state];
	[super setAttributedTitle:[self attributedTitleForState:state] forState:state];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
	[super setTitle:title forState:state];
	[super setAttributedTitle:[self attributedTitleForState:state] forState:state];
}

- (void)setAttributedTitle:(NSAttributedString *)title forState:(UIControlState)state
{
	[self setTitle:title.string forState:state];
}

#pragma mark - Getters

- (NSAttributedString *)attributedTitleForState:(UIControlState)state
{
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	attributes[NSForegroundColorAttributeName] = [self titleColorForState:state];
	attributes[NSFontAttributeName] = [UIFont fontWithDescriptor:[self.titleLabel.font.fontDescriptor fontDescriptorWithSymbolicTraits:self.fontDescriptorTrait] size:0.0];
	if (self.attributeName)
	{
		attributes[self.attributeName] = self.selectedValue;
	}
	
	return [[NSAttributedString alloc] initWithString:[self titleForState:state] ?: @"" attributes:attributes];
}

- (id)attributeValue
{
	return self.isSelected ? self.selectedValue : self.normalValue;
}

@end
