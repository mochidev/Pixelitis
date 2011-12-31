//
//  RootController.m
//  Pixelitis
//
//  Created by Dimitri Bouniol on 7/25/10.
//  Copyright (c) 2010 Mochi Development Inc. All rights reserved.
//
//  Copyright (c) 2010-11 Dimitri Bouniol, Mochi Development, Inc.
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software, associated artwork, and documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  1. The above copyright notice and this permission notice shall be included in
//     all copies or substantial portions of the Software.
//  2. Neither the name of Mochi Development, Inc. nor the names of its
//     contributors or products may be used to endorse or promote products
//     derived from this software without specific prior written permission.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//  
//  EleMints, the EleMints Icon, Pixelitis, Mochi Dev, and the Mochi Development logo are
//  copyright Mochi Development, Inc.
//

#import "RootController.h"
#import "MainView.h"
#import "TargetView.h"
#import "InfoViewController.h"

@implementation RootController

@synthesize ad, passthrough, toolbar, mainView, horizontalButton, verticalButton, locked, ipadAd;

+ (void)initialize
{
	[[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:1], @"StrokeWarning", [NSNumber numberWithFloat:3], @"FirstAidTimeout", [NSNumber numberWithBool:1], @"FirstTime", nil]];
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	NSString *nibName = @"RootController_iPhone";
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		nibName = @"RootController_iPad";
	}
	
    if ((self = [super initWithNibName:nibName bundle:nibBundleOrNil])) {
        self.wantsFullScreenLayout = YES;
		
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
		
		UIMenuItem *nudgeItem = [[UIMenuItem alloc] initWithTitle:@"Nudge" action:@selector(targetNudge:)];
		UIMenuItem *colorItem = [[UIMenuItem alloc] initWithTitle:@"Color" action:@selector(targetChangeColor:)];
		UIMenuItem *removeItem = [[UIMenuItem alloc] initWithTitle:@"Remove" action:@selector(targetRemove:)];
		
		baseMenuItems = [[NSArray alloc] initWithObjects:nudgeItem, colorItem, removeItem, nil];
		
		[nudgeItem release];
		[colorItem release];
		[removeItem release];
		
		UIMenuItem *nudgeUpItem = [[UIMenuItem alloc] initWithTitle:@"Up" action:@selector(targetNudgeUp:)];
		UIMenuItem *nudgeDownItem = [[UIMenuItem alloc] initWithTitle:@"Down" action:@selector(targetNudgeDown:)];
		UIMenuItem *nudgeLeftItem = [[UIMenuItem alloc] initWithTitle:@"Left" action:@selector(targetNudgeLeft:)];
		UIMenuItem *nudgeRightItem = [[UIMenuItem alloc] initWithTitle:@"Right" action:@selector(targetNudgeRight:)];
		
		nudgeMenuItems = [[NSArray alloc] initWithObjects:nudgeLeftItem, nudgeUpItem, nudgeDownItem, nudgeRightItem, nil];
		
		[nudgeUpItem release];
		[nudgeDownItem release];
		[nudgeLeftItem release];
		[nudgeRightItem release];
		
		[self updatePrefs];
    }
    return self;
}

- (void)updatePrefs
{
	strokeAlertViewShown = ![[NSUserDefaults standardUserDefaults] boolForKey:@"StrokeWarning"];
	firstAidTimeout = [[NSUserDefaults standardUserDefaults] floatForKey:@"FirstAidTimeout"];
	
	if (mainView) {
		[self removeFirstAidTimeoutTimer];
		if (firstAidTimeout > 0 && mainView.displayMode == DisplayModeFirstAid) {
			firstAidTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:firstAidTimeout
																	target:self
																  selector:@selector(firstAidTimeoutTimerFired:)
																  userInfo:nil repeats:NO];
		}
	}
	
	lockImage.alpha = 0;
}

- (void)setMainView:(MainView *)aView
{
	[aView retain];
	[mainView release];
	mainView = aView;
	
	[mainView removeAllTargets];
	[targets release];
	targets = [[NSMutableSet alloc] init];
	
	for (NSDictionary *targetDict in [[NSUserDefaults standardUserDefaults] arrayForKey:@"Targets"]) {
		TargetView *target = [[TargetView alloc] init];
		target.color = [[targetDict objectForKey:@"Color"] intValue];
		target.pixel = CGPointFromString([targetDict objectForKey:@"Pixel"]);
		
		[mainView addTargetView:target];
		[targets addObject:target];
		[target release];
	}
}

