//
//  AD60BaseViewModel.h
//  ViewModelTest
//
//  Created by D House on 10/18/14.
//  Copyright (c) 2014 AD60. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AD60BaseViewModel;

@protocol AD60ViewModelDelegate <NSObject>
- (void)viewModelDidUpdate:(AD60BaseViewModel *)viewModel;
@end

typedef void (^UpdateListener)(AD60BaseViewModel *viewModel);
typedef void (^BatchUpdateBlock)(void);

// This totally dope pattern does the following
// The viewModel (self) listens (via KVO) for changes to any of it's properties
// Any time it hears a change, it notifies a view to which it has a reference
// either by block or delegate.
// SO... updating the viewModel automatically updates the view!

// Also, any time the updateListener or updateDelegate gets set
// it triggers an update, so an instance of the model can be used for different views or view instances
// for example, in a tableView

@interface AD60BaseViewModel : NSObject

@property (nonatomic, strong) UpdateListener updateListener;
@property (nonatomic, weak) id <AD60ViewModelDelegate>updateDelegate;

// the UpdateListener will be a block in the the view whose viewModel is self
// each time a property of the viewModel changes
// updateLister() will get called
// telling the view to update it's display based on the updated viewModel
- (void)setUpdateListener:(UpdateListener)updateListener;

// this method isn't strictly necessary
// BUT
// if you are having retain cycle issues (view or viewModel (or both) will not dealloc
// you might try calling this in the dealloc of your view
- (void)removeUpdateListener;

// updates performed in this block will not trigger the updateListener
// until the block is finished
// prevents the view from updating when you are updating multiple properties on the viewModel
- (void)performBatchUpdatesWithBlock:(BatchUpdateBlock)updateBlock;

@end
