//
//  PixelitisAppDelegate.h
//  Pixelitis
//
//  Created by Dimitri Bouniol on 7/24/10.
//  Copyright (c) 2010 Mochi Development Inc. All rights reserved.
//


#import <UIKit/UIKit.h>
@class RootController;
@class MainView;

@interface PixelitisAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	RootController *rootController;
	MainView *mainView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainView *mainView;
@property (nonatomic, retain) RootController *rootController;


@end

