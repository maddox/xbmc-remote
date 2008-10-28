//
//  BaseCell.h
//  NavTest
//
//  Created by David Fumberger on 4/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "TVCellView.h"
#import "ViewData.h"

@interface TVCell : UITableViewCell {
	TVCellView *baseView;
	UIImage *defaultImage;
}
- (void)setData:(ViewData*)viewData showImage:(BOOL)showImage subTitle:(NSString*)subTitle;
- (BOOL)fetchImage;
@property (nonatomic, retain) TVCellView *baseView;

@end
