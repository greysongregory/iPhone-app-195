//
//  SearchViewController.m
//  iphone-new
//
//  Created by Gregory Greyson on 12/4/11.
//  Copyright (c) 2011 University of Pennsylvania. All rights reserved.
//

#import "SearchViewController.h"
#import "CoreFunctions.h"
#import "ImageRecognition.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "LoadingView.h"

//#import "UIImagePickerController.h"
#define kAccelerometerFrequency        50.0 //Hz
#define kFilteringFactor 0.1

#define youTubeMaxResults 15

#define CLIENT_ID @""
#define CLIENT_SECRET @""
#define DEVKEY @""

@implementation SearchViewController

@synthesize theAccelerometer;
@synthesize locationManager;
@synthesize ir;



- (IBAction)takePhoto:(id)sender
{
    takeOrChoose = 1;   
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES)
    {
        NSLog(@"Camera is available and ready");
        // Create image picker controller
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
        // Set source to the camera
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
        // Delegate is self
        imagePicker.delegate = self;
    
        // Allow editing of image ?
        imagePicker.allowsImageEditing = NO;
    
        // Show image picker
        [self presentModalViewController:imagePicker animated:YES];
        NSLog(@"camera end");
    }
    else
        NSLog(@"Camera is not available");


}

- (IBAction)choosePhoto:(id)sender
{
    takeOrChoose = 0;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == YES)
    {
        NSLog(@"Photo Library is available and ready");
        UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
        mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        mediaUI.allowsEditing = NO;
        
        mediaUI.delegate = self;
        [self presentModalViewController: mediaUI animated: YES];
    //make request for IQ image recognition, parse result, make youtube request
    }
}

- (IBAction)useAccelerometer:(id)sender
{
    //reset values from last accelerometer reading and request
    totalReadings = 0;
    totalX = 0;
    totalY = 0;
    totalZ = 0;
    [self configureAccelerometer];
    /*
    [NSTimer scheduledTmerWithTimeInterval:2.0
                                        target:self
                                        selector:@selector(sleepAccelerometer)
                                        userInfo:[self userInfo]
                                        repeats:NO];
     */
    //need to wait for 2+ seconds here...
    [NSThread sleepForTimeInterval:2.0];
    [self sleepAccelerometer];
    //each average should be between 0 and 2.3, based on the max value the accelerometer returns (i *think* it's 2.3)
    if (totalReadings == 0)
        totalReadings++;
    totalX /= totalReadings;
    totalY /= totalReadings;
    totalZ /= totalReadings;
    //added, we have a number between 0 and 6.9. bpm is in a range of ~60-200
    bpm = ((totalX + totalY + totalZ)*20) + 60;
    
    //make request to bpm database, parse result, make youtube request.
    //search bpm database with url request similar to:
    //  http://bpmdatabase.com/search.php?begin=1&num=2&numBegin=1&artist=&title=&mix=&bpm=68&gid=&label=&year=&srt=artist&ord=asc
    // set begin to random number % total results, and bpm to the bpm calculated above
    NSString* artistAndTitle = [self parseBPMDatabaseResult:bpm];
    
    //query youtube here with artistAndTitle as the search string
    [CoreFunctions setUIV:self];
    
    [CoreFunctions queryYoutube:artistAndTitle];

}

- (IBAction)useLocation:(id)sender
{
    if (nil == locationManager)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;   
    }
    [locationManager startUpdatingLocation];
    CLLocation *currentLocation = [locationManager location];
    CLLocationCoordinate2D coordinate = [currentLocation coordinate];
    double lat = coordinate.latitude;
    double lon = coordinate.longitude;
    [locationManager stopUpdatingLocation];

    
    //make youtube request with lat and long variables
    [CoreFunctions queryYoutubeWithLocation: lat andLongitude: lon];
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"DIDfinishpicking\n");
	if(takeOrChoose)
    {
        NSError *error;
    
        // Access the uncropped image from info dictionary
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            // Create paths to output images
        NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.jpg"];
    
        // Write a UIImage to JPEG with minimum compression (best quality)
        // The value 'image' must be a UIImage object
        // The value '1.0' represents image compression quality as value from 0.0 to 1.0
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
        
        // Write image to PNG
        [UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
    
        // Let's check to see if files were successfully written...
        // You can try this when debugging on-device
        
        // Create file manager
        NSFileManager *fileMgr = [NSFileManager defaultManager];
    
        // Point to Document directory
        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
        // Write out the contents of home directory to console
        NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
    
    
        //DO IMAGE RECOGNITION AND YOUTUBE QUERY HERE
        ir = [[ImageRecognition alloc]initWithImageAndView:image :self];
        image = [ir sizedImageToSpecs:image];
        
        [ir sendImageForRecognition:image];
        
        
        [self dismissModalViewControllerAnimated:YES];
    
    
    }
    else
    {
        NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
        UIImage *originalImage, *editedImage, *imageToUse;
        
        // Handle a still image picked from a photo album,
        //__bridge handles casting
        if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) 
        {
            editedImage = (UIImage *) [info objectForKey:
                                       UIImagePickerControllerEditedImage];
            originalImage = (UIImage *) [info objectForKey:
                                         UIImagePickerControllerOriginalImage];
            
            if (editedImage) {
                imageToUse = editedImage;
            } else {
                imageToUse = originalImage;
            }
         
            
            // Do something with imageToUse
            //DO IMAGE RECOGNITION AND YOUTUBE QUERY HERE
        
        
        }
        
        [[picker parentViewController] dismissModalViewControllerAnimated: YES];
        //   [picker release];
    }
}

