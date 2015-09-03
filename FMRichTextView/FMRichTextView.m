//
//  FMRichTextView.m
//  FMRichTextView
//
//  Created by Maciek Gierszewski on 02.09.2015.
//  Copyright (c) 2015 Future Mind sp. z o. o. All rights reserved.
//

#import "FMRichTextView.h"
#import "FMRichTextViewToolbar.h"
#import "FMRichTextViewToolbarButton.h"
//#import "UIFont+FMRichTextView.h"

@interface FMRichTextView ()
@property (nonatomic, strong) FMRichTextViewToolbar *accessoryToolbar;

- (void)accessoryButtonTouchedUp:(FMRichTextViewToolbarButton *)button;
- (void)doneButtonTouchedUp:(UIBarButtonItem *)button;

- (void)updateTextStyleInSelectedRange;
- (void)updateTypingAttributes;
@end

@implementation FMRichTextView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self)
	{
		FMRichTextViewToolbarButton *boldButton = [FMRichTextViewToolbarButton buttonWithFontDescriptorTrait:UIFontDescriptorTraitBold];
		[boldButton setTitle:@"B" forState:UIControlStateNormal];
		
		FMRichTextViewToolbarButton italicButton = [FMRichTextViewToolbarButton buttonWithFontDescriptorTrait:UIFontDescriptorTraitItalic];
		[italicButton setTitle:@"I" forState:UIControlStateNormal];
		
		FMRichTextViewToolbarButton underlineButton = [FMRichTextViewToolbarButton buttonWithAttributeName:NSUnderlineStyleAttributeName normalValue:@0 selectedValue:@1];
		[underlineButton setTitle:@"U" forState:UIControlStateNormal];
		
		for (FMRichTextViewToolbarButton *button in @[boldButton, italicButton, underlineButton])
		{
			button.frame = CGRectMake(0.0f, 0.0f, 32.0f, 32.0f);
			[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			[button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
			[button addTarget:self action:@selector(accessoryButtonTouchedUp:) forControlEvents:UIControlEventTouchUpInside];
		}
		
		_accessoryToolbar = [FMRichTextViewToolbar new];
		_accessoryToolbar.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame), 44.0f);
		_accessoryToolbar.items = @[[[UIBarButtonItem alloc] initWithCustomView:boldButton],
									[[UIBarButtonItem alloc] initWithCustomView:italicButton],
									[[UIBarButtonItem alloc] initWithCustomView:underlineButton],
									[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
									[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTouchedUp:)]
									];
		
		self.font = [UIFont systemFontOfSize:16.0f];
		self.inputAccessoryView = _accessoryToolbar;

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:self];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setters

- (void)setTintColor:(UIColor *)tintColor
{
	[super setTintColor:tintColor];
	self.accessoryToolbar.tintColor = tintColor;
}

- (void)setFont:(UIFont *)font
{
	if (self.attributedText.length > 0)
	{
		// get the possible traits
		UIFontDescriptorSymbolicTraits traitsMask = 0;
		for (FMRichTextViewToolbarButton *button in self.accessoryToolbar.buttonsWithFontDescriptorTrait)
		{
			traitsMask |= button.fontDescriptorTrait;
		}
		
		// replace font in the current text
		NSMutableAttributedString *mutableAttributedText = [self.attributedText mutableCopy];
		[self.attributedText enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(UIFont *oldFont, NSRange range, BOOL *stop) {
			
			UIFontDescriptorSymbolicTraits traits = oldFont.fontDescriptor.symbolicTraits & traitsMask;
			UIFont *newFont = [UIFont fontWithDescriptor:[font.fontDescriptor fontDescriptorWithSymbolicTraits:traits] size:0.0f];
			
			[mutableAttributedText addAttribute:NSFontAttributeName value:newFont range:range];
		}];
		
		[super setFont:font];
		self.attributedText = mutableAttributedText;
	}
	else
	{
		[super setFont:font];
	}
	
	for (UIBarButtonItem *item in self.accessoryToolbar.items)
	{
		if ([item.customView isKindOfClass:[FMRichTextViewToolbarButton class]])
		{
			[(FMRichTextViewToolbarButton *)item.customView setFont:font];
		}
	}

	[self updateTextStyleInSelectedRange];
}

#pragma mark - Notification

- (void)textViewTextDidChangeNotification:(NSNotification *)notification
{
	[self updateTextStyleInSelectedRange];
}

#pragma mark - KVO

- (void)setSelectedTextRange:(UITextRange *)selectedTextRange
{
	[super setSelectedTextRange:selectedTextRange];
	[self updateTextStyleInSelectedRange];
}

