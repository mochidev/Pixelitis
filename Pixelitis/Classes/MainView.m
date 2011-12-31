//
//  MainView.m
//  Pixelitis
//
//  Created by Dimitri Bouniol on 7/25/10.
//  Copyright (c) 2010 Mochi Development Inc. All rights reserved.
//

#import "MainView.h"
#import "TargetView.h"
#import "MiniTargetView.h"

@implementation MainView

@synthesize black, white, displayMode;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
		scroller = [[UIView alloc] initWithFrame:self.bounds];
		[self addSubview:scroller];
		[scroller release];
		
        self.black = YES;
		self.displayMode = DisplayModeFull;
		self.opaque = YES;
		
		targetViews = [[NSMutableSet alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    if ((self = [super initWithCoder:coder])) {
		scroller = [[UIView alloc] initWithFrame:self.bounds];
		[self addSubview:scroller];
		[scroller release];
		
        self.black = YES;
		self.displayMode = DisplayModeFull;
		self.opaque = YES;
		
		targetViews = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)setBlack:(BOOL)yn
{
	black = yn;
	white = !yn;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	if (displayMode == DisplayModeFull || displayMode == DisplayModeHorizontal || displayMode == DisplayModeVertical) {
		if (black) {
			self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
			scroller.backgroundColor = [UIColor blackColor];
		} else {
			self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
			scroller.backgroundColor = [UIColor whiteColor];
		}
	} else {
		self.backgroundColor = [UIColor blackColor];
	}
	
	[UIView commitAnimations];
}

- (void)setWhite:(BOOL)yn
{
	self.black = !yn;
}

- (void)removeFirstAid
{
	if (displayMode != DisplayModeFirstAid) {
		if (!firstAidViews) [firstAidViews release];
		firstAidViews = nil;
		
		[firstAidContainer removeFromSuperview];
		firstAidContainer = nil;
	}
}

- (void)setDisplayMode:(DisplayMode)aMode
{
	displayMode = aMode;
	
	/*if (displayMode == DisplayModeFirstAid && !firstAid) {
		NSMutableArray *images = [[NSMutableArray alloc] init];
		NSString *device = @"iPhone";
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			device = @"iPad";
		}
		
		for (int i = 1; i <= 10; i++) {
			[images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"FA%@%d.png", device, i]]];
		}
		
		firstAid = [[UIImageView alloc] initWithFrame:self.bounds];
		firstAid.image = [images objectAtIndex:0];
		firstAid.animationImages = images;
		firstAid.animationDuration = 0.2;
		firstAid.alpha = 0;
		[self insertSubview:firstAid aboveSubview:scroller];
		[firstAid release];
		
		[images release];
	}*/
	
	if (displayMode == DisplayModeFirstAid && !firstAidContainer) {
		NSMutableArray *images;
		CGFloat tileSize, k, j;
		UIImageView *firstAidView;
		
		firstAidContainer = [[UIView alloc] initWithFrame:self.bounds];
		firstAidContainer.backgroundColor = [UIColor blackColor];
		firstAidContainer.opaque = YES;
		firstAidContainer.alpha = 0;
		[self insertSubview:firstAidContainer aboveSubview:scroller];
		[firstAidContainer release];
		
		firstAidViews = [[NSMutableSet alloc] init];
		
		images = [[NSMutableArray alloc] init];
		
		for (int i = 1; i <= 10; i++) {
			[images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"FA%d.png", i]]];
		}
		
		tileSize = 100./[[UIScreen mainScreen] scale];
		
		for (k = 0; k < self.bounds.size.width; k += tileSize) {
			for (j = 0; j < self.bounds.size.height; j += tileSize) {
				firstAidView = [[UIImageView alloc] initWithFrame:CGRectMake(k, j, tileSize, tileSize)];
				firstAidView.image = [images objectAtIndex:0];
				firstAidView.animationImages = images;
				firstAidView.animationDuration = 0.2;
				[firstAidContainer addSubview:firstAidView];
				[firstAidViews addObject:firstAidView];
				[firstAidView release];
			}
		}
		
		[images release];
	}
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	if (displayMode == DisplayModeFirstAid) {
		self.backgroundColor = [UIColor blackColor];
		scroller.backgroundColor = [UIColor blackColor];
		
		firstAidContainer.alpha = 1;
		[self resume];
	} else if (displayMode == DisplayModeHorizontal) {
		scroller.frame = CGRectMake(0, self.bounds.size.height/2.-10, self.bounds.size.width, 20);
		
		firstAidContainer.alpha = 0;
		[self pause];
	} else if (displayMode == DisplayModeVertical) {
		scroller.frame = CGRectMake(self.bounds.size.width/2.-10, 0, 20, self.bounds.size.height);
		
		firstAidContainer.alpha = 0;
		[self pause];
	} else {
		displayMode = DisplayModeFull;
		
		scroller.frame = self.bounds;
		
		firstAidContainer.alpha = 0;
		[self pause];
	}
	
	self.black = black;
	
	[UIView commitAnimations];
}

- (void)pause
{
	for (UIImageView *firstAidView in firstAidViews) {
		[firstAidView stopAnimating];
	}
	
	for (TargetView *targetView in targetViews) {
		targetView.alpha = 1;
		targetView.miniTarget.alpha = 1;
	}
}

- (void)resume
{
	if (displayMode == DisplayModeFirstAid) {
		for (UIImageView *firstAidView in firstAidViews) {
			[firstAidView startAnimating];
		}
		
		for (TargetView *targetView in targetViews) {
			targetView.alpha = 0;
			targetView.miniTarget.alpha = 0;
		}
	}
}

- (void)setScrollerPosition:(CGPoint)scrollerPosition
{
	if (displayMode != DisplayModeHorizontal && displayMode != DisplayModeVertical) return;
	
	if (displayMode == DisplayModeHorizontal) {
		scrollerPosition.x = self.bounds.size.width/2.;
	} else if (displayMode == DisplayModeVertical) {
		scrollerPosition.y = self.bounds.size.height/2.;
	}
	
	if (scrollerPosition.x < 10) {
		scrollerPosition.x = 10;
	} else if (scrollerPosition.x > self.bounds.size.width-10) {
		scrollerPosition.x = self.bounds.size.width-10;
	}
	
	if (scrollerPosition.y < 10) {
		scrollerPosition.y = 10;
	} else if (scrollerPosition.y > self.bounds.size.height-10) {
		scrollerPosition.y = self.bounds.size.height-10;
	}
	
	scroller.center = scrollerPosition;
}

- (CGPoint)scrollerPosition
{
	return scroller.center;
}

- (void)addTargetView:(TargetView *)aTargetView
{
	if (firstAidContainer) {
		[self insertSubview:aTargetView aboveSubview:firstAidContainer];
	} else {
		[self insertSubview:aTargetView aboveSubview:scroller];
	}
	
	[targetViews addObject:aTargetView];
	
	[self addSubview:aTargetView.miniTarget];
	
	[aTargetView show];
}

- (void)removeTargetView:(TargetView *)aTargetView
{
	[aTargetView removeFromSuperview];
	[aTargetView.miniTarget removeFromSuperview];
	
	if ([targetViews containsObject:aTargetView]) {
		[targetViews removeObject:aTargetView];
	}
}

- (void)removeAllTargets
{
	for (TargetView *target in targetViews) {
		[target removeFromSuperview];
		[target.miniTarget removeFromSuperview];
	}
	
	[targetViews release];
	targetViews = [[NSMutableSet alloc] init];
}

- (void)dealloc
{
	[targetViews release];
	[self removeFirstAid];
    [super dealloc];
}


@end
