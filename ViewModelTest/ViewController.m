//
//  ViewController.m
//  ViewModelTest
//
//  Created by D House on 10/18/14.
//  Copyright (c) 2014 AD60. All rights reserved.
//

#import "ViewController.h"

#import "VMViewViewModel.h"
#import "VMViewWithBlock.h"
#import "VMViewWithDelegate.h"

@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) VMViewViewModel *model;
@property (nonatomic, strong) VMViewWithBlock *vmViewWithBlock;
@property (nonatomic, strong) VMViewWithDelegate *vmViewWithDelegate;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    CGFloat tfInset = 20;
    UITextField *tf = [[UITextField alloc] init];
    tf.backgroundColor = [UIColor blueColor];
    tf.delegate = self;
    tf.frame = CGRectMake(tfInset,
                          tfInset,
                          self.view.frame.size.width - (2 * tfInset),
                          100);
    [self.view addSubview:tf];
    
    VMViewViewModel *model = [[VMViewViewModel alloc] init];
    self.model = model;

    // block style implementation
    VMViewWithBlock *vmViewWithBlock = [[VMViewWithBlock alloc] init];
    vmViewWithBlock.frame = CGRectMake(0,
                              CGRectGetMaxY(tf.frame),
                              self.view.frame.size.width,
                              100);
    [self.view addSubview:vmViewWithBlock];
    [vmViewWithBlock setViewModel:self.model];
    self.vmViewWithBlock = vmViewWithBlock;
    
    // delegate style implementation
    VMViewWithDelegate *vmViewWithDelegate = [[VMViewWithDelegate alloc] init];
    vmViewWithDelegate.frame = CGRectMake(0,
                              CGRectGetMaxY(vmViewWithBlock.frame),
                              self.view.frame.size.width,
                              100);
    [self.view addSubview:vmViewWithDelegate];
    self.model.updateDelegate = vmViewWithDelegate;
    self.vmViewWithDelegate = vmViewWithDelegate;

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
    tap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tap];
}

- (void)doubleTap {
    [self.vmViewWithBlock removeFromSuperview];
    self.vmViewWithBlock = nil;
    
    [self.vmViewWithDelegate removeFromSuperview];
    self.vmViewWithDelegate = nil;
    
    self.model = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.model.labelText = textField.text;
    return YES;
}

@end
