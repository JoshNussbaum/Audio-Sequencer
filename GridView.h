//
//  GridView.h
//  Audio Sequencer
//
//  Created by Josh on 3/1/15.
//  Copyright (c) 2015 Josh Nussbaum. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GridViewDelegate;

@interface GridView : UIView

@property (nonatomic, assign) IBOutlet id<GridViewDelegate> delegate;

@end

@protocol GridViewDelegate <NSObject>

- (NSUInteger) rowsForGridView:(GridView *)gridView;

- (NSUInteger) gridView:(GridView *)gridView columnsForRow:(NSUInteger)row;

- (void) gridView:(GridView *)gridView wasSelectedAtRow:(NSUInteger)row column:(NSUInteger)column;

- (BOOL) gridView:(GridView *)gridView isSelectedAtRow:(NSUInteger)row column:(NSUInteger)column;

@end
