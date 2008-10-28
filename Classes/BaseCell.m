//
//  BaseCell.m
//  NavTest
//
//  Created by David Fumberger on 4/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "BaseCell.h"
#import "BaseView.h";

@implementation BaseCell
//@synthesize baseView;
@synthesize imageHeight;
@synthesize imageWidth;
@synthesize maxImageSize;
@synthesize flagForRefresh;
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	//frame = CGRectMake(0.0, 0.0, 500, 80);
	if (imageHeight == 0) {
		imageHeight = 50;
	}
	if (imageWidth == 0) {
		imageWidth = 50;
	}
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		// Create a time zone view and add it as a subview of self's contentView.
		CGRect tzvFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width,self.contentView.bounds.size.height);
		baseView = [[BaseView alloc] initWithFrame:tzvFrame];		
		baseView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		baseView.imageHeight = imageHeight;
		baseView.imageWidth = imageWidth;
		
		[self.contentView addSubview:baseView];
		
		//NSLog(@"Creating default image");
		
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
- (BOOL)checkedImage {
	return baseView.viewData.checkedImage;
}
- (void)setImage:(UIImage*)image {
	baseView.image = image;
}
- (void)setData:(ViewData*)viewData showImage:(BOOL)showImage subTitle:(NSString*)subTitle {
	baseView.subTitle  = subTitle;
	baseView.showImage = showImage;
	baseView.viewData = nil;
	baseView.viewData  = viewData;
	baseView.image = nil;
	baseView.imageHeight = imageHeight;
	baseView.imageWidth = imageWidth;
	baseView.maxImageSize = maxImageSize;	
	[baseView setNeedsDisplay];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

	[super setSelected:selected animated:animated];

	// Configure the view for the selected state
}

- (BOOL)fetchImage {
	if (baseView && baseView.showImage) {
		return [baseView updateImage];
	}
	return NO;
}
- (BOOL)refreshSubview {
	if (baseView) {
		[baseView setNeedsDisplay];
	}
	return YES;
}
- (ViewData*)getCellData {
	return baseView.viewData;
}
- (void)dealloc {
	//NSLog(@"BaseCell - dealloc");
	[baseView release];    
	[super dealloc];
}


@end
