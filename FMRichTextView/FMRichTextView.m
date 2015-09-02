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
#import "UIFont+FMRichTextView.h"

@interface FMRichTextView ()
- (void)accessoryButtonTouchedUp:(UIButton *)button;
- (void)doneButtonTouchedUp:(UIBarButtonItem *)button;

@property (nonatomic, strong) FMRichTextViewToolbar *accessoryToolbar;
@property (nonatomic, strong) FMRichTextViewToolbarButton *boldButton;
@property (nonatomic, strong) FMRichTextViewToolbarButton *italicButton;
@property (nonatomic, strong) FMRichTextViewToolbarButton *underlineButton;

- (void)updateTextStyleInSelectedRange;
- (void)updateTypingAttributes;
@end

@implementation FMRichTextView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self)
	{
		_accessoryToolbar = [FMRichTextViewToolbar new];
		_accessoryToolbar.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame), 44.0f);
		
		_boldButton = [FMRichTextViewToolbarButton buttonWithType:UIButtonTypeCustom];
		[_boldButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"B" attributes:@{NSFontAttributeName: [UIFont fontWithType:FMRichTextViewFontTypeBold]}] forState:UIControlStateNormal];
		
		_italicButton = [FMRichTextViewToolbarButton buttonWithType:UIButtonTypeCustom];
		[_italicButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"I" attributes:@{NSFontAttributeName: [UIFont fontWithType:FMRichTextViewFontTypeItalic]}] forState:UIControlStateNormal];
		
		_underlineButton = [FMRichTextViewToolbarButton buttonWithType:UIButtonTypeCustom];
		[_underlineButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"U" attributes:@{NSFontAttributeName: [UIFont fontWithType:FMRichTextViewFontTypeNormal], NSUnderlineStyleAttributeName: @1}] forState:UIControlStateNormal];
		
		for (FMRichTextViewToolbarButton *button in @[_boldButton, _italicButton, _underlineButton])
		{
			button.frame = CGRectMake(0.0f, 0.0f, 32.0f, 32.0f);
			[button addTarget:self action:@selector(accessoryButtonTouchedUp:) forControlEvents:UIControlEventTouchUpInside];
		}
		
		_accessoryToolbar.items = @[[[UIBarButtonItem alloc] initWithCustomView:_boldButton],
									[[UIBarButtonItem alloc] initWithCustomView:_italicButton],
									[[UIBarButtonItem alloc] initWithCustomView:_underlineButton],
									[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
									[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTouchedUp:)]
									];
		
		self.inputAccessoryView = _accessoryToolbar;
		self.typingAttributes = @{NSFontAttributeName: [UIFont fontWithType:FMRichTextViewFontTypeNormal],
								  NSUnderlineStyleAttributeName: @0
								  };
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:self];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setTintColor:(UIColor *)tintColor
{
	[super setTintColor:tintColor];
	self.accessoryToolbar.tintColor = tintColor;
}

#pragma mark - Notification

- (void)textViewTextDidChangeNotification:(NSNotification *)notification
{
	[self updateTextStyleInSelectedRange];
}

#pragma mark - KVO

- (void)setSelectedTextRange:(UITextRange *)selectedTextRange
{
	[self updateTextStyleInSelectedRange];
	[super setSelectedTextRange:selectedTextRange];
}

- (void)updateTextStyleInSelectedRange
{
	// determine font style for selection or cursor position
	NSMutableArray *characterStyles = [NSMutableArray new];
	if (self.selectedRange.length > 0)
	{
		[self.attributedText enumerateAttributesInRange:self.selectedRange options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
			UIFont *font = attrs[NSFontAttributeName];
			NSNumber *underline = attrs[NSUnderlineStyleAttributeName];
			
			[characterStyles addObject:@{@"font": font, @"underline": underline, @"range": [NSValue valueWithRange:range]}];
		}];
	}
	else if (self.attributedText.length > 0)
	{
		// get text style of the previous character
		UIFont *font = [self.attributedText attribute:NSFontAttributeName atIndex:self.selectedRange.location - 1 effectiveRange:nil];
		NSNumber *underline = [self.attributedText attribute:NSUnderlineStyleAttributeName atIndex:self.selectedRange.location - 1 effectiveRange:nil];
		
		[characterStyles addObject:@{@"font": font, @"underline": underline}];
	}
	
	// toggle bold / italic button
	NSArray *differentFonts = [characterStyles valueForKeyPath:@"@distinctUnionOfObjects.font"];
	if ([differentFonts count] == 1)
	{
		UIFont *font = characterStyles.firstObject[@"font"];
		self.boldButton.selected = (font.fontType & FMRichTextViewFontTypeBold) > 0;
		self.italicButton.selected = (font.fontType & FMRichTextViewFontTypeItalic) > 0;
	}
	else
	{
		self.boldButton.selected = NO;
		self.italicButton.selected = NO;
	}
	
	// toggle underline button
	NSArray *differentUnderlineStyles = [characterStyles valueForKeyPath:@"@distinctUnionOfObjects.underline"];
	if ([differentUnderlineStyles count] == 1)
	{
		NSNumber *underline = characterStyles.firstObject[@"underline"];
		self.underlineButton.selected = underline.boolValue;
	}
	else
	{
		self.underlineButton.selected = NO;
	}
	
	// update typing attributes
	[self updateTypingAttributes];
}

- (void)updateTypingAttributes
{
	NSMutableDictionary *mutableTypingAttributes = [self.typingAttributes mutableCopy];
	mutableTypingAttributes[NSFontAttributeName] = [UIFont fontWithType:FMRichTextViewFontTypeNormal | (self.boldButton.selected ? FMRichTextViewFontTypeBold : 0) | (self.italicButton.selected ? FMRichTextViewFontTypeItalic : 0)];
	mutableTypingAttributes[NSUnderlineStyleAttributeName] = @(self.underlineButton.selected);
	
	self.typingAttributes = [NSDictionary dictionaryWithDictionary:mutableTypingAttributes];
}

#pragma mark - Buttons

- (void)doneButtonTouchedUp:(UIBarButtonItem *)button
{
	[self resignFirstResponder];
}

- (void)accessoryButtonTouchedUp:(UIButton *)button
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
		if (button == self.boldButton || button == self.italicButton)
		{
			FMRichTextViewFontType fontTypeForSenderButton = (button == self.boldButton ? FMRichTextViewFontTypeBold : FMRichTextViewFontTypeItalic);

			[self.attributedText enumerateAttribute:NSFontAttributeName inRange:selectedRange options:0 usingBlock:^(UIFont * font, NSRange range, BOOL *stop) {
				
				FMRichTextViewFontType type = font.fontType;
				if (button.isSelected)
				{
					type |= fontTypeForSenderButton;
				}
				else
				{
					type ^= fontTypeForSenderButton;
				}
				
				[attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithType:type] range:range];
			}];
		}
		else if (button == self.underlineButton)
		{
			[self.attributedText enumerateAttribute:NSUnderlineStyleAttributeName inRange:selectedRange options:0 usingBlock:^(NSNumber *underline, NSRange range, BOOL *stop) {
				[attributedString addAttribute:NSUnderlineStyleAttributeName value:@(button.isSelected) range:range];
			}];
		}
		
		self.attributedText = attributedString;
		self.selectedRange = selectedRange;
	}
}

@end