- (void)setLocked:(BOOL)yn
{
	if (yn != locked) {
		locked = yn;
		
		if (!lockImage) {
			lockImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
			lockImage.image = [UIImage imageNamed:@"unlock.png"];
			lockImage.highlightedImage = [UIImage imageNamed:@"lock.png"];
			lockImage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
			lockImage.center = CGPointMake(self.view.bounds.size.width/2., self.view.bounds.size.height/2.);
			[self.view addSubview:lockImage];
			[lockImage release];
		}
		
		lockImage.highlighted = locked;
		self.passthrough = locked;
		self.view.userInteractionEnabled = !locked;
		
		lockImage.alpha = 1;
		
		[self removeLockImageTimer];
		lockImageTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hideLockImage:) userInfo:nil repeats:NO];
		
		AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
	}
}

- (void)hideLockImage:(NSTimer *)sender
{
	lockImageTimer = nil;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:1];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	lockImage.alpha = 0;
	
	[UIView commitAnimations];
}

- (void)saveTargetData
{
	NSMutableArray *saveData = [[NSMutableArray alloc] init];
	
	for (TargetView *target in targets) {
		[saveData addObject:[NSDictionary dictionaryWithObjectsAndKeys:
											[NSNumber numberWithInt:target.color], @"Color",
											NSStringFromCGPoint(target.pixel), @"Pixel",
											nil]];
	}
	
	[[NSUserDefaults standardUserDefaults] setObject:saveData forKey:@"Targets"];
	
	[saveData release];
}

- (void)removeFirstAidTimeoutTimer
{
	if (firstAidTimeoutTimer) {
		[firstAidTimeoutTimer invalidate];
		firstAidTimeoutTimer = nil;
	}
}

- (void)removeLockImageTimer
{
	if (lockImageTimer) {
		[lockImageTimer invalidate];
		lockImageTimer = nil;
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)  {
		if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))  {
			ad.currentContentSizeIdentifier = ADBannerContentSizeIdentifier480x32;
		} else  {
			ad.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
		}
		ad.center = CGPointMake(ad.frame.size.width/2., -ad.frame.size.height/2.);
	}
	
	ipadAd.userInteractionEnabled = YES;
	
	UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
	UILongPressGestureRecognizer *pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
	
	pressGesture.delaysTouchesEnded = NO;
	pressGesture.delegate = self;
	
	panGesture.delaysTouchesEnded = NO;
	panGesture.delegate = self;
	
	doubleTapGesture.numberOfTapsRequired = 2;
	doubleTapGesture.delaysTouchesEnded = NO;
	doubleTapGesture.delegate = self;
	
	[tapGesture requireGestureRecognizerToFail:doubleTapGesture];
	tapGesture.delaysTouchesEnded = NO;
	tapGesture.delegate = self;
	
	//[panGesture requireGestureRecognizerToFail:tapGesture];
	
	[self.view addGestureRecognizer:doubleTapGesture];
	[self.view addGestureRecognizer:tapGesture];
	[self.view addGestureRecognizer:panGesture];
	[self.view addGestureRecognizer:pressGesture];
	[doubleTapGesture release];
	[tapGesture release];
	[panGesture release];
	[pressGesture release];
	
	if (ipadAd) {
		UITapGestureRecognizer *adTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showiPadAd:)];
		adTapGesture.delaysTouchesEnded = NO;
		[ipadAd addGestureRecognizer:adTapGesture];
		[adTapGesture release];
	}
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstTime"]) {
		[[NSUserDefaults standardUserDefaults] setBool:0 forKey:@"FirstTime"];
		[self performSelector:@selector(showInfo:) withObject:self afterDelay:0.25];
	}
}

