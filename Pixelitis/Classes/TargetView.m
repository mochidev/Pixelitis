//
//  TargetView.m
//  Pixelitis
//
//  Created by Dimitri Bouniol on 7/27/10.
//  Copyright (c) 2010 Mochi Development Inc. All rights reserved.
//

#import "TargetView.h"
#import "MiniTargetView.h"

@implementation TargetView

@synthesize miniTarget, color, nudging, selected, pixel;

- (id)initWithFrame:(CGRect)frame
{
	CGFloat scale = [[UIScreen mainScreen] scale];
	
	frame.size = CGSizeMake(64+1/scale, 64+1/scale);
	
    if ((self = [super initWithFrame:frame])) {
        self.transform = CGAffineTransformMakeScale(3, 3);
		self.alpha = 0;
		
		miniTarget = [[MiniTargetView alloc] init];
		
		target = [[UIImageView alloc] initWithFrame:self.bounds];
		target.image = [UIImage imageNamed:@"target.png"];
		target.highlightedImage = [UIImage imageNamed:@"targetSelected.png"];
		[self addSubview:target];
		[target release];
		
		spinner = [[UIImageView alloc] initWithFrame:self.bounds];
		spinner.image = [UIImage imageNamed:@"targetRotor.png"];
		[self addSubview:spinner];
		[spinner release];
    }
    return self;
}

- (void)setPixel:(CGPoint)aPoint
{
	pixel = aPoint;
	
	CGFloat scale = [[UIScreen mainScreen] scale];
	
	self.center = CGPointMake(pixel.x/scale+1./(2.*scale), pixel.y/scale+1./(2.*scale));
	
	miniTarget.pixel = pixel;
}

- (void)setColor:(TargetColor)aColor
{
	color = aColor;
	
	miniTarget.color = aColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setNudging:(BOOL)yn
{
	nudging = yn;
	
	target.highlighted = yn;
}

- (void)setSelected:(BOOL)yn
{
	selected = yn;
	
	if (selected) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationsEnabled:YES];
		[UIView setAnimationRepeatCount:CGFLOAT_MAX];
		[UIView setAnimationRepeatAutoreverses:NO];
		[UIView setAnimationDuration:1];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		
		spinner.transform = CGAffineTransformMakeRotation(-M_PI);
		
		[UIView commitAnimations];
	} else {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationsEnabled:YES];
		[UIView setAnimationRepeatCount:0];
		[UIView setAnimationDuration:0.25];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		
		spinner.transform = CGAffineTransformIdentity;
		
		[UIView commitAnimations];
	}
}

- (void)show
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	self.transform = CGAffineTransformIdentity;
	self.alpha = 1;
	
	[UIView commitAnimations];
}

- (void)dealloc
{
	[miniTarget release];
    [super dealloc];
}


@end
