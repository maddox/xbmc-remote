//
//  RemoteInterface.m
//  NavTest
//
//  Created by David Fumberger on 30/07/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "RemoteInterface.h"
#import "Utility.h";
#import "XBMCSettings.h";
#import "HTTPRequest.h";
#import "Base64.h";
#import "NowPlayingData.h";
#import "GUIStatus.h";
#import "XBMCHostData.h";

#import "MusicPath.h";
#import "VideoPath.h";

#import "AlbumData.h";
#import "SongData.h";
#import "ArtistData.h";
#import "VideoData.h";
#import "TVShowData.h";
#import "MovieData.h";
#import "FileSystemData.h";
#import "MediaInfoData.h";
#import "ShareData.h";

#import "XUIImage.h";

@implementation RemoteInterface

//@synthesize settings;
@synthesize hasError;

- (NSString*)getThumbnailPathForType:(NSString*)type {
	
}

- (NSString*)getMusicPlaylist {
	return @"0";
}

- (NSString*)getVideoPlaylist {
	return @"1";
}

- (NSArray*)ParseGetAction:(NSString*)response element:(NSString*)element {
	NSCharacterSet *chars = [NSCharacterSet newlineCharacterSet];
	NSString *openTag = [NSString stringWithFormat:@"<%@>", element];
	NSString *closeTag = [NSString stringWithFormat:@"</%@>", element];
	NSString *stripped = [
						  [[[response stringByReplacingOccurrencesOfString:@"<html>" withString:@""]
							stringByReplacingOccurrencesOfString:@"</html>" withString:@""]
						   stringByReplacingOccurrencesOfString:closeTag withString:@""]
						  stringByTrimmingCharactersInSet:chars];
	//NSLog(@"Parse get action %@", stripped);
	NSArray *items = [stripped componentsSeparatedByString:openTag];
	//[chars release];
	NSRange range;
	if ([items count] > 1) {
		range.location = 1;
		range.length = [items count] - 1;
		NSArray *ret = [items subarrayWithRange: range];
		
		return ret;
	} else {
		//NSLog(@"No data , returning empty array");
		return [NSArray array];
	}
}
- (NSArray*)createAlbumData:(NSArray*)dataList {
	NSMutableArray *returnlist = [NSMutableArray array ];	
	for (NSDictionary *record in dataList) {		
		AlbumData *data = [[AlbumData alloc] initWithDictionary: record];
		[returnlist addObject: data ];
		[data release];
	}
	return returnlist;
}

- (NSArray*)createSongData:(NSArray*)dataList {
	NSMutableArray *returnlist = [NSMutableArray array ];	
	for (NSDictionary *record in dataList) {	
		SongData *data = [[SongData alloc] initWithDictionary: record];
		[returnlist addObject: data ];
		[data release];
	}
	return returnlist;
}
- (NSArray*)createArtistData:(NSArray*)dataList {
	NSMutableArray *returnlist = [NSMutableArray array ];	
	for (NSDictionary *record in dataList) {	
		ArtistData *data = [[ArtistData alloc] initWithDictionary: record];
		[returnlist addObject:data];
		[data release];
	}
	return returnlist;
}
- (NSArray*)createViewData:(NSArray*)dataList {
	NSMutableArray *returnlist = [NSMutableArray array ];	
	for (NSDictionary *record in dataList) {
		ViewData *data = [[ViewData alloc] initWithDictionary: record];
		[returnlist addObject: data ];
		[data release];
	}
	return returnlist;
}
- (NSArray*)createVideoData:(NSArray*)dataList {
	NSMutableArray *returnlist = [NSMutableArray array ];	
	for (NSDictionary *record in dataList) {	
		VideoData *data = [[VideoData alloc] initWithDictionary: record];
		[returnlist addObject: data];
		[data release];
	}
	return returnlist;
}
- (NSArray*)createTVShowData:(NSArray*)dataList {
	NSMutableArray *returnlist = [NSMutableArray array ];	
	for (NSDictionary *record in dataList) {	
		NSLog(@"Title %@", [record objectForKey:@"title"]);
		TVShowData *data =  [[TVShowData alloc] initWithDictionary: record];
		[returnlist addObject: data];
		[data release];
	}
	return returnlist;
}
- (NSInteger)GetVolume {
	NSString *response = [ self SendCommand:@"GetVolume" parameter:@"" ];
	NSArray  *items    = [self ParseGetAction: response element: @"li"];
	if ([items count] == 1) {
		return [ [items objectAtIndex:0 ] integerValue ];
	} 
	return 0;
}

