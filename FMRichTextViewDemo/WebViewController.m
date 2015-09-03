//
//  WebViewController.m
//  FMRichTextView
//
//  Created by Maciek Gierszewski on 03.09.2015.
//  Copyright (c) 2015 Future Mind sp. z o. o. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.webView loadHTMLString:self.HTMLString baseURL:nil];
}

@end
