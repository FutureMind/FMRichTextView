//
//  FMRichTextView+HTMLString.h
//  FMRichTextView
//
//  Created by Maciek Gierszewski on 03.09.2015.
//  Copyright (c) 2015 Future Mind sp. z o. o. All rights reserved.
//

#import <FMRichTextView/FMRichTextView.h>

@interface FMRichTextView (HTMLString)
@property (nonatomic, readonly) NSString *HTMLString;
- (void)setHTMLString:(NSString *)HTMLString completionBlock:(void (^)(void))block;
@end
