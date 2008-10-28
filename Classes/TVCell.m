//
//  BaseCell.m
//  NavTest
//
//  Created by David Fumberger on 4/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "TVCell.h"
#import "TVCellView.h";

@implementation TVCell
@synthesize baseView;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	frame = CGRectMake(0.0, 0.0, 500, 80);
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		//CGRect imgFrame = CGRectMake(0.0, 0.0, 50, 50);
		//baseView = [[TVCellView alloc] initWithFrame:imgFrame];
		//albumView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		//albumView.showImage = YES;	
		//[self.contentView addSubview:albumView];
		
		// Create a time zone view and add it as a subview of self's contentView.
		CGRect tzvFrame = CGRectMake(0.0, 0.0, 375,self.contentView.bounds.size.height);
		baseView = [[TVCellView alloc] initWithFrame:tzvFrame];		
		
		baseView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:baseView];
	}
	
	return self;
}
/*
 - (void)setSubTitle:(NSString*)subTitle {
 albumView.subTitle = showArtist;	
 }
 - (void)setShowImage:(BOOL)showImage {
 albumView.showImage = showImage;	
 }*/
- (void)setData:(ViewData*)viewData showImage:(BOOL)showImage subTitle:(NSString*)subTitle {
	baseView.subTitle  = subTitle;
	baseView.showImage = showImage;
	baseView.viewData  = viewData;
	if (showImage) {
		baseView.defaultImage = defaultImage;
		//baseView.fetchImage = YES;
	}
	[baseView setNeedsDisplay];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}

- (BOOL)fetchImage {
	if (baseView.showImage) {
		return [baseView updateImage];
	}
	return NO;
}

- (void)dealloc {
	NSLog(@"TVCell - dealloc");	
	[defaultImage release];
	[baseView release];
	[super dealloc];
}


@end
