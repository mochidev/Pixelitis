//
//  MainView.h
//  Pixelitis
//
//  Created by Dimitri Bouniol on 7/25/10.
//  Copyright (c) 2010 Mochi Development Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TargetView;
@class MiniTargetView;

typedef enum {
	DisplayModeFirstAid,
	DisplayModeHorizontal,
	DisplayModeFull,
	DisplayModeVertical
} DisplayMode;

@interface MainView : UIView {
	BOOL black;
	BOOL white;
	
	DisplayMode displayMode;
	
	UIView *scroller;
	
	UIView *firstAidContainer;
	NSMutableSet *firstAidViews;
	
	NSMutableSet *targetViews;
}

@property (nonatomic, getter=isBlack) BOOL black;
@property (nonatomic, getter=isWhite) BOOL white;
@property (nonatomic) DisplayMode displayMode;
@property (nonatomic) CGPoint scrollerPosition;

- (void)removeFirstAid;

- (void)pause;
- (void)resume;

- (void)addTargetView:(TargetView *)aTargetView;
- (void)removeTargetView:(TargetView *)aTargetView;
- (void)removeAllTargets;

@end
