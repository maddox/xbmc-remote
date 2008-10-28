//
//  BaseViewController.m
//  xbmcremote
//
//  Created by David Fumberger on 13/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "BaseViewController.h"
#import "InterfaceManager.h";
#import "LoadingViewController.h";
#import "ViewData.h";
#import "BaseCell.h";
#import "TouchTableView.h";

@implementation BaseViewController
@synthesize musicPath;
@synthesize videoPath;
@synthesize reloadData;

- (NSString*)normaliseString:(NSString*)text {
	NSCharacterSet *whiteSpaceSet = [NSCharacterSet whitespaceCharacterSet];
	NSString *pre = [text uppercaseString];
	NSString *pre2 = [pre stringByReplacingOccurrencesOfString:@"THE " withString:@""];
	NSString *output = [pre2 stringByTrimmingCharactersInSet:whiteSpaceSet];	
	return output;
}

- (void)startTimer {
	NSLog(@"Starting timer");
    NSDate *date = [NSDate date];
	imageIndex    = 0;
	fetchingImage = NO;
	pollImages    = YES;	
	refreshTableCells = NO;
	isActive          = YES;
	if (timer) {
		NSLog(@"Already have timer ??");
	}
	timer = [[NSTimer alloc] initWithFireDate:date interval:pollTime target:self selector:@selector(doPollImages) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}
- (void)endTimer {
	NSLog(@"Ending image timer");
	[timer invalidate];
	[timer release];
	timer = nil;
	pollImages = false;	
}
- (void)doPollImages {	
	//	NSLog(@"Loaded %d Poll images [%d] isActive [%d] fetchImage [%d] test count [%d]", loadedData, pollImages, isActive, fetchingImage, testcount);	
	if (!pollImages || !isActive || fetchingImage) {
		return;
	}
	pollImages = NO;
	//	NSLog(@"Do post load ? %d", doPostLoad);
	if (doPostLoad) {
		doPostLoad = NO;
		[self postLoad];
	}
	
	if (!loadedData || !hasImage || !doneTableSetup) {
		pollImages = YES;
		return;
	}	
	
	imageIndex--;	
	NSArray *tcells = tableView.visibleCells;	
	int count = [tcells count];	
	if (imageIndex == -1 || imageIndex >= count) {
		if (count == 0) {
			imageIndex = 0;
			pollImages = YES;		
			return;
		}
		imageIndex = [tcells count] - 1;
	}
	
	BaseCell *cell = [tcells objectAtIndex:imageIndex];	
	if (!cell) {
		pollImages = YES;	
		return;
	}
	if (cell.flagForRefresh) {
		[cell refreshSubview];
		NSLog(@"REfershing");
		cell.flagForRefresh = NO;
	}
	if (![cell checkedImage]) {
		fetchingImage = YES;				
		[NSThread detachNewThreadSelector:@selector(_getImage:) toTarget:self withObject:cell];		
	}
	pollImages = YES;	
}

- (ViewData*)dataForIndexPath:(NSIndexPath*)indexPath {
	ViewData *data;
	if (sectionViewStyle == SECTION_VIEW_NORMAL || sectionViewStyle == SECTION_VIEW_INDEXED_TITLE) {
		data = [displayData objectAtIndex:indexPath.row];
	} else if (sectionViewStyle == SECTION_VIEW_INDEXED) {
		NSDictionary *letterDictionary = [displayIndexedData objectAtIndex:indexPath.section - actionSections];
		NSArray *dataForLetter = [letterDictionary objectForKey:@"data"];
		data = [dataForLetter objectAtIndex:indexPath.row];
	}	
	return data;
}
- (void)_getImage:(BaseCell*)cell {
	NSAutoreleasePool	 *autoreleasepool = [[NSAutoreleasePool alloc] init];		
	ViewData *data    = [cell getCellData];	
	if (data && !data.checkedImage) {		
		int maxres;
		if (cell.maxImageSize) {
			maxres = cell.maxImageSize;
		} else {
			maxres = (cell.imageHeight > cell.imageWidth) ? (cell.imageHeight) : (cell.imageWidth);
		}
		if (isActive && [data fetchThumbnailCacheMaxRes:maxres]) {
			cell.flagForRefresh = YES;
		//	[cell refreshSubview];
		}			
	}
	fetchingImage = NO;
	[autoreleasepool release];	
}



- (void) unselectCurrent {
	NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
	[tableView deselectRowAtIndexPath: indexPath animated: NO];	
}

- (void)setUpDisplayList {
	
	NSMutableDictionary *indexedTableData = [[NSMutableDictionary alloc] init];
	int count = [displayData count];
	for (int i = 0; i < count; i++) {
		// Way to cancel inside thread 		
		if (!isActive) {
			return;
		}
		ViewData *data = [displayData objectAtIndex:i];
		NSString *normalisedTitle = [self normaliseString: data.title];
		
		if (![normalisedTitle length]) { normalisedTitle = @"#"; }
		
		NSString *firstLetter   = [normalisedTitle substringToIndex:1];
		NSCharacterSet *charSet = [NSCharacterSet letterCharacterSet];
		
		char charfirst =  [firstLetter characterAtIndex:0];
		if ( ![charSet characterIsMember: charfirst] ) {
			firstLetter  = @"#";
		}
		
		NSMutableArray *indexArray = [indexedTableData objectForKey:firstLetter];
		if (indexArray == nil) {
			indexArray = [[NSMutableArray alloc] init];
			[indexedTableData setObject:indexArray forKey:firstLetter];
			[indexArray release];
		}
		[indexArray addObject:data];
	}
	
	
	NSMutableArray *displayListData = [[NSMutableArray alloc] init];
	
	indexLetters = [[[indexedTableData allKeys] sortedArrayUsingSelector:@selector(compare:)] retain];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	
	int lcount = [indexLetters count];
	for (int i = 0; i < lcount; i++) {
		// Way to cancel inside thread 
		if (!isActive) {
			return;
		}		
		NSString *indexLetter = [indexLetters objectAtIndex:i];
		
		NSMutableArray *sortedData = [indexedTableData objectForKey:indexLetter];
		[sortedData sortUsingDescriptors:sortDescriptors];
		
		NSDictionary *letterDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:indexLetter, @"letter", sortedData, @"data", nil];
		[displayListData addObject:letterDictionary];
		[letterDictionary release];
	}
	
	
	displayIndexedData = [displayListData retain];
	[sortDescriptor release];	
	[indexedTableData release];
	[displayListData release];
}


