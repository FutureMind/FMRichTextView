//
//  ViewController.m
//  FMRichTextView
//
//  Created by Maciek Gierszewski on 02.09.2015.
//  Copyright (c) 2015 Future Mind sp. z o. o. All rights reserved.
//

#import "ViewController.h"
#import "FMRichTextView+HTMLString.h"
#import "WebViewController.h"

@interface ViewController () <UITextViewDelegate>
@property (nonatomic, strong) IBOutlet FMRichTextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
//	self.textView.HTMLString = @"<p>abc <b>def&#160;<em>xyz<u>&#160;ijk</u></em></b></p>";
	self.textView.HTMLString = @"<p>\
	raz \
	<b>dwa </b>\
	</p>\
	<p>\
	<em>trzy cztery</em>\
	</p>\
	<p>\
	<u><em>piec</em></u>\
	</p>";
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	[self performSegueWithIdentifier:@"webView" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	WebViewController *webViewController = segue.destinationViewController;
	webViewController.HTMLString = self.textView.HTMLString;
}

@end
