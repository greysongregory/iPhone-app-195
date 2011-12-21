//
//  imageRecognition.m
//  iphone-app
//
//  Created by Vin on 12/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageRecognition.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>
#import "IQResult.h"
#import "CoreFunctions.h"

#define IMAGE_REC_URL @"http://api.iqengines.com/v1.2/query/"
#define IMAGE_REC_API_KEY @"94288b6c52cf41ef82ec0ef7c0da00a5"
#define IMAGE_REC_SECRET @"31a85ee648a847f798f58420c4004243"
#define IMAGE_REC_POLL_URL @"http://api.iqengines.com/v1.2/update/"
#define MAX_PIXELS 636.0

const NSString *boundary = @"---------------------------14737809831466499882746641449";
@implementation ImageRecognition



- (id) initWithImage:(UIImage*) img{
    self = [super init];
    parser = [[SBJsonParser alloc] init];
    updatePollDelayInSeconds = 1;
    pollInProgress = NO;
    receivedData = [NSMutableData data];
    //NSString *img = [NSString stringWithFormat: @"%@/iphone-new.app/duracell1.jpg", NSHomeDirectory()];
    //[self sendImageForRecognition: [[UIImage alloc] initWithContentsOfFile:img]];
	return self;
}

- (id) initWithImageAndView:(UIImage*) img: (UIViewController*) view{
    self = [super init];
    parser = [[SBJsonParser alloc] init];
    updatePollDelayInSeconds = 1;
    pollInProgress = NO;
    receivedData = [NSMutableData data];
    viewController = view;
    //NSString *img = [NSString stringWithFormat: @"%@/iphone-new.app/duracell1.jpg", NSHomeDirectory()];
    //[self sendImageForRecognition: [[UIImage alloc] initWithContentsOfFile:img]];
	return self;
}

- (NSString*) getSearchString{
    return searchString;
}

/*-------------------------IMAGE RECOGNITION METHODS--------------------------------*/

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

- (void) sendImageForRecognition: (UIImage*) image{
    
    
    //Setup post params
    
    NSString * timeStamp = [self getCurrentTime];
 //   NSString * filename = "";
    NSString * api_key = IMAGE_REC_API_KEY;
    NSString * apiSig = [self createApiSignature: IMAGE_REC_SECRET andData:[NSString stringWithFormat:@"api_key%@img%@json1time_stamp%@", api_key, @"duracell1.jpg", timeStamp] ];

    /*
	 turning the image into a NSData object
	 getting the image back out of the UIImageView
	 setting the quality to 90
     */
    image = [self sizedImageToSpecs: image];
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
    
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
	/*
	 now lets create the body of the post
     */
	NSMutableData *body = [NSMutableData data];
    
    
    
    [body appendData: [self paramData: @"api_key" andValue: api_key]];
    [body appendData: [self paramData: @"api_sig"andValue: apiSig]];
    [body appendData: [self paramData: @"time_stamp" andValue: timeStamp]];
    [body appendData: [self paramData: @"json" andValue: @"1"]];
    
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=img; filename=%@\r\n", @"duracell1.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (NSMutableData*) paramData: (NSString*)name andValue: (NSString*)value{
    NSMutableData *data = [NSMutableData data];
    [data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"\r\n%@", value] dataUsingEncoding:NSUTF8StringEncoding]];
    return data;
}





- (void)processResults:(NSArray *)results{
    
	if (results == nil) {
		return;
	}
    
    IQResult *result;
    
	NSDictionary *dict = [results objectAtIndex: 0];
    NSString *sig = [dict objectForKey:@"qid"];
    NSDictionary *properties = [dict objectForKey:@"qid_data"];
    result = [[IQResult alloc]initWithSignature:sig];

    result.color = [self stringValue:[properties objectForKey:@"color"]];
    result.isbn = [self stringValue:[properties objectForKey:@"isbn"]];
    result.labels = [self stringValue:[properties objectForKey:@"labels"]];
    result.sku = [self stringValue:[properties objectForKey:@"sku"]];
    result.upc = [self stringValue:[properties objectForKey:@"upc"]];
    result.url = [self stringValue:[properties objectForKey:@"url"]];
	
    pollInProgress = NO;
    searchString = result.labels;
    NSLog(searchString);

    [CoreFunctions setUIV:viewController];
    [CoreFunctions queryYoutube:searchString];
}

- (UIImage *)sizedImageToSpecs:(UIImage *)image
{	
    
	int width = image.size.width;
	int height = image.size.height;
    
	// it is already within limits so return what was passed in
	if (width < 640 && height < 640 ) {
		return image; 
	}
    
	// at least one size is over the limit, resize based on largest side
	double adjustFactor;
	if (width < height) {
		//its height is bigger, bring it under limit
		adjustFactor = (double)  MAX_PIXELS / height;
	}else {
		//its width is bigger, bring it under limits
		adjustFactor = (double)  MAX_PIXELS / width;
	}
    
	// maintain aspect
	CGSize newSize; 
	newSize.height = height * adjustFactor;
	newSize.width = width * adjustFactor;
    
	return [self imageWithImage:image scaledToSize:newSize];
}



- (UIImage*)imageWithImage:(UIImage*)image 
              scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (NSString *)stringValue:(id)value{
    
	if(value == nil){
		return @"";
	}else {
		return (NSString *)value;
	}
    
}

- (void)doAsyncCheckRequest
{
    //Setup post params
    NSString *urlString = IMAGE_REC_POLL_URL;
    
    NSString * timeStamp = [self getCurrentTime];
    NSString * api_key = IMAGE_REC_API_KEY;
    NSString * apiSig = [self createApiSignature: IMAGE_REC_SECRET andData:[NSString stringWithFormat:@"api_key%@json1time_stamp%@", api_key, timeStamp] ];
    
    NSString *postParams = [[NSString alloc] initWithFormat:@"api_key=%@&api_sig=%@&json=1&time_stamp=%@", api_key, apiSig, timeStamp];
    
    
    // setting up the request object now
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
    [request setTimeoutInterval: 90];
    

    [request setHTTPBody:[postParams dataUsingEncoding:NSUTF8StringEncoding]];
     NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"Sending poll request");
}



/*--------------------HTTP Request callbacks----------------*/


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@\n",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    NSString *responseString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	NSLog(@"Response1: %@\n", responseString);	
    
    
    NSDictionary *rootLevel = [parser objectWithString:responseString];
    NSDictionary *dataLevel = [rootLevel objectForKey:@"data"];
    
    if (pollInProgress){
        NSArray *results = [dataLevel objectForKey:@"results"];
        if (results != nil){
            [self processResults: results];
        }
        else{
            [self performSelector:@selector(doAsyncCheckRequest) withObject:nil afterDelay:updatePollDelayInSeconds];
        }
    }
    else{
        
        NSNumber *errorNo = [dataLevel objectForKey:@"error"];
        if ([errorNo intValue] != 0) {
            NSString *message = [dataLevel objectForKey:@"comment"];
            // at this point we will abort any image id attempts since we dont know which failed
            
            return;
        }
        pollInProgress = YES;
        [self performSelector:@selector(doAsyncCheckRequest) withObject:nil afterDelay:updatePollDelayInSeconds];
    }
    
    //youtube stuff?

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}

/*--------------------------------------------------------------*/
@end
