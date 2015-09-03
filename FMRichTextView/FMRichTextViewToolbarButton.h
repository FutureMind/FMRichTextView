//
//  FMRichTextViewToolbarButton.h
//  FMRichTextView
//
//  Created by Maciek Gierszewski on 02.09.2015.
//  Copyright (c) 2015 Future Mind sp. z o. o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMRichTextViewToolbarButton : UIButton
@property (nonatomic, readonly) UIFontDescriptorSymbolicTraits fontDescriptorTrait;
@property (nonatomic, readonly) id attributeName;
@property (nonatomic, readonly) id attributeValue;

@property (nonatomic, readonly) id normalValue;
@property (nonatomic, readonly) id selectedValue;

@property (nonatomic, strong) UIColor *selectedBackgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *font UI_APPEARANCE_SELECTOR;

+ (FMRichTextViewToolbarButton *)buttonWithFontDescriptorTrait:(UIFontDescriptorSymbolicTraits)trait;
+ (FMRichTextViewToolbarButton *)buttonWithAttributeName:(id)attributeName normalValue:(id)value selectedValue:(id)value;
@end
