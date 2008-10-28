//
//  MediaInfoViewController.m
//  xbmcremote
//
//  Created by David Fumberger on 21/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "MediaInfoViewController.h";
#import "LoadingViewController.h";
#import "MediaInfoData.h";
#import "DisplayCell.h";
#import "NowPlayingData.h";
#import "InterfaceManager.h";

#define TEXT_COLUMN_WIDTH 205

#define EPISODE_ITEMS 6
#define SHOW_ITEMS    4

#define MOVIE_ITEMS   10

#define SONG_ITEMS    7
#define ALBUM_ITEMS   8
#define ARTIST_ITEMS  11

#define FONT_SIZE 13
@implementation MediaInfoViewController

//@synthesize displayData;

@synthesize filename;
@synthesize dataType;

-(void)loadData {
	NSString *file = [filename lastPathComponent];
	NSString *path = [ NSString stringWithFormat:@"%@/",  // Add trailing slash as this is what XBMC expects
					[filename stringByDeletingLastPathComponent ]];

	if (dataType == TYPE_VIDEO) {
		sectionTitles = [[NSArray arrayWithObjects:@"Episode Information", @"TV Show Information", nil] retain];
		displayData = [[XBMCInterface GetMediaDataForTVShowFile:file path:path] retain];
	} else if (dataType == TYPE_MOVIE) {
		sectionTitles = [[NSArray arrayWithObjects:@"Movie Information", nil] retain];
		displayData = [[XBMCInterface GetMediaDataForMovieFile:file path:path] retain];
	} else if (dataType == TYPE_MUSIC) {		
		sectionTitles = [[NSArray arrayWithObjects:@"Song Information", @"Album Information", @"Artist Information", nil] retain];
		displayData = [[XBMCInterface GetMediaDataForMusicFile:file path:path] retain];
	} else {
		displayData = [[NSArray array] retain];
	}
	
	NSLog(@"MediaInfoViewContrller - Rows %d", [displayData count]);

}

- (void)viewDidLoad {
	XBMCInterface = [InterfaceManager getSharedInterface];
	UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
	self.view = containerView;
	[containerView release];
}

- (void)setupTable {
	UITableView *tableView = [[UITableView alloc] initWithFrame: self.view.bounds style:UITableViewStyleGrouped];
	tableView.dataSource = self;
	tableView.delegate = self;
	[tableView reloadData];
	[tableView setNeedsLayout];
	[tableView setNeedsDisplay];
	[self.view addSubview: tableView];
	[tableView release];
}

- (void)showLoading {
	loadingViewController = [[[LoadingViewController alloc] initWithNibName: @"Loading" bundle:nil] retain];
	[[self view] addSubview: loadingViewController.view];
}
- (void)hideLoading {
	[loadingViewController.view removeFromSuperview];
	[loadingViewController release];
}
- (void)viewWillAppear:(BOOL)animated {
	[self showLoading];
	[super viewWillAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
	[displayData release];
	[sectionTitles release];
	sectionTitles = nil;
	displayData   = nil;
	filename      = nil;
}
- (void)viewDidAppear:(BOOL)animated {	 
	[self loadData];
	if ([displayData count] > 0) {
		[self setupTable];
		[self hideLoading];
	} else {
		NSLog(@"No information");
		if (XBMCInterface.hasError) {
			loadingViewController.loadingLabel.text = @"Error connecting to XBMC";
		} else {
			loadingViewController.loadingLabel.text = @"No information available";	
		}
		[loadingViewController hideSpinner];
	}

	[super viewDidAppear:animated];	
	return;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [sectionTitles count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [sectionTitles objectAtIndex:section];
}

- (NSInteger)getIndex:(NSIndexPath*)indexPath {
	int index = indexPath.row;
	if (dataType == MEDIA_INFO_TYPE_TV) {
		if (indexPath.section == 1) {
			index = index + EPISODE_ITEMS;
		}
	} else if (dataType == TYPE_MUSIC) {
		if (indexPath.section == 1) {
			index += SONG_ITEMS;
		} else if (indexPath.section == 2) {
			index += SONG_ITEMS + ALBUM_ITEMS;
		}
	}
	return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger index = [self getIndex:indexPath];

	MediaInfoData *data = [displayData objectAtIndex:index];

	UIFont *textFont          = [UIFont systemFontOfSize:FONT_SIZE];
	UIFont *labelFont         = [UIFont boldSystemFontOfSize:FONT_SIZE];	
	CGRect frame;
	

	DisplayCell *cell;
	if ([data.fieldtype isEqualToString:@"long"] || 
		[data.fieldtype isEqualToString:@"text"] 
	   ) {

		cell = (DisplayCell*)[tableView dequeueReusableCellWithIdentifier:@"MediaViewCell"];
		if (cell == nil) {
			cell = [[[DisplayCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"MediaViewCell"] autorelease];
		}
		cell.nameLabel.text = data.title;
		cell.nameLabel.font = labelFont;
		//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		if ([data.fieldtype isEqualToString:@"long"]) {
		
			frame = CGRectMake(0.0, 0.0, TEXT_COLUMN_WIDTH + 8, 120);	
		
			UITextView *textView = [[[UITextView alloc] initWithFrame:frame] autorelease];
			//UILabel *textView = [[[UILabel alloc] initWithFrame:frame] autorelease];
			//textView.numberOfLines = 10;
			textView.editable = NO;
			textView.font = textFont;
			if ([data.value length] > 1) {
				textView.text = data.value;		
			} else {
				textView.text = @"None";
			}
			cell.view = textView;
			
			// Seems to be a bug usign UITextView on a UITableView.. disappears now and then.
			// The following seems to help..
			NSRange range;
			range.location = 1;
			[textView setNeedsDisplay];
			[textView setNeedsLayout];			
			[textView scrollRangeToVisible:range];

		} else {
			frame = CGRectMake(0.0, 0.0, TEXT_COLUMN_WIDTH, 27.0);		
			UILabel *textView = [[[UILabel alloc] initWithFrame:frame] autorelease];
			textView.text = data.value;	
			textView.font = textFont;
			cell.view = textView;	
		}
	} else if ([data.fieldtype isEqualToString:@"nolabel"]) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"MediaViewTitleCell"];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"MediaViewTitleCell"] autorelease];
		}
		cell.text = data.value;
		cell.backgroundColor = [UIColor grayColor];
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger index = [self getIndex:indexPath];
	MediaInfoData *data = [displayData objectAtIndex:index];

	if ([data.fieldtype isEqualToString:@"long"]) {
		return 130;
	} else {
		return 45;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (dataType == TYPE_VIDEO) {
		if (section == 0) {
			return EPISODE_ITEMS;
		} else {
			return SHOW_ITEMS;
		}
	} else if (dataType == TYPE_MUSIC) {
		if (section == 0) {
			return SONG_ITEMS;
		} else if (section == 1) {
			return ALBUM_ITEMS;
		} else if (section == 2) {
			return ARTIST_ITEMS;
		}
	} else {
		return MOVIE_ITEMS;
	}
	return 0;
}


-(void)dealloc {
	NSLog(@"MediaInfoViewController - dealloc");
	[sectionTitles release];
	[displayData release];
	[filename release];
	[super dealloc];
}
@end
