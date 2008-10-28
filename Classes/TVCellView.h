//
//  BaseView.h
//  NavTest
//
//  Created by David Fumberger on 4/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewData.h";

@interface TVCellView : UIView {
	ViewData *viewData;
	NSString *subTitle;
	UIImage  *defaultImage;	
	BOOL highlighted;
	BOOL showImage;
	BOOL fetchImage;
	BOOL doneFetch;
}
@property (nonatomic, retain) ViewData* viewData;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, getter=showImage) BOOL showImage;
@property (nonatomic, retain) NSString* subTitle;
@property (nonatomic, retain)  UIImage* defaultImage;
- (BOOL)updateImage;
@end
