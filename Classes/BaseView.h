//
//  BaseView.h
//  NavTest
//
//  Created by David Fumberger on 4/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewData.h";

@interface BaseView : UIView {
	ViewData *viewData;
	UIImageView *imageView;
	BOOL highlighted;
	NSString* subTitle;
	BOOL showImage;
	BOOL fetchImage;
	BOOL doneFetch;
	NSInteger imageWidth;	
	NSInteger imageHeight;
	NSInteger maxImageSize;	
	UIImage *image;
}
@property (nonatomic, retain) ViewData* viewData;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, assign) BOOL showImage;
@property (nonatomic, assign) BOOL fetchImage;
@property (nonatomic, assign) NSInteger imageHeight;
@property (nonatomic, assign) NSInteger imageWidth;
@property (nonatomic) NSInteger maxImageSize;
@property (nonatomic, retain) NSString* subTitle;
@property (nonatomic, retain) UIImage *image;
- (BOOL)updateImage;
- (void)removeSubviews;
- (void)displayImageView;
@end
