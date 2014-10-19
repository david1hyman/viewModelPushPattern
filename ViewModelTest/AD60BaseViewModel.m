//
//  AD60BaseViewModel.m
//  ViewModelTest
//
//  Created by D House on 10/18/14.
//  Copyright (c) 2014 AD60. All rights reserved.
//

#import "AD60BaseViewModel.h"
#import <objc/runtime.h>

static void * const AD60BaseViewModelKVOContext = (void*)&AD60BaseViewModelKVOContext;

@interface AD60BaseViewModel()

@property (nonatomic, assign) BOOL performingBatchUpdate;
@property (nonatomic, strong) NSMutableArray *keys;

@end

@implementation AD60BaseViewModel

+ (id)alloc {
    if ([NSStringFromClass(self.class) isEqual:@"AD60BaseViewModel"]) {
        NSLog(@"whadda ya want ya big dummy, this is an abstract class");
        exit(-1);
    }
    return [super alloc];
}

- (void)dealloc {
    for (NSString *keyPath in self.keys) {
        [self removeObserver:self
                  forKeyPath:keyPath
                     context:AD60BaseViewModelKVOContext];
    }
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self observeAllProperties];
    }
    
    return self;
}

- (void)observeAllProperties {
    self.keys = [NSMutableArray array];
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (size_t i = 0; i < count; ++i) {
        NSString *property = [NSString stringWithCString:property_getName(properties[i])
                                                encoding:NSASCIIStringEncoding];
        
        [self.keys addObject: property];
    }
    free(properties);
    
    for (NSString *keyPath in self.keys) {
        [self addObserver:self
               forKeyPath:keyPath
                  options:NSKeyValueObservingOptionNew
                  context:AD60BaseViewModelKVOContext];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == AD60BaseViewModelKVOContext) {
        [self doUpdate];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)setUpdateListener:(UpdateListener)updateListener {
    _updateListener = updateListener;
    
    // update the first time
    [self doUpdate];
}

- (void)setUpdateDelegate:(id<AD60ViewModelDelegate>)updateDelegate {
    _updateDelegate = updateDelegate;
    
    [self doUpdate];
}

- (void)removeUpdateListener {
    _updateListener = nil;
}

- (void)performBatchUpdatesWithBlock:(BatchUpdateBlock)updateBlock {
    self.performingBatchUpdate = YES;
    if (updateBlock) {
        updateBlock();
    }
    self.performingBatchUpdate = NO;
    [self doUpdate];
}

- (void)doUpdate {
    if (!self.performingBatchUpdate) {
        if (_updateListener) {
            __weak typeof(self) weakSelf = self;
            _updateListener(weakSelf);
        }
        if (self.updateDelegate) {
            [self.updateDelegate viewModelDidUpdate:self];
        }
    }
}

@end
