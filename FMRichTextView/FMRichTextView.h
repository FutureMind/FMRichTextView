//
//  FMRichTextView.h
//  FMRichTextView
//
//  Created by Maciek Gierszewski on 02.09.2015.
//  Copyright (c) 2015 Future Mind sp. z o. o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMRichTextViewToolbar.h"

@interface FMRichTextView : UITextView
@property (nonatomic, readonly) FMRichTextViewToolbar *accessoryToolbar;
@end
