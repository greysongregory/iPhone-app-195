//
//  CoreFunctions.m
//  iphone-app
//
//  Created by Vin on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CoreFunctions.h"
#import "GDataServiceGoogleYouTube.h"
#import "GDataEntryPhotoAlbum.h"
#import "GDataEntryPhoto.h"
#import "GDataFeedPhoto.h"
#import "GDataEntryYouTubeUpload.h"
#import "GTMOAuth2Authentication.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "ImageRecognition.h"


#define CLIENT_ID @""
#define CLIENT_SECRET @""
#define DEVKEY @""



//contains all of the methods and functionality related to our application
@implementation CoreFunctions



/*Possible methods

URL findVideo(query, options)

//Image recognition
query getQueryFromImage(filename)
 
/accelerometer
accel recordAccel()
 
bpm getBPMFromAccel
 
query getQueryFromBPM
 
//location
location getLocation()
 
URL findVideoByLocation(location)

*/

- (void) run{
    NSPrint(@"Started");
    ImageRecognition *imgRec = [[ImageRecognition alloc] init];
}

GDataFeedYouTubeVideo *mEntriesFeed; // user feed of album entries
GDataServiceTicket *mEntriesFetchTicket;
NSError *mEntriesFetchError;
NSString *mEntryImageURLString;

GDataServiceTicket *mUploadTicket;
NSURL *mUploadLocationURL;

static NSString *const kKeychainItemName = @"YouTubeSample: YouTube";


- (void) setupYoutubeService{
    NSString *clientID = CLIENT_ID;
    NSString *clientSecret = CLIENT_SECRET;
    
    if (!service) {
        service = [[GDataServiceGoogleYouTube alloc] init];
        
        [service setShouldCacheResponseData:YES];
        [service setServiceShouldFollowNextLinks:YES];
        [service setIsServiceRetryEnabled:YES];
    }
    
    NSString *devKey = DEVKEY;
    [service setYouTubeDeveloperKey: devKey];
    
    //GTMOAuth2Authentication *auth;
    //auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
    //                                                          clientID:clientID
     //                                                     clientSecret:clientSecret];
    //[[self youTubeService] setAuthorizer:auth];
    
    
}



- (void) queryYoutube: (NSString*) searchString{
    NSPrint( (@"querying youtube with %@\n",searchString) );
    
    NSURL *feedURL = [GDataServiceGoogleYouTube youTubeURLForFeedID:nil];
    
    GDataQueryYouTube* query = [GDataQueryYouTube  youTubeQueryWithFeedURL:feedURL];
    
    [query setVideoQuery:searchString];
    
    [query setMaxResults:15];
    GDataServiceTicket *request;
    
    request = [service fetchFeedWithQuery:query delegate:self didFinishSelector:@selector(processYoutubeResults:finishedWithFeed:error:)];
    
    [request setShouldFollowNextLinks:NO];
    
}

- (void) processYoutubeResults: (GDataServiceTicket *)ticket
              finishedWithFeed:(GDataFeedYouTubeVideo *)feed
                         error:(NSError *)error{
    if (error){
        NSPrint([error description]);
    }
    NSPrint([feed debugDescription]);
    cuurentFeed = feed;
}

@end