- (BOOL)shouldHandleGesture:(UIGestureRecognizer *)gesture
{
	if (self.passthrough) {
		return YES;
	} else {
		CGPoint tapLocation = [gesture locationInView:self.view];
		CGRect okRect = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-64);
		if (ad.bannerLoaded) {
			okRect.origin.y += ad.frame.size.height;
			okRect.size.height -= ad.frame.size.height;
		}
		
		if (CGRectContainsPoint(okRect, tapLocation) && [self.view hitTest:tapLocation withEvent:nil] == self.view) {
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	if (self.passthrough) {
		return YES;
	} else {
		CGPoint tapLocation = [gestureRecognizer locationInView:self.view];
		CGRect okRect = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-64);
		if (ad.bannerLoaded) {
			okRect.origin.y += ad.frame.size.height;
			okRect.size.height -= ad.frame.size.height;
		}
		
		if (CGRectContainsPoint(okRect, tapLocation) && [self.view hitTest:tapLocation withEvent:nil] == self.view) {
			return YES;
		}
	}
	
	return NO;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)  {
		if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))  {
			ad.currentContentSizeIdentifier = ADBannerContentSizeIdentifier480x32;
		} else  {
			ad.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
		}
			
		
		if (self.passthrough || !ad.bannerLoaded) {
			ad.center = CGPointMake(ad.frame.size.width/2., -ad.frame.size.height/2.);
		} else if (ad.bannerLoaded) {
			ad.center = CGPointMake(ad.frame.size.width/2., 20+ad.frame.size.height/2.);
		}
	}
	
	if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
		horizontalButton.image = [UIImage imageNamed:@"horizontal.png"];
		verticalButton.image = [UIImage imageNamed:@"vertical.png"];
	} else {
		horizontalButton.image = [UIImage imageNamed:@"vertical.png"];
		verticalButton.image = [UIImage imageNamed:@"horizontal.png"];
	}
}

- (IBAction)handleTap:(UITapGestureRecognizer *)sender
{
	if (selectedTarget.selected) {
		selectedTarget.selected = NO;
		selectedTarget.nudging = NO;
		[[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
		selectedTarget = nil;
	}
	self.passthrough = !passthrough;
}

- (IBAction)handleDoubleTap:(UITapGestureRecognizer *)sender
{
	if (selectedTarget.selected) {
		selectedTarget.selected = NO;
		selectedTarget.nudging = NO;
		[[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
		selectedTarget = nil;
	}
	mainView.black = !mainView.black;
}

- (IBAction)handleShake:(id)sender
{
	if (selectedTarget.selected) {
		selectedTarget.selected = NO;
		selectedTarget.nudging = NO;
		[[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
		selectedTarget = nil;
	}
	self.locked = !locked;
}

- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)sender
{
	if (mainView.displayMode == DisplayModeFirstAid) return;
	
	CGPoint location = [sender locationInView:mainView];
	CGPoint pixel = location;
	
	CGFloat scale = [[UIScreen mainScreen] scale];
	
	pixel.x *= scale;
	pixel.y *= scale;
	
	TargetView *target;
	
	if (sender.state == UIGestureRecognizerStateBegan) {
		draggingTarget = NO;
		
		if (selectedTarget.selected) {
			selectedTarget.selected = NO;
			[[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
			selectedTarget = nil;
		}
		
		for (target in targets) {
			if (!selectedTarget) {
				if (fabsf(target.pixel.x - pixel.x) <= scale*22. && fabsf(target.pixel.y - pixel.y) <= scale*22.) {
					selectedTarget = target;
				}
			}
		}
		
		if (!selectedTarget) {
			target = [[TargetView alloc] init];
			if (mainView.black) {
				target.color = TargetColorBlack;
			} else {
				target.color = TargetColorWhite;
			}
			target.pixel = pixel;
			
			[mainView addTargetView:target];
			[targets addObject:target];
			selectedTarget = target;
			[target release];
		}
		
		selectedTarget.selected = YES;
		
	} else if (sender.state == UIGestureRecognizerStateChanged) {
		CGPoint oldPixel = selectedTarget.pixel;
		
		if (draggingTarget) {
			if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
				pixel.y -= scale*50.;
			} else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
				pixel.x += scale*50.;
			} else if (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
				pixel.y += scale*50.;
			} else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
				pixel.x -= scale*50.;
			}
			
			if (pixel.x < 0) pixel.x = 0;
			else if (pixel.x >= scale*mainView.bounds.size.width) pixel.x = scale*mainView.bounds.size.width-1.;
			
			if (pixel.y < 0) pixel.y = 0;
			else if (pixel.y >= scale*mainView.bounds.size.height) pixel.y = scale*mainView.bounds.size.height-1.;
			
			selectedTarget.pixel = pixel;
		} else if (fabsf(oldPixel.x - pixel.x) >= scale*15. || fabsf(oldPixel.y - pixel.y) >= scale*15.) {
			selectedTarget.selected = YES;
			selectedTarget.nudging = YES;
			
			if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
				pixel.y -= scale*50.;
			} else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
				pixel.x += scale*50.;
			} else if (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
				pixel.y += scale*50.;
			} else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
				pixel.x -= scale*50.;
			}
			
			if (pixel.x < 0) pixel.x = 0;
			else if (pixel.x >= scale*mainView.bounds.size.width) pixel.x = scale*mainView.bounds.size.width-1.;
			
			if (pixel.y < 0) pixel.y = 0;
			else if (pixel.y >= scale*mainView.bounds.size.height) pixel.y = scale*mainView.bounds.size.height-1.;
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDuration:0.25];
			[UIView setAnimationBeginsFromCurrentState:YES];
			
			selectedTarget.pixel = pixel;
			
			[UIView commitAnimations];
			
			draggingTarget = YES;
		}
	} else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
		selectedTarget.nudging = NO;
		[self saveTargetData];
		
		[self showBaseMenu];
	}
}

