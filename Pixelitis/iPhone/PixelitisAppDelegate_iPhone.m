//
//  PixelitisAppDelegate_iPhone.m
//  Pixelitis
//
//  Created by Dimitri Bouniol on 7/24/10.
//  Copyright (c) 2010 Mochi Development Inc. All rights reserved.
//

#import "PixelitisAppDelegate_iPhone.h"

@implementation PixelitisAppDelegate_iPhone


#pragma mark -
#pragma mark Application lifecycle




/**
 Superclass implementation saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	[super applicationWillTerminate:application];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
    [super applicationDidReceiveMemoryWarning:application];
}


- (void)dealloc {
	
	[super dealloc];
}


@end