-(void)configureAccelerometer
{
    theAccelerometer = [UIAccelerometer sharedAccelerometer];
    theAccelerometer.updateInterval = 1 / kAccelerometerFrequency;
    
    theAccelerometer.delegate = self;
    // Delegate events begin immediately.
}

-(void)sleepAccelerometer
{
    theAccelerometer.delegate = nil;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    UIAccelerationValue x, y, z;
    x = acceleration.x;
    y = acceleration.y;
    z = acceleration.z;
    
    // Do something with the values.
    totalReadings++;
    totalX += abs(x);
    totalY += abs(y);
    totalZ += abs(z);
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (NSString*) parseBPMDatabaseResult:(int)beatspm
{
    //request format:  http://bpmdatabase.com/search.php?begin=1&num=2&numBegin=1&artist=&title=&mix=&bpm=68&gid=&label=&year=&srt=artist&ord=asc
    NSString* firstRequest = [NSString stringWithFormat:@"http://bpmdatabase.com/search.php?begin=0&num=2&numBegin=1&artist=&title=&mix=&bpm=%d&gid=&label=&year=&srt=artist&ord=asc", beatspm];
    //make http request, assign it to a variable then use this regex: of <b>88</b> result
    NSLog(firstRequest);
    NSString* http = [self httpRequest:firstRequest]; //change null to request result
    NSLog(http);
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"of <b>(\\d{1,3})</b> results"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSTextCheckingResult *res = [regex firstMatchInString:http options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [http length])];
    NSString* resString = [http substringWithRange:[res rangeAtIndex:1]];
    
    //NSLog(res);
    NSLog(resString);
    
    int numSongs = [resString intValue];
    int songIndex = arc4random()%numSongs;
    //make next http request, with index as begin get param
    NSString* secondRequest = [NSString stringWithFormat:@"http://bpmdatabase.com/search.php?begin=%d&num=2&numBegin=1&artist=&title=&mix=&bpm=%d&gid=&label=&year=&srt=artist&ord=asc", songIndex, beatspm];
    http = [self httpRequest:secondRequest];; //change to result of second request
    NSRegularExpression *regexTwo = [NSRegularExpression regularExpressionWithPattern:@"<tr class=\"line\\d\"><td>(.+?)<\/td><td>(.+?)<\/td>"
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                            error:&error];
    NSArray *matches = [regexTwo matchesInString:http options:0 range:NSMakeRange(0, [http length])];
    NSTextCheckingResult *matchOne = [matches objectAtIndex:0];
    NSTextCheckingResult *matchTwo = [matches objectAtIndex:0];
    
    NSString* artist = [http substringWithRange:[matchOne rangeAtIndex:1]];
    NSString* title = [http substringWithRange:[matchTwo rangeAtIndex:2]];
    //create string to query youtube with using the first two elements of *matches
    NSLog(artist);
    NSLog(title);
    
    NSString* artistWithTitle =  [NSString stringWithFormat:@"%@ %@", artist, title]; //replace with *matches elements
    return artistWithTitle;
}

//Timer Methods
- (NSDictionary *)userInfo {
    return [NSDictionary dictionaryWithObject:[NSDate date] forKey:@"StartDate"];
}

- (void)targetMethod:(NSTimer*)theTimer {
    
    NSDate *startDate = [[theTimer userInfo] objectForKey:@"StartDate"];
    NSLog(@"Timer started on %@", startDate);
}

- (void)invocationMethod:(NSDate *)date {
    
    NSLog(@"Invocation for timer started on %@", date);
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [CoreFunctions setupYoutubeService];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//HTTP REQUEST METHODS
// Create the request.
- (NSString*) httpRequest:(NSString*)httpString
{
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:httpString]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    NSData* requestData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
   // NSString* encodingName = [[NSString alloc] initWithString:[theRequest textEncodingName]];
   // NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((CFStringRef) encodingName));
    
    NSString* test = [[NSString alloc] initWithData:requestData encoding:NSASCIIStringEncoding];
    NSLog(test);
    return test;
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

- (NSString*)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded: %@", [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}


@end
