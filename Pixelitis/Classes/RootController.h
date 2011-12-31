//
//  RootController.h
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

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <AudioToolbox/AudioToolbox.h>
@class MainView;
@class TargetView;
@class InfoViewController;

@interface RootController : UIViewController <ADBannerViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate> {
    ADBannerView *ad;
	UIImageView *ipadAd;
	UIToolbar *toolbar;
	
	MainView *mainView;
	
	BOOL passthrough;
	
	CGPoint oldScrollerPosition;
	
	UIBarButtonItem *horizontalButton;
	UIBarButtonItem *verticalButton;
	
	UIAlertView *strokeAlertView;
	BOOL strokeAlertViewShown;
	
	float firstAidTimeout;
	NSTimer *firstAidTimeoutTimer;
	
	NSMutableSet *targets;
	TargetView *selectedTarget;
	BOOL draggingTarget;
	
	NSArray *baseMenuItems;
	NSArray *nudgeMenuItems;
	
	BOOL locked;
	
	UIImageView *lockImage;
	NSTimer *lockImageTimer;
	
	UIPopoverController *infoPopover;
	UINavigationController *infoNavigation;
	InfoViewController *infoViewController;
}

@property (nonatomic, retain) IBOutlet ADBannerView *ad;
@property (nonatomic, retain) IBOutlet UIImageView *ipadAd;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *horizontalButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *verticalButton;
@property (nonatomic, retain) MainView *mainView;
@property (nonatomic) BOOL passthrough;
@property (nonatomic) BOOL locked;

- (IBAction)handleTap:(id)sender;
- (IBAction)handleDoubleTap:(id)sender;
- (IBAction)handleShake:(id)sender;
- (IBAction)handleLongPress:(id)sender;
- (IBAction)handlePan:(id)sender;

- (IBAction)showFirstAid:(id)sender;
- (IBAction)showHorizontal:(id)sender;
- (IBAction)showFull:(id)sender;
- (IBAction)showVertical:(id)sender;
- (IBAction)showInfo:(id)sender;

- (IBAction)targetNudge:(id)sender;
- (IBAction)targetChangeColor:(id)sender;
- (IBAction)targetRemove:(id)sender;
- (IBAction)targetNudgeUp:(id)sender;
- (IBAction)targetNudgeDown:(id)sender;
- (IBAction)targetNudgeLeft:(id)sender;
- (IBAction)targetNudgeRight:(id)sender;

- (void)showiPadAd:(id)sender;

- (void)showBaseMenu;
- (void)showNudgeMenu;

- (BOOL)shouldHandleGesture:(UIGestureRecognizer *)gesture;

- (void)firstAidTimeoutTimerFired:(NSTimer *)aTimer;
- (void)updatePrefs;
- (void)saveTargetData;

- (void)removeFirstAidTimeoutTimer;
- (void)removeLockImageTimer;

@end
