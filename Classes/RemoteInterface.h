//
//  XBMCHTTP.h
//  NavTest
//
//  Created by David Fumberger on 30/07/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBMCSettings.h";
#import "NowPlayingData.h";
#import "GUIStatus.h";
#import "MusicPath.h";
#import "VideoPath.h";

#define PLAYLIST_MUSIC 0
#define PLAYLIST_VIDEO 1

#define SHUFFLE_STATE_OFF 0
#define SHUFFLE_STATE_ON  1

#define REPEAT_STATE_OFF  0
#define REPEAT_STATE_ON   1
#define REPEAT_STATE_ONE  2

@interface RemoteInterface : NSObject {	
	BOOL hasError;
}
@property (nonatomic) BOOL hasError;
- (NSString*)getMusicPlaylist;
- (NSString*)getVideoPlaylist;

- (NSArray*)GetSongsForAlbumId:(NSString*)albumId;

- (NSArray*)GetAlbumsForArtistId:(NSString*)artistId;

- (NSArray*)GetSongsForAlbumName:(NSString*)albumName artistName:(NSString*)artistName;
- (NSArray*)GetAlbumsForArtistName:(NSString*)artistName;
- (NSArray*)createArtistData:(NSArray*)dataList;
- (NSArray*)createAlbumData:(NSArray*)dataList;
- (NSArray*)createSongData:(NSArray*)dataList;

- (NSArray*)QueryMusicDatabase:(NSString*)sql fields:(NSArray*)fields;
- (NSArray*)QueryVideoDatabase:(NSString*)sql fields:(NSArray*)fields;

- (NSString*)getThumbnailPathForType:(NSString*)type;
- (NSData*)FileDownload:(NSString*)fileLocation;
- (UIImage*)GetThumbnail:(NSString*)thumbLocation;
- (NSInteger)GetVolume;
- (NowPlayingData*)GetCurrentlyPlaying;
- (GUIStatus*)GetGUIStatus;
- (void)SetPlaylistSong:(NSInteger)song;
- (void)addToPlayList:(NSString*)media playList:(NSString*)playList mask:(NSString*)mask recursive:(NSString*)recursive;
- (void)clearPlayList:(NSString*)playList;
- (void)setCurrentPlayList:(NSString*)playList;
- (void)playFile:(NSString*)fileName;
- (void)playNext;
- (void)playPrev;
- (void)pause;
- (void)stop;
- (void)SeekPercentage:(NSInteger)percentage;
- (void)PartyModeVideo;
- (void)PartyModeMusic;
- (void)Mute;
- (void)PlayDVD;
- (void)CycleTheme;
- (void)UpdateMusicLibrary;
- (void)UpdateVideoLibrary;
- (void)EjectTray;
- (void)ClearSlideshow;
- (void)Zoom:(NSInteger)maginification;
- (void)SeekPercentage:(NSInteger)percentage;
- (void)SetPlaySpeed:(NSInteger)speed;
- (void)RestartApp;
- (void)Restart;
- (void)Shutdown;
- (void)Rotate;
- (void)Reset;
- (void)SetVolume:(NSInteger)volume;
- (void)SetShuffle:(BOOL)shuffle;
- (void)SetRepeatOff;
- (void)SetRepeatOn;
- (void)SetRepeatOne;
- (BOOL)queueAlbumId:(NSString*)albumId shuffle:(BOOL)shuffle;
- (BOOL)queueMusicPath:(MusicPath*)musicPath;
- (BOOL)queueVideoPath:(VideoPath*)videoPath;
- (void)stopPlaying;
- (void)Action:(NSInteger)action;
- (void)SendKey:(NSInteger)key;

- (NSString*)GetPodcastGenreId;
- (NSArray*)GetAlbums;
- (NSArray*)GetAlbumsByWhereClause:(NSString*)whereClause; 
- (NSArray*)GetAlbumsForMusicPath:(MusicPath*)musicPath ;
- (NSArray*)GetArtistsByWhereClause:(NSString*)whereClause;
- (NSArray*)GetArtists;
- (NSArray*)GetArtistsForMusicPath:(MusicPath*)musicPath;
- (NSArray*)GetSongsByWhereClause:(NSString*)whereClause;
- (NSArray*)GetSongs;
- (NSArray*)GetSongsForMusicPath:(MusicPath*)musicPath;
- (NSArray*)GetGenres;
- (NSArray*)GetTVShowsByWhereClause:(NSString*)whereClause;
- (NSArray*)GetTVShows;
- (NSArray*)GetSeasonsByWhereClause:(NSString*)whereClause;
- (NSArray*)GetSeasonsForVideoPath:(VideoPath*)videoPath;
- (NSArray*)GetSeasons;
- (NSArray*)GetEpisodesForVideoPath:(VideoPath*)videoPath;
- (NSArray*)GetEpisodes;
- (NSArray*)GetEpisodesByWhereClause:(NSString*)whereClause;
- (NSArray*)GetMoviesByWhereClause:(NSString*)whereClause ;
- (NSArray*)GetMovies;
- (NSArray*)GetSharesForType:(NSString*)type;
- (NSArray*)SplitMultipart:(NSString*)string;
- (NSArray*)GetDirectory:(NSString*)directory;
- (NSArray*)GetMediaLocationForVideo:(NSString*)directory;
- (NSArray*)GetMediaLocationForMusic:(NSString*)directory;
- (NSArray*)GetMediaLocation:(NSString*)directory mask:(NSString*)mask;
- (NSArray*)GetMediaDataForTVShowFile:(NSString*)file path:(NSString*)path;
- (NSArray*)GetMediaDataForMovieFile:(NSString*)file path:(NSString*)path;
- (NSArray*)GetMediaDataForMusicFile:(NSString*)file path:(NSString*)path;
- (NSString*)SendCommand:(NSString*)command parameters:(NSArray*)parameters;
- (NSString*)SendCommand:(NSString*)command parameter:(NSString*)parameter;

@end