-(void)setupView {
	hasImage = NO;
	pollTime = 0.01;
	actionSectionHeight = 45;
	rowHeight = 45;
	zoomLevel = 2;
	doZoom = NO;
	cellIdentifier = @"BaseCell";
}
-(void)doneLoad {
	if ( [displayData count] > 30) {
		sectionViewStyle = SECTION_VIEW_INDEXED;
	} else {
		sectionViewStyle = SECTION_VIEW_NORMAL;
	}
	if ([displayData count] > 1) {
		actionSections = 1;	
	} else {
		actionSections = 0;
	}
}

- (void)viewDidLoad {
	// Setup
	if (musicPath == nil) {
		musicPath = [[MusicPath alloc] init];
	}
	XBMCInterface = [InterfaceManager getSharedInterface]; 
	xbmcSettings =  [[XBMCSettings alloc] init];
	[self setupView];
	if (![xbmcSettings showImages]) {
		hasImage = NO;
	}
	loadedData = NO;
	
	UIView *contView = [[UIView alloc] initWithFrame:CGRectZero];
	self.view = contView;
	[contView release];
}

- (void)setupTable {
	if (!tableView) {		
		tableView = [[UITableView alloc] initWithFrame: self.view.bounds style:UITableViewStylePlain];
		tableView.dataSource = self;
		tableView.delegate = self;
		[tableView setMultipleTouchEnabled: YES];
		[self.view addSubview: tableView];
		[tableView reloadData];
		doneTableSetup = YES;
	} else {
		[self.view bringSubviewToFront:tableView];
	}
}
- (void)showLoading {
	loadingViewController = [[LoadingViewController alloc] initWithNibName: @"Loading" bundle:nil];
	[[self view] addSubview: loadingViewController.view];
}
- (void)hideLoading {
	if (loadingViewController) {
		[loadingViewController.view removeFromSuperview];
		[loadingViewController release];
		loadingViewController = nil;
	}
}	

- (void)_threadLoadData {
	NSAutoreleasePool	 *autoreleasepool = [[NSAutoreleasePool alloc] init];
	doPostLoad = NO;
	testcount++;
	if (!loadedData) {
		[self loadData ];
		if (isActive) {
			doPostLoad = YES;
		} else {
			[displayData release];
			displayData = nil;
		}
	}
	[autoreleasepool release];

}

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"View Will Appear");
	isActive = TRUE;
	[self unselectCurrent];

	if (self.reloadData) {
		[displayData release];
		displayData = nil;
		[displayIndexedData release];
		displayIndexedData = nil;
		[indexLetters release];
		indexLetters = nil;
		[tableView release];
		tableView = nil;
	}	
	
	if (loadedData == NO || reloadData) {
		[self showLoading];
		loadedData = NO;
		[NSThread detachNewThreadSelector:@selector(_threadLoadData) toTarget:self withObject:nil];		
	} 
	
	if (loadedData && !tableView) {
		[self setupTable];
	}
	
	[super viewWillAppear:animated];
}

