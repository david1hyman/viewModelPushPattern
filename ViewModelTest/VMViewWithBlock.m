//
//  VMView.m
//  ViewModelTest
//
//  Created by D House on 10/18/14.
//  Copyright (c) 2014 AD60. All rights reserved.
//

#import "VMViewWithBlock.h"
#import "VMViewViewModel.h"

@interface VMViewWithBlock()

@property (nonatomic, strong) UILabel *label;

@end

@implementation VMViewWithBlock

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
    self.label.backgroundColor = [UIColor redColor];
    self.label.font = [UIFont boldSystemFontOfSize:20];
    self.label.numberOfLines = 0;
    self.label.text = @"start";
    
    [self addSubview:self.label];
}

- (void)setViewModel:(VMViewViewModel *)viewModel {
    // always unsafe unretained
    // otherwise if viewModel is set to nil
    // crashland
    __weak typeof(self) weakSelf = self;
    [viewModel setUpdateListener:^(AD60BaseViewModel *viewModel) {
        VMViewViewModel *model = (VMViewViewModel *)viewModel;
        weakSelf.label.text = model.labelText;
    }];
}

@end
