//
//  CoreFunctions.h
//  iphone-app
//
//  Created by Vin on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YouTubeView.h"
#import "GData.h"
#import "GDataFeedPhotoAlbum.h"
#import "GDataFeedPhoto.h"
#import "SearchViewController.h"
#import "History.h"

@class History;

GDataServiceGoogleYouTube *service;
GDataFeedYouTubeVideo *currentFeed;
NSString *youTubeQueryURL;    
YouTubeView *youTubeView;
SearchViewController *uiv;

NSMutableArray *visitedIndices;
NSArray *currentFeedResults; //this may already be currentFeed, in which case we can just use that var

NSNumber *index_obj;

@interface CoreFunctions : NSObject

+ (void) run;

+ (void) setupYoutubeService;

+ (void) queryYoutube: (NSString*) query;

+ (void) queryYoutubeWithLocation: (double)lat andLongitude:(double) lon;

+ (void) processYoutubeResults: (GDataServiceTicket *)ticket
finishedWithFeed:(GDataFeedYouTubeVideo *)feed
error:(NSError *)error;

+ (void) stumbleToNextVideo;

+ (void) fetchEntryImageURLString:(NSString *)urlString;

+ (void) setUIV:(UIViewController*) uivc;

+ (void) imageFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)data error:(NSError *)error;
 
+ (NSString*) getCurrentTime;

@end
