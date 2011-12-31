//
//  TargetView.h
//  Pixelitis
//
//  Created by Dimitri Bouniol on 7/27/10.
//  Copyright (c) 2010 Mochi Development Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MiniTargetView;

typedef enum {
	TargetColorBlack,
	TargetColorWhite
} TargetColor;

@interface TargetView : UIView {
	MiniTargetView *miniTarget;
	TargetColor color;
	
	BOOL nudging;
	BOOL selected;
	
	CGPoint pixel;
	
	UIImageView *target;
	UIImageView *spinner;
}

@property (nonatomic, readonly) MiniTargetView *miniTarget;
@property (nonatomic) TargetColor color;
@property (nonatomic, getter=isNudging) BOOL nudging;
@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic) CGPoint pixel;

- (void)show;

@end
