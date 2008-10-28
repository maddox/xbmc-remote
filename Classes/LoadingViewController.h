//
//  LoadingViewController.h
//  NavTest
//
//  Created by David Fumberger on 4/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LoadingViewController : UIViewController {
	IBOutlet UILabel *loadingLabel;
	IBOutlet UIActivityIndicatorView *loadingSpinner;
	IBOutlet UIImageView *logo;
}
- (void)hideSpinner;
@property (nonatomic, retain) IBOutlet UILabel *loadingLabel;
@end