- (void)showNoData {
	if (XBMCInterface.hasError) {
		loadingViewController.loadingLabel.text = @"Error connecting to XBMC";
	} else if (![xbmcSettings hasActiveHost]) {
		loadingViewController.loadingLabel.text = @"Select 'Settings' to add a host";	
	} else {
		loadingViewController.loadingLabel.text = @"No media found";	
	}
	[loadingViewController hideSpinner];
}


- (void)postLoad {
	if (!isActive) {
		return;
	}
	loadedData = YES;
	[self doneLoad];
	if (sectionViewStyle == SECTION_VIEW_INDEXED) {
		[self setUpDisplayList];
	}
	if ( displayData == nil ||  [displayData count] == 0) {
		[self showNoData];
		self.reloadData = YES;
	} else {
		[self setupTable];
		[self hideLoading];
		if (self.reloadData) {
			self.reloadData = NO;
		}
		
	}
}


- (void)viewDidAppear:(BOOL)animated {	 
	//NSLog(@"View Did Appear");	
	[self startTimer];	
	return [super viewDidAppear:animated];	
}
- (void)viewDidDisappear:(BOOL)animated {
	[self hideLoading];
	if (!fetchingImage) {
		[[NSURLCache sharedURLCache] removeAllCachedResponses];	
	}
}


- (void)viewWillDisappear:(BOOL)animated {
	isActive = NO;
	[self endTimer];
}


- (void)selectedData:(ViewData*)data {
	
}

- (void)minimiseData {
	if (!isActive) {
		NSLog(@"Minimise");		
		[tableView removeFromSuperview];		
		[tableView release];
		tableView = nil;
	}

}

- (void)doneZoom {
	
}

- (void)viewZoomOut {
	if (!doZoom) {
		return;
	}
	zoomLevel--;
	if (zoomLevel == 0) {
		zoomLevel = 1;
	}
	[self doneZoom];
	[tableView setNeedsDisplay];
	[tableView setNeedsLayout];
	[tableView reloadData];	
}
- (void)viewZoomIn {
	if (!doZoom) {
		return;
	}	
	zoomLevel++;
	if (zoomLevel == 5) {
		zoomLevel = 4;
	}	
	[self doneZoom];
	[tableView setNeedsDisplay];
	[tableView setNeedsLayout];
	[tableView reloadData];	
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

	// The header for the section is the region name -- get this from the dictionary at the section index
	if (sectionViewStyle == SECTION_VIEW_NORMAL) {
		if (sectionTitle != nil && section >= actionSections) {
			return sectionTitle;
		}
	} else if (sectionViewStyle == SECTION_VIEW_INDEXED) {
		if (section < actionSections) {
			return nil;
		} else {
			NSDictionary *sectionDictionary = [displayIndexedData objectAtIndex:section - actionSections];
			return [sectionDictionary valueForKey:@"letter"];
		}
	} else if (sectionViewStyle == SECTION_VIEW_INDEXED_TITLE) {
		if (section >= actionSections) {
			ViewData *data = [displayData objectAtIndex:section - actionSections];
			return data.title;
		}
		
	}
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	if (sectionViewStyle == SECTION_VIEW_NORMAL) {
		if (section < actionSections) {
			return 1;
		}  else {
			return displayData.count;
		}
	} else if (sectionViewStyle == SECTION_VIEW_INDEXED){
		if (section < actionSections) {
			return 1;
		} else {
			NSDictionary *letterDictionary = [displayIndexedData objectAtIndex:section - actionSections];
			NSArray *dataForLetter = [letterDictionary objectForKey:@"data"];
			return [dataForLetter count];
		}
	} else if (sectionViewStyle == SECTION_VIEW_INDEXED_TITLE) {
		return 1;
	}
	return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (sectionViewStyle == SECTION_VIEW_NORMAL) {
		return 1 + actionSections;
	} else if (sectionViewStyle == SECTION_VIEW_INDEXED) {
		return [displayIndexedData count] + actionSections;
	} else if (sectionViewStyle == SECTION_VIEW_INDEXED_TITLE) {
		return [displayData count] -  actionSections;
	}
	return 0;
}

// the table's selection has changed, switch to that item's UIViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section < actionSections) {
		[self selectedActionCell:indexPath.section];
	} else {		
		ViewData *data;
		if (sectionViewStyle == SECTION_VIEW_NORMAL || sectionViewStyle == SECTION_VIEW_INDEXED_TITLE) {
			data = [displayData objectAtIndex:indexPath.row];
		} else if (sectionViewStyle == SECTION_VIEW_INDEXED) {
			NSDictionary *letterDictionary = [displayIndexedData objectAtIndex:indexPath.section - actionSections];
			NSArray *dataForLetter = [letterDictionary objectForKey:@"data"];
			data = [dataForLetter objectAtIndex:indexPath.row];
		}

		[self selectedDataCell:data];	
	
	}
}

