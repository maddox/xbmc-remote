//
//  BaseViewController.h
//  xbmcremote
//
//  Created by David Fumberger on 13/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteInterface.h";
#import "LoadingViewController.h";
#import "MusicPath.h";
#import "VideoPath.h";
#import "BaseViewController.h";
#import "ViewData.h";
//#import "TouchTableView.h";

#define SECTION_VIEW_NONE         0
#define SECTION_VIEW_NO_TITLE     1
#define SECTION_VIEW_TITLE        2
#define SECTION_VIEW_INDEXED      3
#define SECTION_VIEW_NORMAL       4
#define SECTION_VIEW_INDEXED_TITLE 5
// Protocol to be adopted by an object wishing to customize cell behavior with respect to editing.
@protocol BaseTableViewDelegate <UITableViewDelegate>

@optional
- (void)viewZoomIn;
- (void)viewZoomOut;

@end

//@interface BaseViewController : UITableViewController {
@interface BaseViewController: UIViewController <BaseTableViewDelegate, UITableViewDataSource> {
	//id <BaseViewControllerDelegate> delegate;
	
	NSInteger zoomLevel;
	BOOL      doZoom;
	LoadingViewController* loadingViewController;
	
	// Identifier for reuse of cells
	NSString *cellIdentifier;
	
	// Text to show for the default action at the top
	NSString *actionCellText;
	
	// Has Image
	BOOL hasImage;
	BOOL doneTableSetup;
	BOOL errorConnecting;
	BOOL pollImages;
	BOOL refreshTableCells;
	BOOL fetchingImage;
	NSInteger imageIndex;

	float pollTime;
	NSTimer *timer;
	UITableView *tableView;
	
	NSInteger sectionViewStyle;
	NSString *sectionTitle;



	RemoteInterface *XBMCInterface;
	XBMCSettings *xbmcSettings;
	
	IBOutlet UINavigationController *navigationController;
	
	IBOutlet UIBarButtonItem *settingsButton;
	IBOutlet UIBarButtonItem *nowPlayingButton;
	
	MusicPath *musicPath;
	VideoPath *videoPath;
	
	NSInteger actionSections;
	NSInteger actionSectionHeight;
	NSInteger rowHeight;
	
	NSArray *displayIndexedData;
	NSArray *displayData;
	NSArray *indexLetters;	
	
	NSInteger *testcount;
	
	BOOL loadedData;
	BOOL reloadData;
	BOOL doPostLoad;
	BOOL doneLoad;
	BOOL isActive;
}

//@property (nonatomic, retain) LoadingViewController *loadingViewController;
@property (nonatomic, retain) MusicPath *musicPath;
@property (nonatomic, retain) VideoPath *videoPath;
@property (nonatomic, assign) BOOL reloadData;

- (void)setupView; 
- (void)showLoading;
- (void)hideLoading;
- (void)loadData;
- (void)doneLoad;
- (UITableViewCell*)getDataCell:(UITableView *)tableView data:(ViewData*)data;
- (UITableViewCell*)getActionCell:(NSInteger)index;
- (void)selectedActionCell:(NSInteger)index;
- (void)selectedDataCell:(ViewData*)data;
- (void)minimiseData;
@end



