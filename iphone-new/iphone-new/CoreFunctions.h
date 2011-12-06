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

GDataServiceGoogleYouTube *service;
GDataFeedYouTubeVideo *currentFeed;
NSString *youTubeQueryURL;    
YouTubeView *youTubeView;

@interface CoreFunctions : NSObject

+ (void) run;

+ (void) setupYoutubeService;

+ (void) queryYoutube: (NSString*) query;

+ (void) processYoutubeResults: (GDataServiceTicket *)ticket
finishedWithFeed:(GDataFeedYouTubeVideo *)feed
error:(NSError *)error;

@end
