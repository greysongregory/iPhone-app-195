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
#import "HistoryEntry.h"

#define CLIENT_ID @""
#define CLIENT_SECRET @""
#define DEVKEY @""
#define youTubeMaxResults 15
#define LOCATION_RADIUS @"20m"



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

+ (void) run{
    NSLog(@"Started");
    ImageRecognition *imgRec = [[ImageRecognition alloc] init];
}

GDataFeedYouTubeVideo *mEntriesFeed; // user feed of album entries
GDataServiceTicket *mEntriesFetchTicket;
NSError *mEntriesFetchError;
NSString *mEntryImageURLString;

GDataServiceTicket *mUploadTicket;
NSURL *mUploadLocationURL;

static NSString *const kKeychainItemName = @"YouTubeSample: YouTube";


+ (void) setupYoutubeService{
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


+ (void) queryYoutubeWithLocation: (double)lat andLongitude:(double) lon{
    NSLog( [NSString stringWithFormat: @"querying youtube with latitude: %f longitude: %f\n",lat, lon]);
    
    NSURL *feedURL = [GDataServiceGoogleYouTube youTubeURLForFeedID:nil];
    
    GDataQueryYouTube* query = [GDataQueryYouTube  youTubeQueryWithFeedURL:feedURL];
    
    [query setLocation:[NSString stringWithFormat:@"%f,%f", lat, lon]];
    [query setLocationRadius:LOCATION_RADIUS];
    
    [query setMaxResults:youTubeMaxResults];
    GDataServiceTicket *request;
    
    request = [service fetchFeedWithQuery:query delegate:self didFinishSelector:@selector(processYoutubeResults:finishedWithFeed:error:)];
    
    [request setShouldFollowNextLinks:NO];
    
}

+ (void) queryYoutube: (NSString*) searchString{
    youTubeView = nil;
    NSLog( (@"querying youtube with %@\n",searchString) );
    
    NSURL *feedURL = [GDataServiceGoogleYouTube youTubeURLForFeedID:nil];
    
    GDataQueryYouTube* query = [GDataQueryYouTube  youTubeQueryWithFeedURL:feedURL];
    
    [query setVideoQuery:searchString];
    
    [query setMaxResults:youTubeMaxResults];
    GDataServiceTicket *request;
    
    request = [service fetchFeedWithQuery:query delegate:self didFinishSelector:@selector(processYoutubeResults:finishedWithFeed:error:)];
    
    [request setShouldFollowNextLinks:NO];
    
}

+ (void) processYoutubeResults: (GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedYouTubeVideo *)feed error:(NSError *)error
{
    if (error){
        NSLog([error description]);
    }
    NSLog([feed debugDescription]);
    currentFeed = feed;
    
    //parse result and grab a random youtube video here
    int index = arc4random()%youTubeMaxResults; //this could give us out of bounds error if number of results is less than youTubeMaxResults
        
    GDataEntryBase* entry = [currentFeed entryAtIndex:index];
    GDataEntryYouTubeVideo *video = (GDataEntryYouTubeVideo *)entry;
    GDataMediaThumbnail *thumbnail = [[video mediaGroup] highQualityThumbnail];
    NSString *imageURLString;
    if (thumbnail != nil) {
        imageURLString = [thumbnail URLString];
        if (imageURLString) {
            [CoreFunctions fetchEntryImageURLString:imageURLString];
        }
    }
    GDataLink* link = [entry HTMLLink];
    youTubeQueryURL = [link href];
    
    NSLog(@"Choosing url: %@", link);
    
    HistoryEntry *histEntry = [[HistoryEntry alloc] initWithUrl: youTubeQueryURL withName: [[entry title] stringValue] withTimeStamp: [CoreFunctions getCurrentTime] withThumbUrl: imageURLString withDescription: [[entry summary]stringValue]];
    [history addObject: histEntry];
    
    //display link to play video
    YouTubeView *youTubeView = [[YouTubeView alloc] 
                                initWithStringAsURL:youTubeQueryURL 
                                frame:CGRectMake(100, 170, 120, 120)];
    
    [[uiv view] addSubview:youTubeView];
    
 //   youTubeView = [[YouTubeView alloc] initWithStringAsURL:youTubeQueryURL];
    
    //display view
    //UIView *thisView = (UIView*)[self.view viewWithTag:99];
 //   [[uiv view] addSubview:youTubeView];
}

+ (NSString*) getCurrentTime{
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
+ (void) setUIV:(UIViewController*) uivc
{
    uiv = uivc;
}

//--------thumbnail functions-----------//


- (void)fetchEntryImageURLString:(NSString *)urlString {
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:urlString];
    [fetcher setComment:@"thumbnail"];
    [fetcher beginFetchWithDelegate:self
                  didFinishSelector:@selector(imageFetcher:finishedWithData:error:)];
}

- (void)imageFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)data error:(NSError *)error {
    if (error == nil) {
        // got the data; display it in the image view
        //NSImage *image = [[[NSImage alloc] initWithData:data] autorelease];
        
       // [mEntryImageView setImage:image];
    } else {
        NSLog(@"imageFetcher:%@ failedWithError:%@", fetcher,  error);
    }
}


@end