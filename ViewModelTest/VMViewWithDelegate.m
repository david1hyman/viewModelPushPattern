//
//  VMViewWithDelegate.m
//  ViewModelTest
//
//  Created by D House on 10/19/14.
//  Copyright (c) 2014 AD60. All rights reserved.
//

#import "VMViewWithDelegate.h"
#import "VMViewViewModel.h"

@interface VMViewWithDelegate()

@property (nonatomic, strong) UILabel *label;

@end

@implementation VMViewWithDelegate

- (void)dealloc {
    // must call removeUpdateListener and set to nil here
    //    [self.viewModel removeUpdateListener];
    //    self.viewModel = nil;
}

- (instancetype)init {
    self = [super init];
    
    [self setup];
    
    return self;
}

- (void)setup {
    self.label = [[UILabel alloc] init];
    self.label.frame = self.bounds;
    self.label.autoresizingMask = (
                                   UIViewAutoresizingFlexibleWidth
                                   | UIViewAutoresizingFlexibleHeight
                                   );
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.backgroundColor = [UIColor orangeColor];
    self.label.font = [UIFont boldSystemFontOfSize:20];
    self.label.numberOfLines = 0;
    self.label.text = @"start";
    
    [self addSubview:self.label];
}

- (void)viewModelDidUpdate:(AD60BaseViewModel *)viewModel {
    VMViewViewModel *model = (VMViewViewModel *)viewModel;
    self.label.text = model.labelText;
}

@end
