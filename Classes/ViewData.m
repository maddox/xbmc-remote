//
//  ViewData.m
//  xbmcremote
//
//  Created by David Fumberger on 15/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "ViewData.h"
#import "InterfaceManager.h";
#import "Crc32.h";
#import "Cache.h";

@implementation ViewData
@synthesize file;
@synthesize thumbnail_file;
@synthesize thumbnail_path;
@synthesize title;
@synthesize path;
@synthesize identifier;
@synthesize checkedImage;
@synthesize thumbnail_image;
@synthesize externalImage;
@synthesize maxThumbResolution;
@synthesize checkedCache;
static NSLock *viewlock;
- init {
	if (viewlock == nil) {
		viewlock = [NSLock new];
	}
	return [super init];
}
- initWithDictionary:(NSDictionary *)dict  {
	self.maxThumbResolution = 60;
	self.externalImage = YES;
	self.title       = [dict objectForKey:@"title"];
	self.identifier  = [dict objectForKey:@"id"];
	self.path		 = [dict objectForKey:@"path"];
	self.file		 = [dict objectForKey:@"file"];		
	return [self init];
}


- (UIImage *)scaleImage:(UIImage*)fiximage maxRes:(NSInteger)maxRes
{
	//[lock lock];
	int kMaxResolution = maxRes; // Or whatever
	
	CGImageRef imgRef = fiximage.CGImage;

	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);

	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	if (width > kMaxResolution || height > kMaxResolution) {
		CGFloat ratio = width/height;
		if (ratio > 1) {
			bounds.size.width = kMaxResolution;
			bounds.size.height = bounds.size.width / ratio;
		}
		else {
			bounds.size.height = kMaxResolution;
			bounds.size.width = bounds.size.height * ratio;
		}
	}

	CGFloat scaleRatio = bounds.size.width / width;		
	UIGraphicsBeginImageContext(bounds.size);

	CGContextRef context = CGContextRetain(UIGraphicsGetCurrentContext());
	CGContextScaleCTM(context, scaleRatio, -scaleRatio);
	CGContextTranslateCTM(context, 0, -height);

	CGContextConcatCTM(context, transform);
					
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);	
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	CGContextRelease(context);
	//CGContextRelease(context);	
	//[lock unlock];
	return imageCopy;
}

- (void)setThumbnailFromString:(NSString*)string type:(NSString*)type {
	Crc32 *crc32 = [[Crc32 alloc] init];
	int crc = [crc32 ComputeStringLower:string];
	NSString *thumb = [NSString stringWithFormat:@"%08x", crc];
	char fc = [thumb characterAtIndex:0];
	
	XBMCSettings *xbmcsettings = [[XBMCSettings alloc] init];
	XBMCHostData *data     = [xbmcsettings getActiveHost];
	[xbmcsettings release];
	NSString *xbmcpath;
	if (data != nil && [data.path length] > 0) {
		xbmcpath = data.path;
	} else {
		xbmcpath = @"P:\\";			
	}
	NSString *fullpath;
	NSRange range;
	range = [xbmcpath rangeOfString:@"/"];
	
	if (range.location == NSNotFound) {
		fullpath = [NSString stringWithFormat:@"%@\\Thumbnails\\%@\\%c\\", xbmcpath, type, fc]; 
	} else {
		fullpath = [NSString stringWithFormat:@"%@/Thumbnails/%@/%c/", xbmcpath, type,  fc]; 		
	}
	self.thumbnail_path = fullpath;
	
	self.thumbnail_file = [NSString stringWithFormat:@"%@.tbn", thumb];
	[crc32 release];
	
}
- (NSInteger)cacheType {
	return CACHE_TYPE_VIDEO;
}
- (void)setThumbnailFromPathForType:(NSString*)type {
	[self setThumbnailFromString: self.path type: type];
}
- (void)setThumbnailFromFullFileForType:(NSString*)type {
	[self setThumbnailFromString: [self fullFileName] type:type];
}
- (NSString*)getThumbnailFullFilePath {
	return [NSString stringWithFormat:@"%@%@", self.thumbnail_path, self.thumbnail_file];
}
- (void)setThumbnailFromPath {
	return [self setThumbnailFromPathForType: @"Video"];
}
- (UIImage*)thumbnailImage {
	//[self setThumbnailData];
	if (self.thumbnail_image) {
		return self.thumbnail_image;
	}
	//NSLog(@"Fetching thumbnail image from cache");
	return nil;
}
- (UIImage*)cacheThumbnailMaxRes:(NSInteger)maxRes {
	[viewlock lock];
	BOOL ret = NO;

	RemoteInterface *xbmc = [InterfaceManager getSharedInterface];		
	NSData *data = [xbmc FileDownload:[self getThumbnailFullFilePath]];
	
	if (data) {
		UIImage *image = [UIImage imageWithData:data];
		UIImage *cachedImage = [self scaleImage: image maxRes: maxRes];
		NSData *newdata = UIImageJPEGRepresentation(cachedImage, 1); 
		Cache *cache = [Cache defaultCache];
		[cache storeFile: [NSString stringWithFormat: @"%d%@", maxRes, self.thumbnail_file] data:newdata type:[self cacheType]];
		[viewlock unlock];		
		return cachedImage;

	}
	[viewlock unlock];	
	return nil;
}

