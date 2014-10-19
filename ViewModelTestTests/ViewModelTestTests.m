//
//  ViewModelTestTests.m
//  ViewModelTestTests
//
//  Created by D House on 10/18/14.
//  Copyright (c) 2014 AD60. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "VMViewViewModel.h"
#import "VMViewWithBlock.h"
#import "VMViewWithDelegate.h"

@interface VMViewWithBlock()
@property (nonatomic, strong) UILabel *label;
@end

@interface VMViewWithDelegate()
@property (nonatomic, strong) UILabel *label;
@end

@interface ViewModelTestTests : XCTestCase

@end

@implementation ViewModelTestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_01_blockImplementation_initialSet {
    VMViewViewModel *model = [[VMViewViewModel alloc] init];
    model.labelText = @"whatever";
    
    VMViewWithBlock *vmView = [[VMViewWithBlock alloc] init];
    [vmView setViewModel:model];
    
    XCTAssertNotNil(model.labelText);
    XCTAssertNotNil(vmView.label.text);
    XCTAssertEqualObjects(model.labelText, vmView.label.text);
}

- (void)test_02_blockImplementation_initialSet_thenUpdate {
    VMViewViewModel *model = [[VMViewViewModel alloc] init];
    model.labelText = @"whatever";
    
    VMViewWithBlock *vmView = [[VMViewWithBlock alloc] init];
    [vmView setViewModel:model];
    
    XCTAssertNotNil(model.labelText);
    XCTAssertNotNil(vmView.label.text);
    
    XCTAssertEqualObjects(model.labelText, vmView.label.text);
    
    model.labelText = @"now what?";
    XCTAssertEqualObjects(model.labelText, vmView.label.text);
}

- (void)test_03_delegateImplementation_initialSet {
    VMViewViewModel *model = [[VMViewViewModel alloc] init];
    model.labelText = @"whatever";
    
    VMViewWithDelegate *vmView = [[VMViewWithDelegate alloc] init];
    model.updateDelegate = vmView;
    
    XCTAssertNotNil(model.labelText);
    XCTAssertNotNil(vmView.label.text);
    XCTAssertEqualObjects(model.labelText, vmView.label.text);
}

- (void)test_04_delegateImplementation_initialSet_thenUpdate {
    VMViewViewModel *model = [[VMViewViewModel alloc] init];
    model.labelText = @"whatever";
    
    VMViewWithDelegate *vmView = [[VMViewWithDelegate alloc] init];
    model.updateDelegate = vmView;
    
    XCTAssertNotNil(model.labelText);
    XCTAssertNotNil(vmView.label.text);
    XCTAssertEqualObjects(model.labelText, vmView.label.text);

    model.labelText = @"now what?";
    XCTAssertEqualObjects(model.labelText, vmView.label.text);
}

- (void)test_05_batchUpdates {
    VMViewViewModel *model = [[VMViewViewModel alloc] init];
    model.labelText = @"whatever";
    
    VMViewWithDelegate *vmView = [[VMViewWithDelegate alloc] init];
    model.updateDelegate = vmView;
    
    XCTAssertNotNil(model.labelText);
    XCTAssertNotNil(vmView.label.text);
    XCTAssertEqualObjects(model.labelText, vmView.label.text);

    // batch updates
    // doesn't actually update til the end of the block
    // normally you would update mutliple model properties here
    // and the view would only update once
    // instead of every time you update a model property
    // this is a bs way of testing it
    // but it's accurate
    [model performBatchUpdatesWithBlock:^{
        model.labelText = @"1";
        XCTAssertNotEqualObjects(model.labelText, vmView.label.text);
        model.labelText = @"2";
        XCTAssertNotEqualObjects(model.labelText, vmView.label.text);
        model.labelText = @"3";
        XCTAssertNotEqualObjects(model.labelText, vmView.label.text);
        model.labelText = @"4";
    }];
    XCTAssertEqualObjects(model.labelText, vmView.label.text);
}

- (void)test_06_changeView {
    VMViewViewModel *model = [[VMViewViewModel alloc] init];
    model.labelText = @"whatever";
    
    VMViewWithDelegate *vmView1 = [[VMViewWithDelegate alloc] init];
    model.updateDelegate = vmView1;
    
    XCTAssertNotNil(model.labelText);
    XCTAssertNotNil(vmView1.label.text);
    XCTAssertEqualObjects(model.labelText, vmView1.label.text);

    VMViewWithDelegate *vmView2 = [[VMViewWithDelegate alloc] init];
    model.updateDelegate = vmView2;
    
    XCTAssertEqualObjects(vmView1.label.text, vmView2.label.text);

    model.labelText = @"now what?";
    
    XCTAssertNotEqualObjects(model.labelText, vmView1.label.text);
    XCTAssertEqualObjects(model.labelText, vmView2.label.text);
}

@end