- (NowPlayingData*)GetCurrentlyPlaying {	
	NSString *response = [ self SendCommand:@"GetCurrentlyPlaying" parameter:@"" ];
	NowPlayingData *nowPlaying = [[[NowPlayingData alloc] init] autorelease];
	
	NSArray *items = [self ParseGetAction: response element: @"li"];
	int count = [items count];
	while(count--) {
		NSString *item = [items objectAtIndex:count];
		NSArray *fields = [item componentsSeparatedByString:@":"];
		if ( [fields count] >= 2) {
			NSString *value;
			NSCharacterSet *chars = [NSCharacterSet newlineCharacterSet];
			if ([fields count] > 2) {
				NSRange theRange;
				theRange.location = 1; theRange.length = [ fields count ] - 1;
				NSArray *valuefields = [fields subarrayWithRange:theRange];
				value = [ [valuefields componentsJoinedByString:@":"]
						 stringByTrimmingCharactersInSet:chars];
			} else {
				value = [ [fields objectAtIndex:1]
						 stringByTrimmingCharactersInSet:chars];
			}
			NSString *key = [fields objectAtIndex:0];
			
			//NSLog(@"Key [%@] Value [%@] Somethign Else", key, value);
			
			if ([key isEqualToString:@"Filename"]) {
				if ( [value isEqualToString:@"[Nothing Playing]"]) {
					nowPlaying.playing = NO;
					nowPlaying.paused = NO;
					nowPlaying.filename = nil;
				} else {
					nowPlaying.filename = value;
				}
			} else if ([key isEqualToString:@"Type"]) {
				if ( [value isEqualToString:@"Video"] ) {
					if (nowPlaying.showTitle == nil) {
						nowPlaying.type = TYPE_MOVIE;
					} else {
						nowPlaying.type = TYPE_VIDEO;
					}
				} else {
					nowPlaying.type = TYPE_MUSIC;
				}
			} else if ([key isEqualToString:@"Time"]) {
				nowPlaying.time = value;
			} else if ([key isEqualToString:@"Track"]) {
				nowPlaying.track = [value integerValue];
			} else if ([key isEqualToString:@"Artist"]) {
				nowPlaying.artistTitle = value;
			} else if ([key isEqualToString:@"Album"]) {
				nowPlaying.albumTitle = value;
			} else if ([key isEqualToString:@"Thumb"]) {
				if ([value isEqualToString:@""]) {
					nowPlaying.thumb = nil;
				} else {
					nowPlaying.thumb = value;
				}
			} else if ([key isEqualToString:@"Title"]) {
				nowPlaying.title = value;	
			} else if ([key isEqualToString:@"Genre"]) {
				nowPlaying.genre = value;			
			} else if ([key isEqualToString:@"Duration"]) {
				nowPlaying.duration = value;
			} else if ([key isEqualToString:@"Changed"]) {
				if ( [value isEqualToString:@"True"] ) {
					nowPlaying.trackchanged = YES;
				} else {
					nowPlaying.trackchanged = NO;
				}
			} else if ([key isEqualToString:@"PlayStatus"]) {
				nowPlaying.playStatus = value;
				if ( [value isEqualToString:@"Paused"] ) {
					nowPlaying.playing = NO;
					nowPlaying.paused = YES;
				} else if ([value isEqualToString:@"Playing"]) {
				    nowPlaying.playing = YES;
					nowPlaying.paused = NO;
				}
			} else if ([key isEqualToString:@"Percentage"]) {
				nowPlaying.percentagePlayed =  [value integerValue];
			} else if ([key isEqualToString:@"Show Title"]) {
				NSLog(@"IS VIDEO");
				nowPlaying.type      = TYPE_VIDEO;
				nowPlaying.showTitle = value;
			} else if ([key isEqualToString:@"Plot"]) {
				nowPlaying.plot = value;
			} else if ([key isEqualToString:@"Rating"]) {
				nowPlaying.rating = value;
			} else if ([key isEqualToString:@"Season"]) {
				nowPlaying.season = value;
			} else if ([key isEqualToString:@"Episode"]) {
				nowPlaying.episode = value;
			} else if ([key isEqualToString:@"Director"]) {
				nowPlaying.director = value;
			} else if ([key isEqualToString:@"Writer"]) {
				nowPlaying.writer = value;
			} else if ([key isEqualToString:@"URL"]) {
				nowPlaying.url = value;
			}			
			
		}
	}
	return nowPlaying;
}


- (GUIStatus*)GetGUIStatus {	
	NSString *response = [ self SendCommand:@"GetGUIStatus" parameter:@"" ];
	GUIStatus *guiStatus = [[[GUIStatus alloc] init] autorelease];
	
	NSArray *items = [self ParseGetAction: response element: @"li"];
	int count = [items count];
	while(count--) {
		NSString *item = [items objectAtIndex:count];
		NSArray *fields = [item componentsSeparatedByString:@":"];
		if ( [fields count] >= 2) {
			NSString *value;
			NSCharacterSet *chars = [NSCharacterSet newlineCharacterSet];
			if ([fields count] > 2) {
				NSRange theRange;
				theRange.location = 1; theRange.length = [ fields count ] - 1;
				NSArray *valuefields = [fields subarrayWithRange:theRange];
				value = [ [valuefields componentsJoinedByString:@":"]
						 stringByTrimmingCharactersInSet:chars];
			} else {
				value = [ [fields objectAtIndex:1]
						 stringByTrimmingCharactersInSet:chars];
			}
			NSString *key = [fields objectAtIndex:0];
			
			//NSLog(@"Key [%@] Value [%@] Somethign Else", key, value);
			
			if ([key isEqualToString:@"ActiveWindowName"]) {
				guiStatus.activeWindowName = value;
			} else if ([key isEqualToString:@"VideoPath"]) {
				guiStatus.videoPath = value;
			}
		}
	}
	return guiStatus;
}


- (void)SetPlaylistSong:(NSInteger)song {
	[self SendCommand:@"SetPlaylistSong" parameter:[NSString stringWithFormat:@"%d", song]];
}

- (UIImage*)GetThumbnail:(NSString*)thumbLocation {
	
	NSData *data = [self FileDownload:thumbLocation];
	if (data) {
		UIImage *image = [UIImage imageWithData:data];
		return image;
	} 
	return nil;
}



- (NSData*)FileDownload:(NSString*)fileLocation {
	NSString *response = [ self SendCommand: @"FileDownload" parameter: fileLocation ];
	NSString *preone = [response stringByReplacingOccurrencesOfString:@"<html>"  withString:@""];
	NSString *filedata = [preone stringByReplacingOccurrencesOfString:@"</html>" withString:@""];
	if ([filedata length] > 2) {
		NSData *decode = [NSData dataWithBase64EncodedString:filedata];
		return decode;
	}
	return nil;
}

- (NSArray*)GetSongsForAlbumId:(NSString*)albumId {
	return [self GetSongsByWhereClause: [NSString stringWithFormat: @"idAlbum = \"%@\"", albumId]];
}

- (NSArray*)GetSongsForAlbumName:(NSString*)albumName artistName:(NSString*)artistName {
	return [self GetSongsByWhereClause: [NSString stringWithFormat: @"strAlbum = \"%@\" and strArtist = \"%@\"", albumName, artistName]];
}

