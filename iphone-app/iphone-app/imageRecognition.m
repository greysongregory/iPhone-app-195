//
//  imageRecognition.m
//  iphone-app
//
//  Created by Vin on 12/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "imageRecognition.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>


#define IMAGE_REC_URL @"http://api.iqengines.com/v1.2/query/"
#define IMAGE_REC_API_KEY @"94288b6c52cf41ef82ec0ef7c0da00a5"
#define IMAGE_REC_SECRET @"31a85ee648a847f798f58420c4004243"


const NSString *boundary = @"---------------------------14737809831466499882746641449";
@implementation imageRecognition



- (id) init{
	if (self == [super init]) {
		parser = [[SBJsonParser alloc] init];
		updatePollDelayInSeconds = 1;
	}
    
	return self;
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

- (void*) getQueryFromImage: (NSString*) filename{
    
    
    //Setup post params
    
    NSString * timeStamp = [self getCurrentTime];
    NSString * img = filename;
    NSString * api_key = IMAGE_REC_API_KEY;
    NSString * apiSig = [self createApiSignature: IMAGE_REC_SECRET andData:[NSString stringWithFormat:@"api_key%@img%@json1time_stamp%@", api_key, @"duracell1.jpg", timeStamp] ];

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
    
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
	/*
	 now lets create the body of the post
     */
	NSMutableData *body = [NSMutableData data];
    
    
    
    [body appendData: [self paramData: @"api_key", api_key]];
    [body appendData: [self paramData: @"api_sig", apiSig]];
    [body appendData: [self paramData: @"time_stamp", timeStamp]];
    body appendData: [self paramData: @"json", @"1"]];
    
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=img; filename=%@\r\n", @"duracell1.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (NSString*) paramData: (NSString*)name (NSString*)value{
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n%@", value] dataUsingEncoding:NSUTF8StringEncoding]];
}


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
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere;
    
    NSString *responseString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	NSLog(@"Response %@", responseString);	
    
	NSDictionary *rootLevel = [parser objectWithString:responseString];
	NSDictionary *dataLevel = [rootLevel objectForKey:@"data"];
	NSNumber *errorNo = [dataLevel objectForKey:@"error"];
    
    
	if ([errorNo intValue] != 0) {
		NSString *message = [dataLevel objectForKey:@"comment"];
		// at this point we will abort any image id attempts since we dont know which failed
            
		return;
	}
    
	//[self processResults:[dataLevel objectForKey:@"results"]];
    
    
	if ([pendingRequests count] > 0) {
		[self performSelector:@selector(doAsyncCheckRequest) withObject:nil afterDelay:updatePollDelayInSeconds];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}

- (void)doAsyncCheckRequest
{
	// update
	NSURL *url = [NSURL URLWithString:@"http://api.iqengines.com/v1.2/update/"];
	NSString * = [self getUTCFormatedDate];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	request.timeOutSeconds = 90;
	NSString *joinedParams = [NSString stringWithFormat:@"api_key%@json1time_stamp%@", self.key, utcTimestampString];
	NSString *apiSig = [self hmacSha1:joinedParams];
	[request setPostValue:self.key forKey:@"api_key"];
	[request setPostValue:apiSig forKey:@"api_sig"];	
	[request setPostValue:@"1" forKey:@"json"];
	[request setPostValue:utcTimestampString forKey:@"time_stamp"];	
	request.delegate = self;
	NSLog(@"Checking on image requests, %d pending", [pendingRequests count]);
	[request startAsynchronous];
    
}



@end
