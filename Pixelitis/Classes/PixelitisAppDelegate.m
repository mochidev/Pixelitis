//
//  PixelitisAppDelegate.m
//  Pixelitis
//
//  Created by Dimitri Bouniol on 7/24/10.
//  Copyright (c) 2010 Mochi Development Inc. All rights reserved.
//


#import "PixelitisAppDelegate.h"
#import "RootController.h"
#import "MainView.h"

@implementation PixelitisAppDelegate

@synthesize window, rootController, mainView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
	
    // Override point for customization after application launch.
	
	rootController = [[RootController alloc] init];
	rootController.mainView = mainView;
	
	[window addSubview:rootController.view];
    [window makeKeyAndVisible];
	
	return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	[mainView pause];
	[rootController removeFirstAidTimeoutTimer];
	[rootController removeLockImageTimer];
	[rootController saveTargetData];
	
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	[rootController saveTargetData];
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
	//rootController.view.frame = [[UIScreen mainScreen] bounds];
	
	[mainView resume];
	[rootController updatePrefs];
	rootController.passthrough = NO;
	rootController.locked = NO;
	[rootController becomeFirstResponder];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[rootController saveTargetData];
	
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	// Save data if appropriate.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[rootController saveTargetData];
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc
{
	[rootController release];
	[window release];
	[mainView release];
    [super dealloc];
}

@end