- (NSArray*)GetAlbumsForArtistId:(NSString*)artistId {
	//NSLog(@"GetAlbumsForArtistId");
	NSArray *fields = [ NSArray arrayWithObjects: @"id", @"title", @"artistId", @"artistTitle", @"thumbnail",nil ];
	NSString *query = [ NSString stringWithFormat: @"select idAlbum, strAlbum, idArtist, strArtist, strThumb from albumview where idArtist  = %@ order by strAlbum asc", artistId];
	NSArray *xmldata = [ self QueryMusicDatabase: query
							  fields            :fields ];	
    NSArray *returndata = (NSArray*)[self createAlbumData:xmldata ];	
	//NSLog(@"Finished GetAlbumsForArtistId");	
	return returndata; 
}

- (void)addToPlayList:(NSString*)media playList:(NSString*)playList mask:(NSString*)mask recursive:(NSString*)recursive {
	[ self SendCommand:@"AddToPlayList" 
			parameters: [NSArray arrayWithObjects:media, playList, mask, recursive, nil]
	 ];
}

- (void)clearPlayList:(NSString*)playList {
	[ self SendCommand:@"ClearPlayList" 
				 parameter:playList];
}

- (void)setCurrentPlayList:(NSString*)playList {
	[ self SendCommand:@"SetCurrentPlaylist" 
				 parameter:playList];
}
- (void)playFile:(NSString*)fileName {
	[ self SendCommand:@"PlayFile" 
				 parameter:fileName];
}

- (void)playNext {
	[ self SendCommand:@"PlayNext" 
				 parameter:@""];	
}
- (void)playPrev {
	[ self SendCommand:@"PlayPrev" 
				 parameter:@""];	
}
- (void)pause {
	[ self SendCommand:@"Pause" 
				 parameter:@""];	
}
- (void)stop {
	[ self SendCommand:@"Stop" 
				 parameter:@""];	
}
- (void)PartyModeVideo {
	[ self SendCommand: @"ExecBuiltIn"
			 parameter: @"XBMC.PlayerControl(Partymode(video))" ];
}
- (void)PartyModeMusic {
	[ self SendCommand:  @"ExecBuiltIn"
			 parameter: @"XBMC.PlayerControl(Partymode(music))"];
}
- (void)Mute {
	[ self SendCommand:  @"ExecBuiltIn"
			 parameter: @"XBMC.PlayerControl(Mute)"];
}
- (void)PlayDVD {
	[ self SendCommand: @"ExecBuiltIn"
			 parameter: @"XBMC.PlayDVD"];
}
- (void)EjectTray {
	[ self SendCommand: @"ExecBuiltIn"
			 parameter: @"XBMC.EjectTray"];
}
- (void)CycleTheme {
	[ self SendCommand: @"ExecBuiltIn"
			 parameter: @"Skin.theme"];
}
- (void)UpdateVideoLibrary {
	[ self SendCommand: @"ExecBuiltIn"
			 parameter: @"XBMC.updatelibrary(video)"];
}
- (void)UpdateMusicLibrary {
	[ self SendCommand: @"ExecBuiltIn"
			 parameter: @"XBMC.updatelibrary(video)"];
}
- (void)ClearSlideshow {
	[ self SendCommand:@"ClearSlideshow" 
			 parameter: nil];	
}
- (void)Zoom:(NSInteger)maginification {
	[ self SendCommand:@"Zoom" 
			 parameter: [NSString stringWithFormat:@"%d", maginification]];	
}
- (void)SeekPercentage:(NSInteger)percentage {
	[ self SendCommand:@"SeekPercentage" 
			 parameter: [NSString stringWithFormat:@"%d", percentage]];	
}
- (void)SetPlaySpeed:(NSInteger)speed {
	[ self SendCommand:@"SetPlaySpeed" 
			 parameter: [NSString stringWithFormat:@"%d", speed]];	
}
- (void)RestartApp  {
	[ self SendCommand:@"RestartApp" 
			 parameter: nil];	
}
- (void)Restart  {
	[ self SendCommand:@"Restart" 
			 parameter: nil];	
}
- (void)Shutdown   {
	[ self SendCommand:@"Shutdown" 
			 parameter: nil];	
}
- (void)Rotate  {
	[ self SendCommand:@"Rotate" 
			 parameter: nil];	
}
- (void)Reset  {
	[ self SendCommand:@"Reset" 
			 parameter: nil];	
}



- (void)SetVolume:(NSInteger)volume {
	[ self SendCommand:@"SetVolume" 
			 parameter: [NSString stringWithFormat:@"%d", volume] ];	
}
- (BOOL)GetShuffle {
	NSString *response = [ self SendCommand:@"GetSystemInfo" parameter: @"392"];
	NSLog(@"Response %@", response);
	NSArray *items = [self ParseGetAction:response element:@"li"];
	if ([items count] > 0) {
		NSString *shuffle = [items objectAtIndex:0];
		if ([shuffle isEqualToString:@"Random"]) {
			NSLog(@"Current Shuffle On");
			return YES;
		} 
	}
	NSLog(@"Current Shuffle Not On");	
	return NO;
}
- (void)SetShuffleBlind {
	[ self SendCommand:@"ExecBuiltIn" parameter: @"XBMC.PlayerControl(Random)"];	
}
- (void)SetShuffle:(BOOL)shuffle {
	NSLog(@"Setting shuffle %d", shuffle);
	if (shuffle != [self GetShuffle]) {
		NSLog(@"Shuffle not equal to current");
		[ self SendCommand:@"ExecBuiltIn" parameter: @"XBMC.PlayerControl(Random)"];
	} else {
		NSLog(@"Shuffle is equal to current, doing nothing");
	}
}
- (void)SetRepeatOff {
	[ self SendCommand:@"ExecBuiltIn" parameter: @"XBMC.PlayerControl(RepeatOff)"];	
}
- (void)SetRepeatOn {
	[ self SendCommand:@"ExecBuiltIn" parameter: @"XBMC.PlayerControl(RepeatAll)"];	
}
- (void)SetRepeatOne {
	[ self SendCommand:@"ExecBuiltIn" parameter: @"XBMC.PlayerControl(RepeatOn)"];	
}