- (IBAction)targetNudge:(id)sender
{
	if (selectedTarget) {
		selectedTarget.nudging = YES;
		[self performSelector:@selector(showNudgeMenu) withObject:nil afterDelay:0.25];
	}
}


- (void)showBaseMenu
{
	if (selectedTarget && [self becomeFirstResponder]) {
		UIMenuController *menu = [UIMenuController sharedMenuController];
		
		[menu setTargetRect:[self.view convertRect:selectedTarget.frame fromView:mainView] inView:self.view];
		menu.menuItems = baseMenuItems;
		[menu setMenuVisible:YES animated:YES];
	} else {
		selectedTarget.selected = NO;
		selectedTarget = nil;
	}
}

- (void)showNudgeMenu
{
	if (selectedTarget && [self becomeFirstResponder]) {
		UIMenuController *menu = [UIMenuController sharedMenuController];
		
		[menu setTargetRect:[self.view convertRect:selectedTarget.frame fromView:mainView] inView:self.view];
		menu.menuItems = nudgeMenuItems;
		[menu setMenuVisible:YES animated:YES];
	} else {
		selectedTarget.selected = NO;
		selectedTarget = nil;
	}
}

- (IBAction)targetChangeColor:(id)sender
{
	if (selectedTarget) {
		if (selectedTarget.color == TargetColorBlack) {
			selectedTarget.color = TargetColorWhite;
		} else {
			selectedTarget.color = TargetColorBlack;
		}
		
		[self saveTargetData];
		
		[self performSelector:@selector(showBaseMenu) withObject:nil afterDelay:0.25];
	}
}

- (IBAction)targetRemove:(id)sender
{
	if (selectedTarget) {
		[targets removeObject:selectedTarget];
		[mainView removeTargetView:selectedTarget];
		selectedTarget = nil;
		
		[self saveTargetData];
	}
}

- (IBAction)targetNudgeUp:(id)sender
{
	if (selectedTarget) {
		CGPoint pixel = selectedTarget.pixel;
		
		if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
			pixel.y -= 1;
		} else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
			pixel.x += 1;
		} else if (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			pixel.y += 1;
		} else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
			pixel.x -= 1;
		}
		
		selectedTarget.pixel = pixel;
	
		[self saveTargetData];
		[self performSelector:@selector(showNudgeMenu) withObject:nil afterDelay:0.25];
	}
}

- (IBAction)targetNudgeDown:(id)sender
{
	if (selectedTarget) {
		CGPoint pixel = selectedTarget.pixel;
		
		if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
			pixel.y += 1;
		} else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
			pixel.x -= 1;
		} else if (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			pixel.y -= 1;
		} else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
			pixel.x += 1;
		}
		
		selectedTarget.pixel = pixel;
		
		[self saveTargetData];
		[self performSelector:@selector(showNudgeMenu) withObject:nil afterDelay:0.25];
	}
}

