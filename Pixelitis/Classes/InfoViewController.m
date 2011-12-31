//
//  InfoViewController.m
//  Pixelitis
//
//  Created by Dimitri Bouniol on 7/28/10.
//  Copyright (c) 2010 Mochi Development Inc. All rights reserved.
//

#import "InfoViewController.h"


@implementation InfoViewController

@synthesize webView;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:@"InfoViewController" bundle:nibBundleOrNil])) {
        // Custom initialization
		self.navigationItem.title = @"Information";
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"information" ofType:@"html"]]]];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.webView = nil;
}


- (void)dealloc
{
	self.webView = nil;
    [super dealloc];
}


@end