- (void)_sshufflethreadon {
	//NSAutoreleasePool	 *autoreleasepool = [[NSAutoreleasePool alloc] init];	
	[self SetShuffle: YES];
	//[autoreleasepool release];
}
- (void)_sshufflethreadoff {
	//NSAutoreleasePool	 *autoreleasepool = [[NSAutoreleasePool alloc] init];	
	[self SetShuffle: NO];
	//[autoreleasepool release];
}
- (void)SetShuffle:(BOOL)shuffle delay:(NSInteger)delay{
	SEL selname;
	if (shuffle) {
		[NSTimer scheduledTimerWithTimeInterval:delay 
										 target:self
									   selector:@selector(_sshufflethreadon) 
									   userInfo:nil 
										repeats:NO];
		//selname = @selector(_sshufflethreadon);
	} else {
		[NSTimer scheduledTimerWithTimeInterval:delay 
										 target:self
									   selector:@selector(_sshufflethreadoff) 
									   userInfo:nil 
										repeats:NO];
		//selname = @selector(_sshufflethreadoff);
	}
	/*NSMethodSignature *sig = [XBMCHTTP instanceMethodSignatureForSelector:  selname];
	 NSInvocation *invoc = [NSInvocation invocationWithMethodSignature:sig];
	 [invoc setSelector:selname];		
	 NSTimeInterval seconds = delay;
	 [NSTimer scheduledTimerWithTimeInterval: seconds invocation:invoc repeats:NO];*/
}
- (void)stopPlaying  {
	[ self SendCommand:@"Stop" parameter: nil];
}
- (void)Action:(NSInteger)action {
	[ self SendCommand:@"Action" 
			 parameter: [NSString stringWithFormat:@"%d", action] ];	
}
- (void)SendKey:(NSInteger)key {
	[ self SendCommand:@"Action" 
			 parameter: [NSString stringWithFormat:@"%d", key] ];	
}

- (NSArray*)GetAlbumsForArtistName:(NSString*)artistName {
	NSArray *fields = [ NSArray arrayWithObjects: @"id", @"title", @"artistid", @"artist", nil ];	
	NSString *query = [ NSString stringWithFormat: @"select strAlbum from album where idArtist in (select idArtist from artist where strArtist = '%@');", artistName];
	NSArray *xmldata = [ self QueryMusicDatabase: query
										  fields: fields ];
	return xmldata; 
}

- (BOOL)queueAlbumId:(NSString*)albumId shuffle:(BOOL)shuffle {
	NSMutableArray* songs = [NSMutableArray arrayWithArray:[self GetSongsForAlbumId:albumId]];
	NSEnumerator *enumerator = [songs objectEnumerator];
	
	if (shuffle) {
		[ Utility randomizeArray:songs ];	
	}
	SongData     *songData;	
	while (songData = [enumerator nextObject]) {	
		NSString *songfullfile = [ songData fullFileName];			
		[ self addToPlayList: songfullfile playList: [self getMusicPlaylist] mask:@"" recursive:@"" ];	
	}	
	return YES;
}

- (BOOL)queueMusicPath:(MusicPath*)musicPath {
	NSString *path = [musicPath GetPath];
	NSLog(@"Path %@", path);
	[self addToPlayList: path playList: [self getMusicPlaylist] mask:@"" recursive:@"1"];
	return TRUE;
}

- (BOOL)queueVideoPath:(VideoPath*)videoPath {
	NSString *path = [videoPath GetPath];
	NSLog(@"Path %@", path);
	[self addToPlayList: path playList: [self getVideoPlaylist] mask:@"" recursive:@"1"];
	return TRUE;
}

- (NSArray*)QueryDatabase:(NSString*)sql fields:(NSArray*)fields dbcommand:(NSString*)dbcommand {
	NSString      *response = [self SendCommand: dbcommand parameter:sql ];
	NSArray       *data = [self ParseGetAction: response element: @"field"];
	NSEnumerator *enumerator = [data objectEnumerator];
	NSString     *field;
	NSMutableDictionary *currentfield = [NSMutableDictionary dictionary];
	NSMutableArray *fieldlist = [NSMutableArray array ];
	int count = 0;
	while (field = [enumerator nextObject]) {
		NSString *normalised = [ field stringByReplacingOccurrencesOfString: @"\n" withString: @"" ];
		[ currentfield setValue: normalised
						 forKey: [fields objectAtIndex: count] ];
		count++;
		if (count == fields.count) {
			count = 0;
			[ fieldlist addObject: currentfield ];
			currentfield = [NSMutableDictionary dictionary];
		}
	}
	return fieldlist;	
}
- (NSArray*)QueryDatabaseArray:(NSString*)sql dbcommand:(NSString*)dbcommand {
	NSString      *response = [self SendCommand: dbcommand parameter:sql ];
	NSArray       *data = [self ParseGetAction: response element: @"field"];
	return data;	
}
- (NSArray*)QueryMusicDatabaseArray:(NSString*)sql { 
	return [self QueryDatabaseArray:sql dbcommand: @"querymusicdatabase"];	
}
- (NSArray*)QueryVideoDatabaseArray:(NSString*)sql { 
	return [self QueryDatabaseArray:sql dbcommand: @"queryvideodatabase"];	
}
- (NSArray*)QueryMusicDatabase:(NSString*)sql fields:(NSArray*)fields {
	return [self QueryDatabase:sql fields:fields dbcommand: @"querymusicdatabase"];	
}
- (NSArray*)QueryVideoDatabase:(NSString*)sql fields:(NSArray*)fields {
	return [self QueryDatabase:sql fields:fields dbcommand: @"queryvideodatabase"];	
}


- (NSString*)GetPodcastGenreId {
	NSArray *data = [ self  QueryMusicDatabaseArray:@"select idGenre from genre where strGenre = \"Podcast\""];	
	if ([data count] > 0) {
		return [data objectAtIndex:0];
	} else {
		return nil;
	}
}

