//
//  MiniTargetView.m
//  Pixelitis
//
//  Created by Dimitri Bouniol on 7/27/10.
//  Copyright (c) 2010 Mochi Development Inc. All rights reserved.
//

#import "MiniTargetView.h"


@implementation MiniTargetView

@synthesize color, pixel;

- (id)initWithFrame:(CGRect)frame
{
	CGFloat scale = [[UIScreen mainScreen] scale];
	
	frame.size = CGSizeMake(6+1/scale, 6+1/scale);
	
    if ((self = [super initWithFrame:frame])) {
        target = [[UIImageView alloc] initWithFrame:self.bounds];
		target.image = [UIImage imageNamed:@"minitargetBlack.png"];
		target.highlightedImage = [UIImage imageNamed:@"minitargetWhite.png"];
		[self addSubview:target];
		[target release];
    }
    return self;
}

- (void)setPixel:(CGPoint)aPoint
{
	pixel = aPoint;
	
	CGFloat scale = [[UIScreen mainScreen] scale];
	
	self.center = CGPointMake(pixel.x/scale+1./(2.*scale), pixel.y/scale+1./(2.*scale));
}

- (void)setColor:(TargetColor)aColor
{
	color = aColor;
	
	if (color == TargetColorBlack) {
		target.highlighted = NO;
	} else {
		target.highlighted = YES;
	}
}

- (void)dealloc
{
    [super dealloc];
}


@end
