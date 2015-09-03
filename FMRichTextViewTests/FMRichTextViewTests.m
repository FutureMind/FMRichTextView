//
//  FMRichTextViewTests.m
//  FMRichTextViewTests
//
//  Created by Maciek Gierszewski on 02.09.2015.
//  Copyright (c) 2015 Future Mind sp. z o. o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "UIFont+FMRichTextView.h"

@interface FMRichTextViewTests : XCTestCase

@end

@implementation FMRichTextViewTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFont
{
	UIFont *boldItalic = [UIFont fontWithType:FMRichTextViewFontTypeBold|FMRichTextViewFontTypeItalic];
	UIFont *bold = [UIFont fontWithType:FMRichTextViewFontTypeBold];
	UIFont *italic = [UIFont fontWithType:FMRichTextViewFontTypeItalic];
	UIFont *normal = [UIFont fontWithType:FMRichTextViewFontTypeNormal];
	
	XCTAssertNotNil(boldItalic);
	XCTAssertNotNil(bold);
	XCTAssertNotNil(italic);
	XCTAssertNotNil(normal);
}

@end