- (void)updateCellImage:(BaseCell*)bcell {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	//UIImage *image = [data fetchThumbnailCacheMaxRes:maxres];
	NSIndexPath *indexPath = [[tableView indexPathForCell:bcell] retain];
	ViewData *data = [self dataForIndexPath:indexPath];	
	if (indexPath) {
		NSLog(@"indexPath row %d", indexPath.row);
	}


	[pool release];
	return;		

	int maxres;
	if (bcell.maxImageSize) {
		maxres = bcell.maxImageSize;
	} else {
		maxres = (bcell.imageHeight > bcell.imageWidth) ? (bcell.imageHeight) : (bcell.imageWidth);
	}
	
	UIImage *image = [data fetchThumbnailCacheMaxRes:maxres];
	//[bcell setImage:image];	
	//[bcell setNeedsDisplay];
	//NSLog(@"Set image");
	
	[pool release];
}

- (UITableViewCell *)tableView:(UITableView *)callingTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section < actionSections) {
		return (UITableViewCell*)[self getActionCell:indexPath.section ];
	} else {
		if (sectionViewStyle == SECTION_VIEW_INDEXED) {
			NSDictionary *letterDictionary = [displayIndexedData objectAtIndex:indexPath.section - actionSections];
			NSArray *dataForLetter = [letterDictionary objectForKey:@"data"];
			ViewData *data = [dataForLetter objectAtIndex:indexPath.row];
			return [self getDataCell:tableView data:data];
		} else if (sectionViewStyle == SECTION_VIEW_NORMAL) {
			ViewData *data = [displayData objectAtIndex:indexPath.row];
			return [self getDataCell:tableView data:data];
		} else if (sectionViewStyle == SECTION_VIEW_INDEXED_TITLE) {
			ViewData *data = [displayData objectAtIndex:indexPath.section - actionSections];
			return [self getDataCell:tableView data:data];
		}
	}
	NSLog(@"No thing?");
	return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)callingTableView {
	if (loadedData == NO) {
		return [NSArray array];
	}	
	if (sectionViewStyle == SECTION_VIEW_INDEXED) {
		return [displayIndexedData valueForKey:@"letter"];
	} else {
		return [NSArray array];
	}
}

- (NSInteger)tableView:(UITableView *)callingTableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	if (sectionViewStyle == SECTION_VIEW_INDEXED) {
		return [indexLetters indexOfObject:title] + actionSections;
	} else {
		return 0;
	}
}

- (CGFloat)tableView:(UITableView *)callingTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return (actionSections == 1 && indexPath.section == 0) ? actionSectionHeight : rowHeight;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UITableViewCell*)getDataCell:(UITableView *)callingTableView data:(ViewData*)data{

	BaseCell *cell = (BaseCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[[BaseCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
		if (hasImage) {
			cell.imageWidth  = rowHeight - 1;
			cell.imageHeight = rowHeight - 1;
		}
	}
	[cell setData:data showImage: hasImage subTitle: nil];
	return cell;	
}

- (UITableViewCell*)getActionCell:(NSInteger)index {
	BaseCell *cell = [[[BaseCell alloc] initWithFrame:CGRectZero] autorelease];
	cell.text = actionCellText;
	return cell;	
}
- (void)selectedActionCell:(NSInteger)index {
	[self selectedDataCell:nil];
}
- (void)selectedDataCell:(ViewData*)data {
}
- (void)loadData {	
}
- (void)dealloc {	
	NSLog(@"BaseViewController - dealloc");
	//[timer invalidate];	
	//[timer release];
	[cellIdentifier release];
	
	[actionCellText release];
	[sectionTitle release];
	

	[musicPath release];
	[videoPath release];

	[displayData release]; 
	[displayIndexedData release];
	[indexLetters release];
	
	[xbmcSettings release];
	[tableView release];	

	
	[super dealloc];
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	//NSLog(@"Rotated");
}


- (void)cleanupData {
	if (hasImage) {
		for (int i = 0; i < [displayData count];i++) {
			ViewData *data = [displayData objectAtIndex: i];
			[data cleanup];
		}
	}
}
- (void)didReceiveMemoryWarning {
	[self cleanupData];	
}



@end

NSInteger alphabeticSort(id string1, id string2, void *reverse)
{
    if ((NSInteger *)reverse == NO) {
        return [string2 localizedCaseInsensitiveCompare:string1];
    }
    return [string1 localizedCaseInsensitiveCompare:string2];
}

