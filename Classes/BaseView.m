//
//  BaseView.m
//  NavTest
//
//  Created by David Fumberger on 4/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "BaseView.h"
#import "ViewData.h";

@implementation BaseView
@synthesize image;
@synthesize highlighted;
@synthesize viewData;
@synthesize subTitle;
@synthesize showImage;
@synthesize fetchImage;
@synthesize imageHeight;
@synthesize imageWidth;
@synthesize maxImageSize;
- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		// Initialization code
		self.backgroundColor = [UIColor whiteColor];
	}
	return self;
}

- (void)setHighlighted:(BOOL)lit {
	// If highlighted state changes, need to redisplay.
	if (highlighted != lit) {
		highlighted = lit;	
		[self setNeedsDisplay];
	}
}

- (void)drawRect:(CGRect)rect {
#define MAIN_FONT_SIZE 18
#define MAIN_TEXT_Y 11
	
#define MAIN_TEXT_Y_SUBTITLE 9
#define MAIN_FONT_SIZE_SUBTITLE 12
	
#define MIN_MAIN_FONT_SIZE 14
#define SECONDARY_FONT_SIZE 12
#define MIN_SECONDARY_FONT_SIZE 10
	
#define TEXT_COLUMN_OFFSET_IMAGE 55
#define TEXT_COLUMN_OFFSET 10
#define TEXT_COLUMN_WIDTH 250	
	
#define SECONDARY_TEXT_Y 23	
	
	CGRect contentRect = self.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGFloat boundsHeight = self.frame.size.height;	
	BOOL wideImage = NO;
	BOOL showText = YES;
	if (self.showImage) {
		UIImage *thumbimage = self.viewData.thumbnail_image;
		if (thumbimage) {
			CGImageRef imgRef = thumbimage.CGImage;
			CGFloat width = CGImageGetWidth(imgRef);
			CGFloat height = CGImageGetHeight(imgRef);			
			int x = 0;
			float aspect = height / width;
				
			//NSLog(@"Aspect Width [%f] Height [%f] %f", width, height, aspect);
			if (aspect < 0.20) {
				if (imageView) {
					imageView.image = nil;
				}
				wideImage = YES;
				CGPoint p = CGPointMake(x, 0);
				
				[thumbimage drawAtPoint:p];
				showText = NO;
				return;
			}
		} 
	}	
	
	
	
	//NSInteger mainTextY = MAIN_TEXT_Y;
	NSInteger mainTextY = (boundsHeight / 2) - (MAIN_FONT_SIZE / 2);	
	if (self.subTitle) {
		mainTextY = MAIN_TEXT_Y_SUBTITLE;
	} 
	
	NSInteger offset;
	if (self.showImage) {
		offset = imageWidth + TEXT_COLUMN_OFFSET;
		//TEXT_COLUMN_OFFSET_IMAGE;
	} else {
		offset = TEXT_COLUMN_OFFSET;
	}
	
	NSInteger textColumnWidth = self.bounds.size.width - offset;
	NSInteger mainFontSize;
	if (self.subTitle) {
		mainFontSize = MAIN_FONT_SIZE_SUBTITLE;
	} else {
		mainFontSize = MAIN_FONT_SIZE;
	}
	
	CGPoint point;
	
	// Color and font for the main text items (time zone name, time)
	UIColor *mainTextColor = nil;
	UIFont *mainFont = [UIFont boldSystemFontOfSize:mainFontSize];
	
	// Color and font for the secondary text items (GMT offset, day)
	UIColor *secondaryTextColor = nil;
	UIFont *secondaryFont = [UIFont systemFontOfSize:SECONDARY_FONT_SIZE];
	
	// Choose font color based on highlighted state.
	if (self.highlighted) {
		mainTextColor = [UIColor whiteColor];
		secondaryTextColor = [UIColor whiteColor];
	}
	else {
		mainTextColor = [UIColor blackColor];
		secondaryTextColor = [UIColor darkGrayColor];
		self.backgroundColor = [UIColor whiteColor];
	}
	
	
	[ mainTextColor set];
	
	NSString *albumName = [viewData.title copy];
	if (albumName) {
		point = CGPointMake(boundsX + offset, mainTextY);
		[albumName drawAtPoint:point forWidth:textColumnWidth withFont:mainFont minFontSize:MIN_MAIN_FONT_SIZE actualFontSize:NULL lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
	}
	
	if (self.subTitle) {
		//NSString *subTitle = albumData.artistTitle;
		point = CGPointMake(boundsX + offset, SECONDARY_TEXT_Y);
		[self.subTitle drawAtPoint:point forWidth:textColumnWidth withFont:secondaryFont minFontSize:SECONDARY_FONT_SIZE actualFontSize:nil lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentNone];
	}
	if (self.showImage && !wideImage) {
		if (!imageView) {
			CGRect imagesize = CGRectMake(0.0, 0.0,imageWidth,imageHeight);	
			imageView = [[UIImageView alloc] initWithFrame:imagesize];	
			[self addSubview:imageView];		
		}
		
		UIImage *thumbimage = self.viewData.thumbnail_image;
		if (thumbimage) {
			imageView.image = thumbimage; 
		} else {
			imageView.image = [self.viewData defaultImage];
		}
		
	}
	//[albumName release];
}


- (void)removeSubviews {
	// Remove any previous sub views
	int count = [self.subviews count];
	while(count--) {
		[[self.subviews objectAtIndex:count] removeFromSuperview];
	}
}

- (BOOL)updateImage {
	//if (self.viewData.checkedImage) {
	//	return NO;
	//} else {
		int maxres;
		if (maxImageSize) {
			maxres = maxImageSize;
		} else {
			maxres = (imageHeight > imageWidth) ? (imageHeight) : (imageWidth);
		//	maxres = imageHeight;
		}
		if (self.viewData && [self.viewData fetchThumbnail]) {
	//if ([self.viewData fetchThumbnailMaxRes:imageWidth]) {
			[self setNeedsDisplay];	
			return YES;

		}
	//}
	return NO;
}

- (void)dealloc {
	//NSLog(@"BaseView - dealloc");
	[image release];
	[viewData release];
	[subTitle release];
	[imageView release];
	[super dealloc];
}


@end
