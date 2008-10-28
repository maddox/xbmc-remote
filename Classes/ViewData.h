//
//  ViewData.h
//  xbmcremote
//
//  Created by David Fumberger on 15/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewData : NSObject {
	NSString *title;
	NSString *identifier;
	NSString *thumbnail_path;
	NSString *thumbnail_file;
	NSString *path;
	NSString *file;	
	UIImage  *thumbnail_image;
	BOOL     checkedImage;
	BOOL	 checkedCache;
	NSInteger maxThumbResolution;
	BOOL     externalImage;
}
- initWithDictionary:(NSDictionary *)dict ;
- (UIImage*)defaultImage;
- (BOOL)fetchThumbnail ;
- (BOOL)fetchThumbnailMaxRes:(NSInteger)maxRes;
- (BOOL)fetchThumbnailIntoCache;
- (BOOL)thumbnailInCache;
-(BOOL)hasThumbnail;
- (UIImage*)thumbnailImage;
- (NSString*)getThumbnailFullFilePath;
- (NSString*)fullFileName;
- (BOOL)fetchImageFromCache;
- (void)setThumbnailData;
-(void) cleanup;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSString *thumbnail_path;
@property (nonatomic, retain) NSString *thumbnail_file;
@property (nonatomic, retain) UIImage  *thumbnail_image;
@property (nonatomic, retain) NSString  *path;
@property (nonatomic, retain) NSString  *file;
@property (nonatomic, assign) BOOL checkedImage;
@property (nonatomic, assign) BOOL checkedCache;
@property (nonatomic, assign) BOOL externalImage;
@property (nonatomic, assign) NSInteger maxThumbResolution;
@end
