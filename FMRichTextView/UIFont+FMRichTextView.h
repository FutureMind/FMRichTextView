//
//  UIFont+FMRichTextView.h
//  FMRichTextView
//
//  Created by Maciek Gierszewski on 02.09.2015.
//  Copyright (c) 2015 Future Mind sp. z o. o. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FMRichTextViewFontType)
{
	FMRichTextViewFontTypeNormal = 0x0,
	FMRichTextViewFontTypeBold = 0x1,
	FMRichTextViewFontTypeItalic = 0x2,
};

@interface UIFont (FMRichTextView)
+ (UIFont *)fontWithType:(FMRichTextViewFontType)type;

@property (nonatomic, readonly) FMRichTextViewFontType fontType;
@end
