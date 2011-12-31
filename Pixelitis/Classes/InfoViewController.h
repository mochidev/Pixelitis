//
//  InfoViewController.h
//  Pixelitis
//
//  Created by Dimitri Bouniol on 7/28/10.
//  Copyright (c) 2010 Mochi Development Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfoViewController : UIViewController <UIWebViewDelegate> {
    UIWebView *webView;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