- (NSArray*)GetAlbumsByWhereClause:(NSString*)whereClause {
	
	//NSArray *fields = [ NSArray arrayWithObjects: @"id", @"title", @"artistId", @"artistTitle", @"thumbnail",nil ];
	NSString *query = [NSString stringWithFormat:@"select idAlbum, strAlbum, idArtist, strArtist, strThumb from albumview where %@ order by strAlbum asc", whereClause];
	NSArray *data = [ self  QueryMusicDatabaseArray:query];
	
	NSMutableArray *returndata = [NSMutableArray array ];
	int count = [data count];
	if (count < 5) { return returndata; }
	for (int i = 0; i < count;) {
		AlbumData *sdata = [AlbumData alloc];
		sdata.identifier =[data objectAtIndex:i++];
		sdata.title = [data objectAtIndex:i++];
		sdata.artistId  = [data objectAtIndex:i++];
		sdata.artistTitle  = [data objectAtIndex:i++];
		NSString *thumb    = [data objectAtIndex:i++];
		if (![thumb isEqualToString:@"NONE"]) {
			NSArray *comps = [Utility fileComponents:thumb];
			sdata.thumbnail_path = [comps objectAtIndex:0];						
			sdata.thumbnail_file = [comps objectAtIndex:1];
		}
		
		[sdata init];
		[returndata addObject:sdata];	
		[sdata release];
	}	
	return returndata; 
}
- (NSArray*)GetAlbumsForMusicPath:(MusicPath*)musicPath {
	NSString *whereClause = [musicPath WhereClauseForAlbum];
	NSArray *returndata = [self GetAlbumsByWhereClause:whereClause];
	return returndata; 	
}
- (NSArray*)GetAlbums {
	NSArray *returndata = [self GetAlbumsByWhereClause:@"1=1"];
	return returndata; 
}
- (NSArray*)GetArtistsByWhereClause:(NSString*)whereClause {
	NSString *query = [NSString stringWithFormat:@"select idArtist, strArtist from artist where %@ order by strArtist asc", whereClause];
	NSArray *data = [ self  QueryMusicDatabaseArray:query];
	
	NSMutableArray *returndata = [NSMutableArray array ];
	
	int count = [data count];
	if (count < 2) { return returndata; }
	for (int i = 0; i < count;) {
		ArtistData *sdata = [ArtistData alloc];
		sdata.identifier =[data objectAtIndex:i++];
		sdata.title = [data objectAtIndex:i++];
		[sdata init];
		[returndata addObject:sdata];	
		[sdata release];
	}	
	return returndata; 
}
- (NSArray*)GetArtists {
	NSArray *returndata = [self GetArtistsByWhereClause:@"1=1"];
	return returndata; 
}
- (NSArray*)GetArtistsForMusicPath:(MusicPath*)musicPath {
	NSString *whereClause = [musicPath WhereClauseForArtist];
	NSArray *returndata = [self GetArtistsByWhereClause:whereClause];
	return returndata; 	
}

- (NSArray*)GetSongsByWhereClause:(NSString*)whereClause {
	NSString *query = [ NSString stringWithFormat: @"select idSong, strTitle, strPath, strFileName , idAlbum , strArtist from songview where %@ order by iTrack",
					   whereClause];
	NSLog(@"Doing Query - Songs");
	NSArray *data = [ self QueryMusicDatabaseArray: query ];		
	NSLog(@"Creating Data - Songs");	
	
	NSMutableArray *returndata = [NSMutableArray array ];
	
	int count = [data count];
	if (count < 6) { return returndata; }	
	for (int i = 0; i < count;) {
		SongData *sdata = [SongData alloc];
		sdata.identifier =[data objectAtIndex:i++];
		sdata.title = [data objectAtIndex:i++];
		sdata.path  = [data objectAtIndex:i++];
		sdata.file  = [data objectAtIndex:i++];
		sdata.albumId = [data objectAtIndex:i++];
		sdata.artistTitle = [data objectAtIndex:i++];
		[sdata init];
		[returndata addObject:sdata];	
		[sdata release];
	}
	NSLog(@"Returning Data - Songs");		
	return returndata; 
}

- (NSArray*)GetSongs {
	NSArray *returndata = [self GetSongsByWhereClause:@"1=1"];
	return returndata; 	
}

- (NSArray*)GetSongsForMusicPath:(MusicPath*)musicPath {
	NSString *whereClause = [musicPath WhereClauseForSong];
	NSArray *returndata = [self GetSongsByWhereClause:whereClause];
	return returndata; 	
}

- (NSArray*)GetGenresByWhereClause:(NSString*)whereClause {
	NSArray *fields = [ NSArray arrayWithObjects: @"id", @"title", nil ];
	NSString *query = [ NSString stringWithFormat: @"select idGenre, strGenre, strPath, strFileName , idAlbum, strAlbum,strArtist from songview where %@ order by idSong",
					   whereClause];
	NSArray *xmldata = [ self QueryMusicDatabase: query
							  fields            :fields ];		
    NSArray *returndata = (NSArray*)[self createSongData:xmldata ];	
	return returndata; 
}

- (NSArray*)GetGenres {
	NSArray *fields = [ NSArray arrayWithObjects: @"id", @"title", nil ];
	NSArray *data = [ self QueryMusicDatabase:  @"select idGenre, strGenre from genre order by strGenre"
						   fields            :fields ];	
    NSArray *returndata = (NSArray*)[self createViewData:data ];	
	return returndata; 	
}
- (NSArray*)GetTVShowsByWhereClause:(NSString*)whereClause {
	NSArray *fields = [ NSArray arrayWithObjects: @"id", @"title", @"thumbnail", @"path", nil ];
	NSString *query = [ NSString stringWithFormat: @"select tvshow.idShow, tvshow.c00, c06, strPath from tvshow, tvshowlinkpath, path where %@ and tvshow.idShow in (select tvshowlinkepisode.idShow from tvshowlinkepisode) and tvshow.idShow = tvshowlinkpath.idShow and tvshowlinkpath.idPath = path.idPath order by c00",
					   whereClause];	
	NSArray *querydata = [ self QueryVideoDatabase: query
								fields            :fields ];	
    NSArray *returndata = (NSArray*)[self createTVShowData:querydata ];	
	return returndata; 
}


