//
//  SearchViewController.h
//  iphone-new
//
//  Created by Gregory Greyson on 12/4/11.
//  Copyright (c) 2011 University of Pennsylvania. All rights reserved.
//

#import "YouTubeView.h"
#import "GData.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SearchViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAccelerometerDelegate, CLLocationManagerDelegate> {
    int takeOrChoose;
    
    int totalReadings;
    int totalX;
    int totalY;
    int totalZ;
    UIAccelerometer *theAccelerometer;
    
    int bpm;
    
    IBOutlet UIButton *takePhoto;
    IBOutlet UIButton *choosePhoto;
    IBOutlet UIButton *accelerometer;
    IBOutlet UIButton *location;
    
    CLLocationManager *locationManager;
    
    NSMutableData *receivedData;

    YouTubeView *youTubeView;
    NSString *youTubeQueryURL;
    GDataFeedYouTubeVideo* currentFeed;
}
- (void) queryYoutube: (NSString*) searchString;
- (void) processYoutubeResults: (GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedYouTubeVideo *)feed error:(NSError *)error;

- (IBAction)takePhoto:(id)sender;
- (IBAction)choosePhoto:(id)sender;
- (IBAction)useAccelerometer:(id)sender;
- (IBAction)useLocation:(id)sender;

- (void)configureAccelerometer;
- (void)sleepAccelerometer;

- (NSDictionary *)userInfo;

- (NSString*) parseBPMDatabaseResult:(int)beatspm;

- (NSString*) httpRequest:(NSString*)httpString;

@property (nonatomic, retain) UIAccelerometer *theAccelerometer;

@property (nonatomic, retain) CLLocationManager *locationManager;


@end
