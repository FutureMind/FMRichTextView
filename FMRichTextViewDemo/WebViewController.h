//
//  WebViewController.h
//  FMRichTextView
//
//  Created by Maciek Gierszewski on 03.09.2015.
//  Copyright (c) 2015 Future Mind sp. z o. o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (nonatomic, strong) NSString *HTMLString;

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@end