- (IBAction)targetNudgeLeft:(id)sender
{
	if (selectedTarget) {
		CGPoint pixel = selectedTarget.pixel;
		
		if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
			pixel.x -= 1;
		} else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
			pixel.y -= 1;
		} else if (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			pixel.x += 1;
		} else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
			pixel.y += 1;
		}
		
		selectedTarget.pixel = pixel;
		
		[self saveTargetData];
		[self performSelector:@selector(showNudgeMenu) withObject:nil afterDelay:0.25];
	}
}

- (IBAction)targetNudgeRight:(id)sender
{
	if (selectedTarget) {
		CGPoint pixel = selectedTarget.pixel;
		
		if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
			pixel.x += 1;
		} else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
			pixel.y += 1;
		} else if (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			pixel.x -= 1;
		} else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
			pixel.y -= 1;
		}
		
		selectedTarget.pixel = pixel;
		
		[self saveTargetData];
		[self performSelector:@selector(showNudgeMenu) withObject:nil afterDelay:0.25];
	}
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	if (motion == UIEventSubtypeMotionShake) {
		[self handleShake:self];
	}
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)sender
{
	if (selectedTarget.selected) {
		selectedTarget.selected = NO;
		selectedTarget.nudging = NO;
		[[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
		selectedTarget = nil;
	}
	if (sender.state == UIGestureRecognizerStateBegan) {
		oldScrollerPosition = mainView.scrollerPosition;
		self.passthrough = YES;
	} else {
		CGPoint translation = [sender translationInView:mainView];
		
		mainView.scrollerPosition = CGPointMake(oldScrollerPosition.x + translation.x, oldScrollerPosition.y + translation.y);
	}
}

- (IBAction)showFirstAid:(id)sender
{
	if (infoPopover.popoverVisible) {
		[infoPopover dismissPopoverAnimated:YES];
		return;
	}
	
	if (selectedTarget.selected) {
		selectedTarget.selected = NO;
		selectedTarget.nudging = NO;
		[[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
		selectedTarget = nil;
	}
	if (strokeAlertViewShown) {
		if (mainView.displayMode == DisplayModeFirstAid) {
			[self removeFirstAidTimeoutTimer];
			mainView.displayMode = DisplayModeFull;
		} else {
			mainView.displayMode = DisplayModeFirstAid;
			self.passthrough = YES;
			
			[self removeFirstAidTimeoutTimer];
			if (firstAidTimeout > 0) {
				firstAidTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:firstAidTimeout target:self selector:@selector(firstAidTimeoutTimerFired:) userInfo:nil repeats:NO];
			}
		}
	} else {
		strokeAlertView = [[UIAlertView alloc] initWithTitle:@"Stroke Warning" message:@"The First Aid function briefly displays flashing lights to alleviate pixel related issues, and may cause stroke and/or headaches for certain individuals.\nPlease continue at your own risk." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
		
		[strokeAlertView show];
	}
}

- (void)firstAidTimeoutTimerFired:(NSTimer *)aTimer
{
	firstAidTimeoutTimer = nil;
	if (mainView.displayMode == DisplayModeFirstAid) {
		self.passthrough = NO;
		[self showFull:self];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView == strokeAlertView) {
		if (buttonIndex == 1) {
			strokeAlertViewShown = YES;
			[self showFirstAid:self];
		}
	} else {
		if (buttonIndex == 1)
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://elemintsapp.com/?Pixelitis"]];
	}
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[alertView release];
}

- (IBAction)showHorizontal:(id)sender
{
	if (infoPopover.popoverVisible) {
		[infoPopover dismissPopoverAnimated:YES];
		return;
	}
	
	[self removeFirstAidTimeoutTimer];
	if (mainView.displayMode == DisplayModeHorizontal) {
		mainView.black = !mainView.black;
	} else {
		mainView.displayMode = DisplayModeHorizontal;
	}
}

- (IBAction)showFull:(id)sender
{
	if (infoPopover.popoverVisible) {
		[infoPopover dismissPopoverAnimated:YES];
		return;
	}
	
	[self removeFirstAidTimeoutTimer];
	if (mainView.displayMode == DisplayModeFull) {
		mainView.black = !mainView.black;
	} else {
		mainView.displayMode = DisplayModeFull;
	}
}

- (IBAction)showVertical:(id)sender
{
	if (infoPopover.popoverVisible) {
		[infoPopover dismissPopoverAnimated:YES];
		return;
	}
	
	[self removeFirstAidTimeoutTimer];
	if (mainView.displayMode == DisplayModeVertical) {
		mainView.black = !mainView.black;
	} else {
		mainView.displayMode = DisplayModeVertical;
	}
}

- (IBAction)showInfo:(id)sender
{
	mainView.displayMode = DisplayModeFull;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		if (!infoPopover) {
			infoViewController = [[InfoViewController alloc] init];
			//infoViewController.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissInfo:)] autorelease];
			infoNavigation = [[UINavigationController alloc] initWithRootViewController:infoViewController];
			[infoViewController release];
			
			infoPopover = [[UIPopoverController alloc] initWithContentViewController:infoNavigation];
			infoPopover.popoverContentSize = CGSizeMake(320, 480);
			[infoNavigation release];
		}
		
		[infoPopover presentPopoverFromBarButtonItem:[toolbar.items lastObject] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	} else {
		if (!infoNavigation) {
			infoViewController = [[InfoViewController alloc] init];
			infoViewController.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissInfo:)] autorelease];
			infoNavigation = [[UINavigationController alloc] initWithRootViewController:infoViewController];
			infoNavigation.navigationBar.barStyle = UIBarStyleBlack;
			[infoViewController release];
		}
		
		[self presentModalViewController:infoNavigation animated:YES];
	}
}

- (void)dismissInfo:(id)sender
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[infoPopover dismissPopoverAnimated:YES];
	} else {
		[self dismissModalViewControllerAnimated:YES];
	}
}