- (NSArray*)GetTVShows {
	return [self GetTVShowsByWhereClause:@" 1 = 1"];	
}

- (NSArray*)GetSeasonsByWhereClause:(NSString*)whereClause {
	NSArray *fields = [ NSArray arrayWithObjects: @"id", @"title", nil ];
	NSString *query = [ NSString stringWithFormat: @"select distinct(c12), 'Season ' || c12 from episode where %@ order by 1",
					   whereClause];
	NSArray *data = [ self QueryVideoDatabase: query
						   fields            :fields ];		
    NSArray *returndata = (NSArray*)[self createViewData:data ];	
	return returndata; 
}

- (NSArray*)GetSeasons {
	return [self GetSongsByWhereClause:@"1=1"];
}

- (NSArray*)GetSeasonsForVideoPath:(VideoPath*)videoPath {
	NSString *whereClause = [videoPath WhereClauseForSeason];
	NSArray *returndata = [self GetSeasonsByWhereClause:whereClause];
	return returndata; 	
}


- (NSArray*)GetEpisodesByWhereClause:(NSString*)whereClause {
	NSArray *fields = [ NSArray arrayWithObjects: @"id", @"title", @"file", @"path", @"showName", @"seasonName", @"episode", nil ];
	NSString *query = [ NSString stringWithFormat: @"select episode.idEpisode, episode.c00, strFilename, strPath, tvshow.c00, episode.c12, episode.c13 from episode, tvshowlinkepisode,tvshow, files, path where %@ and episode.idFile = files.idFile and episode.idEpisode = tvshowlinkepisode.idEpisode and tvshowlinkepisode.idShow = tvshow.idShow and files.idPath = path.idPath  order by abs(episode.c12),  abs(episode.c13)",
					   whereClause];
	NSArray *data = [ self QueryVideoDatabase: query
						   fields            :fields ];		
    NSArray *returndata = (NSArray*)[self createVideoData:data ];	
	return returndata; 
}


- (NSArray*)GetEpisodes {
	return [self GetSongsByWhereClause:@"1=1"];
}

- (NSArray*)GetEpisodesForVideoPath:(VideoPath*)videoPath {
	NSString *whereClause = [videoPath WhereClauseForEpisode];
	NSArray *returndata = [self GetEpisodesByWhereClause:whereClause];
	return returndata; 	
}

- (NSArray*)GetMoviesByWhereClause:(NSString*)whereClause {
	NSString *query = [ NSString stringWithFormat: @"select movie.idMovie, movie.c00,files.strFileName as strFileName,path.strPath as strPath, movie.c14 from movie join files on files.idFile=movie.idFile join path on path.idPath=files.idPath where %@ order by movie.c00",
					   whereClause];
	NSArray *data = [ self QueryVideoDatabaseArray: query ];		
	NSMutableArray *returndata = [NSMutableArray array ];
	
	int count = [data count];
	if (count < 4) { return returndata; }	
	for (int i = 0; i < count;) {
		MovieData *sdata = [MovieData alloc];
		sdata.identifier = [data objectAtIndex:i++];
		sdata.title      = [data objectAtIndex:i++];
		sdata.file       = [data objectAtIndex:i++];	
		sdata.path       = [data objectAtIndex:i++];
		sdata.genre    = [data objectAtIndex:i++];		
		[sdata init];
		[returndata addObject:sdata];	
	}	
	return returndata; 
}
- (NSArray*)GetMovies {
	return [self GetMoviesByWhereClause:@" 1 = 1"];	
}

- (NSArray*)GetYears {
	NSArray *fields = [ NSArray arrayWithObjects: @"id", @"title", nil ];
	NSArray *data = [ self QueryMusicDatabase:  @"select distinct(iYear)  from albumInfo where iYear > 0 order by 1"
						   fields            :fields ];	
    NSArray *returndata = (NSArray*)[self createViewData:data ];	
	return returndata; 	
}




- (NSArray*)GetDirectory:(NSString*)directory  {
	NSString      *response = [self SendCommand: @"GetDirectory" parameter:directory ];
	NSArray       *data     = [self ParseGetAction: response element: @"li"];
	NSMutableArray *returndata = [NSMutableArray array ];
	
	int count = [data count];
	for (int i = 0; i < count; i++) {
		ViewData *vdata = [[ViewData alloc] init];
		NSString *row = [data objectAtIndex: i];
		NSArray *fields = [row componentsSeparatedByString:@"/"];
		NSInteger fieldLength = [[fields objectAtIndex:0] length];
		if ([fields count] == 0 || fieldLength == 0) {
			continue;
		}
		//NSLog(@"Field length %d", [[fields objectAtIndex:[fields count] - 1] length]);
		
		// Just checking if anything came back and that the last item has some sort of data in it
		// lazy coding of this bit, need to do it proppery.
		if ([fields count] > 2 && [[fields objectAtIndex:[fields count] - 1] length] < 2) {
			vdata.title = [fields objectAtIndex: [fields count] - 2];
		} else {
			vdata.title = [fields objectAtIndex: [fields count] - 1];
			vdata.file = row;
			vdata.path = @"";
		}
		if (![vdata.title isEqualToString: @"Error:Not folder"]) {
			[returndata addObject:vdata];	
		}
		[vdata release];
	}
	return returndata; 		
}



- (NSArray*)GetMediaLocationForMusic:(NSString*)directory {
	return [self GetMediaLocation:directory mask:@"music"];
}

- (NSArray*)GetMediaLocationForVideo:(NSString*)directory {
	return [self GetMediaLocation:directory mask:@"video"];
}

