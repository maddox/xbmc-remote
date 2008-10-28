//
//  NowPlayingData.h
//  NavTest
//
//  Created by David Fumberger on 6/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TYPE_MUSIC 0
#define TYPE_VIDEO 1
#define TYPE_MOVIE 2
@interface NowPlayingData : NSObject {
	BOOL playing;
	BOOL paused;
	BOOL trackchanged;	
	NSInteger type;
	
	NSString *title;
	
	// Video 
	NSString *plot;
	NSString *showTitle;
	NSString *rating;
	NSString *director;
	NSString *writer;
	NSString *season;
	NSString *episode;
	
	// Music
	NSString *artistTitle;
	NSString *albumTitle;
	NSString *genre;
	
	// General
	NSString *thumb;
	NSString *time;
	NSString *duration;
	NSString *playStatus;
	NSString *filename;
	NSString *url;
	NSInteger track;	
	NSInteger percentagePlayed;
	UIImage *image;
}
@property (nonatomic, getter=playing) BOOL playing;
@property (nonatomic, getter=paused) BOOL paused;
@property (nonatomic, getter=type) NSInteger type;
@property (nonatomic, retain) NSString *plot;
@property (nonatomic, retain) NSString *showTitle;
@property (nonatomic, retain) NSString *rating;
@property (nonatomic, retain) NSString *director;
@property (nonatomic, retain) NSString *writer;
@property (nonatomic, retain) NSString *season;
@property (nonatomic, retain) NSString *episode;

@property (nonatomic, retain) NSString *genre;

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *artistTitle;
@property (nonatomic, retain) NSString *albumTitle;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSString *thumb;
@property (nonatomic, retain) NSString *duration;
@property (nonatomic, retain) NSString *playStatus;
@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, getter=trackchanged) BOOL trackchanged;
@property (nonatomic, getter=track) NSInteger track;
@property (nonatomic, getter=percentagePlayed) NSInteger percentagePlayed;

- (NSString*)mediaTitle;
- (void)fetchThumbnail;
- (NSString*)getFileName;
- (NSString*)getPathName;

@end
