//
//  MiniTargetView.h
//  Pixelitis
//
//  Created by Dimitri Bouniol on 7/27/10.
//  Copyright (c) 2010 Mochi Development Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TargetView.h"

@interface MiniTargetView : UIView {
	TargetColor color;
	
	CGPoint pixel;
	
	UIImageView *target;
}

@property (nonatomic) TargetColor color;
@property (nonatomic) CGPoint pixel;

@end