- (NSArray*)SplitMultipart:(NSString*)string {
	NSRange range;
	range = [string rangeOfString:@"multipath://"];
	if (range.location == NSNotFound) {
		NSLog(@"No multipart %@", string);
		return [NSArray arrayWithObject: string];
	}
	NSArray *comps = [string componentsSeparatedByString:@"multipath://"]; 
	NSLog(@"Has Multipart %@", string);
	NSLog(@"Components %d idx %@", [comps count], [comps objectAtIndex:1]);
	NSString *paths = [comps objectAtIndex:1];
	NSMutableArray *ret  = [NSMutableArray array];
	NSArray *items = [paths componentsSeparatedByString:@"/"];
	for (int i = 0; i < [items count]; i++) {
		//NSString *proto = [items objectAtIndex:i];
		//NSString *file = [items objectAtIndex: i + 1];
		//NSString *complete = [NSString stringWithFormat:@"%@//%@/", proto, file];
		NSString *complete = [items objectAtIndex:i];
		if ([complete length] > 2) {
			NSLog(@"Complete [%@]", complete);
			[ret addObject:complete];
		}
	}
	return ret;
}

- (NSArray*)GetMediaLocationSingle:(NSString*)directory mask:(NSString*)mask {
	NSArray       *params = [NSArray arrayWithObjects: mask, directory, nil];
	NSString      *response = [self SendCommand: @"GetMediaLocation" parameters: params];
	NSArray       *data     = [self ParseGetAction: response element: @"li"];
	NSMutableArray *returndata = [NSMutableArray array ];
	
	int count = [data count];
	for (int i = 0; i < count; i++) {
		FileSystemData *vdata = [[FileSystemData alloc] init];
		NSString *row = [data objectAtIndex: i];
		NSArray *fields = [row componentsSeparatedByString:@";"];
		if ([fields count] < 2) {
			continue;
		}
		vdata.title = [fields objectAtIndex: 0];
		vdata.path  = [fields objectAtIndex: 1];
		NSInteger type = [[fields objectAtIndex:2] integerValue];
		NSArray *rarComps = [vdata.path componentsSeparatedByString:@"rar://"];
		if (type == 1 && [rarComps count] == 2) {
			//NSString *rarPath = [NSString stringWithFormat:@"%@null", [rarComps objectAtIndex:1]];
			NSString *rarPath = [rarComps objectAtIndex:1];
			NSArray *fileComps = [Utility fileComponents: rarPath includeSeperator: NO];
			vdata.isRar = YES;
			if ([[fileComps objectAtIndex:1] length] > 1) {
				vdata.file = [rarComps objectAtIndex:1];	
			} else {
				vdata.path = [fileComps objectAtIndex:0];
			}
		} else if (type == 0) {
			vdata.file = vdata.path;
		}
		if ([mask isEqualToString:@"music"]) {
			vdata.filetype = FILE_MUSIC;
		} else if ([mask isEqualToString:@"video"]) {
			vdata.filetype = FILE_VIDEO;
		}
		[returndata addObject:vdata];
		[vdata release];
	}
	return returndata; 		
}
- (NSArray*)GetMediaLocation:(NSString*)directory mask:(NSString*)mask {
	NSRange range;
	range = [directory rangeOfString:@"multipath://"];
	if (range.location == NSNotFound) {
		return [self GetMediaLocationSingle:directory mask:mask];
	} else {
		NSLog(@"Multipart directory");
		NSMutableArray *ret = [NSMutableArray array];
		NSArray *paths = [self SplitMultipart: directory];
		int c = [paths count];
		for (int j = 0; j < c; j++) {
			NSString *dir =  [paths objectAtIndex:j] ;
			NSLog(@"Directory [%@]", dir);
			NSArray *files = [self GetMediaLocationSingle:dir mask:mask];
			NSLog(@"Files count [%d]", [files count]);
			[ret addObjectsFromArray: files];
			// Seems to return the same thing for all directories ?
			break;
		}
		return ret;
	}	
}
- (NSArray*)GetSharesForType:(NSString*)type {
	NSString      *response = [self SendCommand: @"GetShares" parameter:type ];
	NSArray       *data     = [self ParseGetAction: response element: @"li"];
	NSMutableArray *returndata = [NSMutableArray array ];
	
	int count = [data count];
	for (int i = 0; i < count; i++) {
		ShareData *vdata = [[ShareData alloc] init];
		NSString *row = [data objectAtIndex: i];
		NSArray *fields = [row componentsSeparatedByString:@";"];
		vdata.title = [fields objectAtIndex: 0];
		vdata.path  = [fields objectAtIndex: 1];
		[returndata addObject:vdata];	
		[vdata release];
	}
	return returndata; 	
}
- (NSString*)SendCommand:(NSString*)command parameter:(NSString*)parameter{
	XBMCSettings *xbmcsettings = [[XBMCSettings alloc] init];
	XBMCHostData *data     = [xbmcsettings getActiveHost];
	[xbmcsettings release];
	if (data == nil) {
		return @"";
	}
	
	HTTPRequest *req = [HTTPRequest alloc];
	
	req.hostname    = data.hostname;
	req.port_number = data.port_number;
	req.username    = @"xbox";
	req.password    = data.password;
	
	if (parameter == nil) {
		req.parameters = [ NSArray arrayWithObjects: @"command",command, nil ];
	} else {
		req.parameters = [ NSArray arrayWithObjects: @"command",command, @"parameter", parameter, nil ];	
	}
	req.path = @"/xbmcCmds/xbmcHttp";
	NSString* response = [req Get];
	hasError = NO;
	if (req.reqError.code) {
		hasError = YES;
	}
	[req release];
	return response;
}
- (NSString*)SendCommand:(NSString*)command parameters:(NSArray*)parameters {
	NSMutableString* parameter = [NSMutableString stringWithCapacity:10 ];
	NSEnumerator *enumerator = [parameters objectEnumerator];
	NSString     *field;
	int count = 0;
	while (field = [enumerator nextObject]) {
		if (count > 0) {
			[ parameter appendString: @";" ];
		}
		[ parameter appendString:field ]; 		
		count++;
	}
	return [ self SendCommand:command parameter:parameter ];
}

