//
//  BaseCell.h
//  NavTest
//
//  Created by David Fumberger on 4/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "BaseView.h"
#import "ViewData.h"

@interface BaseCell : UITableViewCell {
	BaseView *baseView;
	NSInteger imageHeight;
	NSInteger imageWidth;
	NSInteger maxImageSize;
	BOOL flagForRefresh;
}
- (void)setData:(ViewData*)viewData showImage:(BOOL)showImage subTitle:(NSString*)subTitle;
- (BOOL)fetchImage;
- (BOOL)refreshSubview;
- (BOOL)checkedImage;
- (ViewData*)getCellData;
- (void)setImage:(UIImage*)image;
@property (nonatomic,assign) NSInteger imageHeight;
@property (nonatomic,assign) NSInteger imageWidth;
@property (nonatomic,assign) NSInteger maxImageSize;
@property (nonatomic,assign) BOOL flagForRefresh;
@end
