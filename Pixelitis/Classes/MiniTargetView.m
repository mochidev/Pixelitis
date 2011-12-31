//
//  MiniTargetView.m
//  Pixelitis
//
//  Created by Dimitri Bouniol on 7/27/10.
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