- (void)setPassthrough:(BOOL)yn
{
	passthrough = yn;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.35];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	if (passthrough) {
		ad.center = CGPointMake(ad.frame.size.width/2., -ad.frame.size.height/2.);
		ipadAd.center = CGPointMake(ipadAd.frame.size.width/2., -ipadAd.frame.size.height/2.);
		toolbar.center = CGPointMake(toolbar.frame.size.width/2., self.view.bounds.size.height+toolbar.frame.size.height/2.);
		[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
	} else {
		if (ad.bannerLoaded) {
			ad.center = CGPointMake(ad.frame.size.width/2., 20+ad.frame.size.height/2.);
		}
		ipadAd.center = CGPointMake(ipadAd.frame.size.width/2., 20+ipadAd.frame.size.height/2.);
		toolbar.center = CGPointMake(toolbar.frame.size.width/2., self.view.bounds.size.height-toolbar.frame.size.height/2.);
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
	}
	
	[UIView commitAnimations];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	[UIView beginAnimations:@"animateAdBannerOn" context:NULL];
	if (self.passthrough) {
		ad.center = CGPointMake(ad.frame.size.width/2., -ad.frame.size.height/2.);
	} else {
		ad.center = CGPointMake(ad.frame.size.width/2., 20+ad.frame.size.height/2.);
	}
	[UIView commitAnimations];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	[UIView beginAnimations:@"animateAdBannerOff" context:NULL];
	ad.center = CGPointMake(ad.frame.size.width/2., -ad.frame.size.height/2.);
	[UIView commitAnimations];
}

- (void)showiPadAd:(UIGestureRecognizer *)sender
{
	if (sender.state == UIGestureRecognizerStateRecognized) {
		UIAlertView *iPadAdAlertView = [[UIAlertView alloc] initWithTitle:@"EleMints Website" message:@"Are you sure you want to leave Pixelitis and go to the EleMints Website?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Do It!", nil];
		
		[iPadAdAlertView show];
	}
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
	return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
	[mainView removeFirstAid];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[infoPopover release];
		infoPopover = nil;
	} else {
		[infoNavigation release];
		infoNavigation = nil;
	}
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	self.ad = nil;
	self.ipadAd = nil;
	self.toolbar = nil;
	self.horizontalButton = nil;
	self.verticalButton = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[infoPopover release];
		infoPopover = nil;
	} else {
		[infoNavigation release];
		infoNavigation = nil;
	}
	[baseMenuItems release];
	[nudgeMenuItems release];
	[targets release];
	self.horizontalButton = nil;
	self.verticalButton = nil;
	self.mainView = nil;
	self.toolbar = nil;
	self.ad = nil;
	self.ipadAd = nil;
	[self removeFirstAidTimeoutTimer];
	[self removeLockImageTimer];
    [super dealloc];
}


@end
