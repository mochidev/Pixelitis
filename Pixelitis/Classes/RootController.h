//
//  RootController.h
//  Pixelitis
//
//  Created by Dimitri Bouniol on 7/25/10.
//  Copyright (c) 2010 Mochi Development Inc. All rights reserved.
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