- (BOOL)fetchThumbnailCacheMaxRes:(NSInteger)maxRes {
	[self setThumbnailData];		
	NSString *filename = [NSString stringWithFormat: @"%d%@", maxRes, self.thumbnail_file] ;
	Cache *cache = [Cache defaultCache];
	NSData *data;
	self.checkedImage = YES;
	if ([cache hasFile:filename type: [self cacheType]]) {	

		data = [cache getFile:filename type:[self cacheType]];
		if (data) {
			UIImage *img = [UIImage imageWithData:data];
			if (img) {
				self.thumbnail_image = img;
				return YES;
			}
		}
		
	} else {
		UIImage *cachedImage = [self cacheThumbnailMaxRes: maxRes];
		if (cachedImage) {
			self.thumbnail_image = cachedImage;
			return YES;
		}
	}
	return NO;
}
- (void)setThumbnailData {
	if (thumbnail_file == nil) {
		//NSLog(@"Setting thumbnail data");
		[self setThumbnailFromPath];
	}
}
- (BOOL)hasThumbnail {
	return (thumbnail_file != nil); 
}
- (BOOL)thumbnailInCache {
	if (checkedCache) {
		return checkedCache;
	}
	[self setThumbnailData];
	Cache *cache = [Cache defaultCache];
	if ([cache hasFile:self.thumbnail_file type: [self cacheType]]) {
		//NSLog(@"Thumbnail in cache");
		checkedCache = YES;
		return true;
	}
	checkedCache = YES;	
	//NSLog(@"Thumbnail not in cache");	
	return false;
}
- (BOOL)thumbnailInCacheMaxRes:(NSInteger*)maxRes {
	if (checkedCache) {
		return checkedCache;
	}
	[self setThumbnailData];
	Cache *cache = [Cache defaultCache];
	if ([cache hasFile:[NSString stringWithFormat:@"%d%@", maxRes, self.thumbnail_file] type: [self cacheType]]) {
		//NSLog(@"Thumbnail in cache for max res");
		checkedCache = YES;
		return true;
	}
	checkedCache = YES;	
	//NSLog(@"Thumbnail not in cache for max res");	
	return false;
}
- (BOOL)fetchThumbnailIntoCache {
	RemoteInterface *xbmc = [InterfaceManager getSharedInterface];		
	Cache *cache = [Cache defaultCache];	
	NSData *fdata = [xbmc FileDownload:[self getThumbnailFullFilePath]];
	
	if (!fdata) {
		self.checkedImage = YES;
		return NO;
	}
	
	[cache storeFile:self.thumbnail_file data:fdata type:[self cacheType]];
	self.checkedCache = YES;
	return YES;
}

- (BOOL)fetchThumbnailMaxRes:(NSInteger)maxRes {
	[viewlock lock];
	BOOL ret = NO;
	if ([self fetchThumbnail]) {
		UIImage *curr = self.thumbnail_image;
		UIImage *new = [self scaleImage: curr maxRes: maxRes];
		self.thumbnail_image  = nil;
		self.thumbnail_image = new;	
		ret = YES; 
	}
	[viewlock unlock];	
	return ret;
}
- (BOOL)fetchThumbnail {
	[self setThumbnailData];
	if (!self.thumbnail_file) {
		self.checkedImage = YES;
		return NO;
	}
	RemoteInterface *xbmc = [InterfaceManager getSharedInterface];		
	UIImage* img = [xbmc GetThumbnail:[self getThumbnailFullFilePath]];	
	self.thumbnail_image = img;
	self.checkedImage = YES;
	if (!img) {
		return NO;
	}
	return YES;
}

- (UIImage*)defaultImage {
	return [UIImage imageNamed:@"Album.png"];	
}
- (NSString*)fullFileName {
	NSString *fullFileName = [ NSString stringWithFormat: @"%@%@", self.path, self.file ];	
	return fullFileName;
}

-(void) cleanup {
	if (self.thumbnail_image) {
		self.thumbnail_image = nil;
		self.checkedImage = NO;
	}
}
-(void)dealloc {
	//NSLog(@"View data dealloc");	
	[file  release];
	[title release];
	[identifier release];
	[thumbnail_file release];
	[thumbnail_path release];	
	[path release];
	[thumbnail_image release];
	[super dealloc];
}
@end
