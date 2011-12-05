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
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>


#define CLIENT_ID @""
#define CLIENT_SECRET @""
#define DEVKEY @""
#define IMAGE_REC_URL @"http://api.iqengines.com/v1.2/query/"
#define IMAGE_REC_API_KEY @"94288b6c52cf41ef82ec0ef7c0da00a5"
#define IMAGE_REC_SECRET @"31a85ee648a847f798f58420c4004243"


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

#if defined(TARGET_IPHONE_SIMULATOR)
#define LogMethod() printf("%s\n", [[NSString stringWithFormat:@"Simulator-[%@ %s]", self, _cmd] cStringUsingEncoding:NSUTF8StringEncoding]);
#else
#define LogMethod() NSLog(@"-[%@ %s]", self, _cmd])
#endif

void NSPrint (NSString *str)
{
    [str writeToFile:@"/dev/stdout" atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

- (void) doSomething{
    NSPrint(@"Started");
    NSString *appFolderPath = [[NSBundle mainBundle] resourcePath];
    [self getQueryFromImage: [NSString stringWithFormat:@"%@/duracell1.jpg", appFolderPath ]];
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

- (NSString*) getCurrentTime{
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
}

- (NSString*) createApiSignature: (NSString *) key andData: (NSString *) data {
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
	const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
	
	unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
	
	CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
	
	NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
	
    NSString *hash = [HMAC description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
	return hash;
}

- (NSString*) getQueryFromImage: (NSString*) filename{

    
    //Setup post params
 
    NSString * timeStamp = [self getCurrentTime];
    NSString * img = filename;
    NSString * api_key = IMAGE_REC_API_KEY;
    NSString * apiSig = [self createApiSignature: IMAGE_REC_SECRET andData:[NSString stringWithFormat:@"api_key%@img%@json1time_stamp%@", api_key, @"duracell1.jpg", timeStamp] ];

    NSLog([NSString stringWithFormat:@"\napi_key%@img%@json1time_stamp%@", api_key, @"duracell1.jpg\n", timeStamp]);
    
    NSString *params = [NSString stringWithFormat: @"\napi_key=%@&api_sig=%@&img=%@&time_stamp=%@&json=1\n\n", api_key, apiSig, @"duracell1.jpg", timeStamp];
    
    
    NSLog([NSString stringWithFormat: @"\nparams: %@\nsig: %@\n", params, apiSig]);
    /*
	 turning the image into a NSData object
	 getting the image back out of the UIImageView
	 setting the quality to 90
     */
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:img];
	// setting up the URL to post to
	NSString *urlString = IMAGE_REC_URL;
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0);
    
	// setting up the request object now
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
    
	/*
	 add some header info now
	 we always need a boundary when we post a file
	 also we need to set the content type
     
	 You might want to generate a random boundary.. this is just the same
	 as my output from wireshark on a valid html post
     */
	NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
	/*
	 now lets create the body of the post
     */
	NSMutableData *body = [NSMutableData data];
    [body appendData: [params dataUsingEncoding:NSUTF8StringEncoding]];
    
	[body appendData:[[NSString stringWithFormat:@"rn--%@rn",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=img; filename=%@rn", @"duracell1.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-streamrnrn"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"rn--%@--rn",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
    
    NSLog(@"\n\n");
    NSLog(body);
   
	// now lets make the connection to the web
    NSData *responseData;
    responseData = [NSURLConnection sendSynchronousRequest: request returningResponse:nil error:nil];
    NSString *responseText = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(responseText);
    
    
    return nil;
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