//
//  BaseView.m
//  NavTest
//
//  Created by David Fumberger on 4/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "TVCellView.h"
#import "ViewData.h";



#define MAIN_FONT_SIZE 18
#define MAIN_TEXT_Y 20

#define MAIN_TEXT_Y_SUBTITLE 8
#define MAIN_FONT_SIZE_SUBTITLE 12

#define MIN_MAIN_FONT_SIZE 14
#define SECONDARY_FONT_SIZE 12
#define MIN_SECONDARY_FONT_SIZE 10

#define TEXT_COLUMN_OFFSET_IMAGE 10
#define TEXT_COLUMN_OFFSET 10
#define TEXT_COLUMN_WIDTH 250	

#define SECONDARY_TEXT_Y 23	

@implementation TVCellView

@synthesize viewData;
@synthesize subTitle;
@synthesize showImage;
@synthesize defaultImage;
@synthesize highlighted;
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
	BOOL shadow = NO;
	BOOL mainTitle = YES;
	NSInteger mainFontSize;
	if (self.subTitle) {
		mainFontSize = MAIN_FONT_SIZE_SUBTITLE;
	} else {
		mainFontSize = MAIN_FONT_SIZE;
	}
	
	
	NSInteger offset;
	// Color and font for the main text items (time zone name, time)
	UIColor *mainTextColor = [UIColor blackColor];
	UIColor *shadowTextColor = [UIColor grayColor];
	UIFont *mainFont = [UIFont boldSystemFontOfSize:mainFontSize];
	UIFont *shadowFont = [UIFont boldSystemFontOfSize:mainFontSize];
	
	// Color and font for the secondary text items (GMT offset, day)
	UIColor *secondaryTextColor = nil;
	UIFont *secondaryFont = [UIFont systemFontOfSize:SECONDARY_FONT_SIZE];
	
	
	if (self.showImage) {
		int count = [self.subviews count];
		UIImage *image;
		/*UIImageView *imageview;
		if (count > 0) {
			imageview = [self.subviews objectAtIndex:0];
		} else {
			CGRect imagesize = CGRectMake(0.0, 0.0,325, 50);	
			imageview = [[UIImageView alloc] initWithFrame:imagesize];	
		}
		*/
		if (self.viewData.thumbnail_image != nil) {
			//self.backgroundColor = [UIColor blackColor];
			//[self setNeedsLayout];
			 image = self.viewData.thumbnail_image;
			 
			CGImageRef imgRef = image.CGImage;
			CGFloat width = CGImageGetWidth(imgRef);
			//CGFloat height = CGImageGetHeight(imgRef);
			
			int x = 0;
			if (width < 320) {
				mainTitle = YES;
				//x = 320 - width;
			} else {
				mainTitle = NO;
				CGPoint p = CGPointMake(x, 0);
				[image drawAtPoint:p];
				mainTextColor = [UIColor whiteColor];
				offset = TEXT_COLUMN_OFFSET_IMAGE;
				//shadow = YES;
			}
		} 
		/*if (count == 0) {
			NSLog(@"Adding subview");
			[self addSubview:imageview];
		}*/

	}	
	
	NSInteger mainTextY = MAIN_TEXT_Y;
	if (self.subTitle) {
		mainTextY = MAIN_TEXT_Y_SUBTITLE;
	} 

	if (self.showImage) {
		secondaryTextColor = [UIColor darkGrayColor];
		//self.backgroundColor = [UIColor blackColor];
	} else {
		mainTextColor = [UIColor blackColor];
		secondaryTextColor = [UIColor darkGrayColor];
		//self.backgroundColor = [UIColor whiteColor];
		offset = TEXT_COLUMN_OFFSET;
	}

	
	
	

	// Choose font color based on highlighted state.
	/*(if (self.highlighted) {
		mainTextColor = [UIColor whiteColor];
		secondaryTextColor = [UIColor whiteColor];
	}*/
	//else {

	//}
	CGRect contentRect = self.bounds;
	CGFloat boundsX = contentRect.origin.x;
	
	
	NSString *albumName = [viewData.title copy];
	

	CGPoint point = CGPointMake(boundsX + offset, mainTextY);
	CGPoint shadowpoint = CGPointMake(point.x + 1, point.y + 1);

	if (shadow) {
		[ shadowTextColor set];
		[albumName drawAtPoint:shadowpoint forWidth:TEXT_COLUMN_WIDTH withFont:mainFont minFontSize:MIN_MAIN_FONT_SIZE actualFontSize:NULL lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
	}
	
	if (mainTitle) {
		[ mainTextColor set];
		[albumName drawAtPoint:point forWidth:TEXT_COLUMN_WIDTH withFont:mainFont minFontSize:MIN_MAIN_FONT_SIZE actualFontSize:NULL lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
	}
	
	if (self.subTitle) {
		point = CGPointMake(boundsX + offset, SECONDARY_TEXT_Y);
		[self.subTitle drawAtPoint:point forWidth:TEXT_COLUMN_WIDTH withFont:secondaryFont minFontSize:SECONDARY_FONT_SIZE actualFontSize:NULL lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
	}

}

- (void)removeSubviews {
	// Remove any previous sub views
	int count = [self.subviews count];
	while(count--) {
		[[self.subviews objectAtIndex:count] removeFromSuperview];
	}
}

- (BOOL)updateImage {
	if (self.viewData.checkedImage) {
		return NO;
	} else {
		if ([self.viewData fetchThumbnailMaxRes:320]) {
			[self setNeedsDisplay];	
			return YES;
		}
	}
	return NO;
}
- (void)dealloc {
	NSLog(@"TVCellView - dealloc");
	//[self.viewData release];
	[viewData release];
	[subTitle release];
	[defaultImage release];	
	[super dealloc];
}


@end