- (NSArray*)GetMediaDataForTVShowFile:(NSString*)file path:(NSString*)path {
	NSArray *fieldtypes = [ NSArray arrayWithObjects: @"nolabel", @"long", @"text", @"text", @"text", @"text",      @"nolabel", @"long", @"text", @"text", nil];
	// Season info
	NSArray *titles = [ NSArray arrayWithObjects: @"Title", @"Plot", @"Rating", @"Writer",@"Air Date", @"Director", @"Title", @"Plot", @"Genre", @"Air Date", nil ];
	NSString *query = [ NSString stringWithFormat: @"select episodeview.c00, episodeview.c01, episodeview.c03, episodeview.c04, episodeview.c05, episodeview.c10, tvshowview.c00,tvshowview.c01, tvshowview.c08, tvshowview.c05 from episodeview, tvshowview where tvshowview.idShow = episodeview.idShow and episodeview.strPath = \"%@\" and episodeview.strFileName = \"%@\"" ,
					   path, file];
	NSArray *data = [ self QueryVideoDatabaseArray: query ];		
    int count = [data count];
	NSMutableArray *returndata = [NSMutableArray array];
	for (int i = 0; i < count; i++) {
		MediaInfoData *mdata = [[MediaInfoData alloc] init];
		mdata.title = [titles objectAtIndex:i];
		mdata.value = [data objectAtIndex:i];
		mdata.fieldtype = [fieldtypes objectAtIndex:i];
		[returndata addObject:mdata];
		[mdata release];		
	}
	return returndata; 
}

- (NSArray*)GetMediaDataForMovieFile:(NSString*)file path:(NSString*)path {
	NSArray *fieldtypes = [ NSArray arrayWithObjects: @"nolabel", @"long",@"text", @"text", @"text", @"text", @"text", @"text", @"text",@"text",  nil];
	NSArray *titles = [ NSArray arrayWithObjects:          @"Title",@"Plot", @"Tag Line",@"Genre",  @"Director" , @"Rating", @"Length", @"Year", @"Rated",@"Studio", nil ];
	NSString *query = [ NSString stringWithFormat: @"select c00, c01, c03, c14,c15,c05,c11,c07,c12, c18  from movieview where  movieview.strPath = \"%@\" and movieview.strFileName = \"%@\"" ,
					   path, file];
	NSArray *data = [ self QueryVideoDatabaseArray: query ];		
    int count = [data count];
	NSMutableArray *returndata = [NSMutableArray array];
	for (int i = 0; i < count; i++) {
		MediaInfoData *mdata = [[MediaInfoData alloc] init];
		NSString *value = [data objectAtIndex:i];
		NSString *title = [titles objectAtIndex:i];
		if ([title isEqualToString:@"Rated"]) {
			value = [value stringByReplacingOccurrencesOfString:@"Rated " withString:@""];
		}
		mdata.title = title;
		mdata.value = value;
		mdata.fieldtype = [fieldtypes objectAtIndex:i];
		[returndata addObject:mdata];
		[mdata release];		
	}
	return returndata; 
}

- (NSArray*)GetMediaDataForMusicFile:(NSString*)file path:(NSString*)path {
	NSArray *fieldtypes = [ NSArray arrayWithObjects: 
						   @"nolabel",
						   @"text", 
						   @"text", 
						   @"text", 
						   @"text", 
						   @"text", 
						   @"text", 
						   
						   @"nolabel",
						   @"long",
						   @"text",
						   @"text",
						   @"text",
						   @"text",
						   @"text",
						   @"text",		
						   
						   @"nolabel",
						   @"long",
						   @"text",
						   @"text",
						   @"text",
						   @"text",
						   @"text",
						   @"text",	
						   @"text",
						   @"text",
						   @"text",
						   nil];
	NSArray *titles = [ NSArray arrayWithObjects:  
					   @"Title",
					   @"Track", 
					   @"Duration",
					   @"Year",  
					   @"Played" , 
					   @"Rating", 
					   @"Comment", 
					   
					   @"Title",
					   @"Review",					   
					   @"Rating", 
					   @"Year", 
					   @"Moods",
					   @"Styles",
					   @"Themes",
					   @"Label",
					   
					   @"Title",
					   @"Biography",
					   @"Born",
					   @"Formed",
					   @"Genres",
					   @"Moods",
					   @"Styles",
					   @"Instruments",
					   @"Died",
					   @"Disbanded",
					   @"Years Active",
					   nil ];
	NSString *query = [ NSString stringWithFormat: @"select strTitle, iTrack, iDuration, songview.iYear,iTimesPlayed,rating,comment,   albumview.strAlbum,  albumview.strReview, albumview.iRating ,albumview.iYear, albumview.strMoods, albumview.strStyles, albumview.strThemes, albumview.strLabel   , songview.strArtist, strBiography, strBorn, strFormed, artistinfo.strGenres, artistinfo.strMoods, artistinfo.strStyles, strInstruments, strDied, strDisbanded, strYearsActive from songview , albumview, artistinfo where songview.idArtist = artistinfo.idArtist and songview.idAlbum = albumview.idAlbum and songview.strPath = \"%@\" and songview.strFileName = \"%@\"" ,
					   path, file];
	NSArray *data = [ self QueryMusicDatabaseArray: query ];		
    int count = [data count];
	NSMutableArray *returndata = [NSMutableArray array];
	for (int i = 0; i < count; i++) {
		MediaInfoData *mdata = [[MediaInfoData alloc] init];
		NSString *value = [data objectAtIndex:i];
		NSString *title = [titles objectAtIndex:i];
		if ([title isEqualToString:@"Duration"]) {
			value = [Utility secondsToString: [value integerValue]];
		}
		mdata.title = title;
		mdata.value = value;
		mdata.fieldtype = [fieldtypes objectAtIndex:i];
		[returndata addObject:mdata];
		[mdata release];		
	}
	return returndata; 
}

-(void)dealloc {
	[super dealloc];
}
@end