- (void)updateTextStyleInSelectedRange
{
	// determine font style for selection or cursor position
	NSMutableArray *characterStyles = [NSMutableArray new];
	if (self.selectedRange.length > 0)
	{
		[self.attributedText enumerateAttributesInRange:self.selectedRange options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
			[characterStyles addObject:attrs];
		}];
	}
	else if (self.attributedText.length > 0)
	{
		// get text style of the previous character
		NSDictionary *attrs = [self.attributedText attributesAtIndex:self.selectedRange.location - 1 effectiveRange:nil];
		[characterStyles addObject:attrs];
	}
	
	// toggle font trait buttons
	NSArray *buttonsWithFontDescriptorTrait = self.accessoryToolbar.buttonsWithFontDescriptorTrait;
	NSArray *differentFonts = [characterStyles valueForKeyPath:[NSString stringWithFormat:@"@distinctUnionOfObjects.%@", NSFontAttributeName]];
	for (FMRichTextViewToolbarButton *button in buttonsWithFontDescriptorTrait)
	{
		// select if in the selection there is only one font and its trait matches button's font trait
		button.selected = ([differentFonts count] == 1) && ([characterStyles.firstObject[NSFontAttributeName] fontDescriptor].symbolicTraits & button.fontDescriptorTrait) > 0;
	}
	
	// toggle attribute buttons
	NSArray *buttonsWithAttributeName = self.accessoryToolbar.buttonsWithAttributeName;
	for (FMRichTextViewToolbarButton *button in buttonsWithAttributeName)
	{
		// select if in the selection there is only one style and its value matches button's selected attribute value
		NSArray *differentAttributes = [characterStyles valueForKeyPath:[NSString stringWithFormat:@"@distinctUnionOfObjects.%@", button.attributeName]];
		button.selected = ([differentFonts count] == 1) && [characterStyles.firstObject[button.attributeName] isEqual:button.selectedValue];
	}
	
	// update typing attributes
	[self updateTypingAttributes];
}

- (void)updateTypingAttributes
{
	NSMutableDictionary *mutableTypingAttributes = [self.typingAttributes mutableCopy];
	
	// enumerate buttons with font descriptor trait
	UIFontDescriptorSymbolicTraits traits = 0;

	NSArray *buttonsWithFontDescriptorTrait = self.accessoryToolbar.buttonsWithFontDescriptorTrait;
	for (FMRichTextViewToolbarButton *button in buttonsWithFontDescriptorTrait)
	{
		traits |= (button.isSelected ? button.fontDescriptorTrait : 0);
	}
	mutableTypingAttributes[NSFontAttributeName] = [UIFont fontWithDescriptor:[self.font.fontDescriptor fontDescriptorWithSymbolicTraits:traits] size:0.0f];

	// enumerate attribute buttons
	NSArray *buttonsWithAttributeName = self.accessoryToolbar.buttonsWithAttributeName;
	for (FMRichTextViewToolbarButton *button in buttonsWithAttributeName)
	{
		mutableTypingAttributes[button.attributeName] = button.attributeValue;
	}
	
	self.typingAttributes = [NSDictionary dictionaryWithDictionary:mutableTypingAttributes];
}

#pragma mark - Buttons

- (void)doneButtonTouchedUp:(UIBarButtonItem *)button
{
	[self resignFirstResponder];
}

- (void)accessoryButtonTouchedUp:(FMRichTextViewToolbarButton *)button
{
	button.selected = !button.selected;
	
	if (self.selectedRange.length == 0)
	{
		// text is not selected; update typing attributes
		[self updateTypingAttributes];
	}
	else
	{
		NSRange selectedRange = self.selectedRange;
		
		// add / remove font type to particular fragments of selected text
		NSMutableAttributedString *attributedString = [self.attributedText mutableCopy];
		if (button.attributeName)
		{
			[self.attributedText enumerateAttribute:button.attributeName inRange:selectedRange options:0 usingBlock:^(NSNumber *underline, NSRange range, BOOL *stop) {
				[attributedString addAttribute:NSUnderlineStyleAttributeName value:button.attributeValue range:range];
			}];
		}
		else
		{
			[self.attributedText enumerateAttribute:NSFontAttributeName inRange:selectedRange options:0 usingBlock:^(UIFont * font, NSRange range, BOOL *stop) {
				
				UIFontDescriptorSymbolicTraits traits = font.fontDescriptor.symbolicTraits;
				if (button.isSelected)
				{
					traits |= button.fontDescriptorTrait;
				}
				else
				{
					traits ^= button.fontDescriptorTrait;
				}
				
				UIFont *newFont = [UIFont fontWithDescriptor:[font.fontDescriptor fontDescriptorWithSymbolicTraits:traits] size:0.0f];
				[attributedString addAttribute:NSFontAttributeName value:newFont range:range];
			}];
			
		}
		
		self.attributedText = attributedString;
		self.selectedRange = selectedRange;
	}
}

@end
