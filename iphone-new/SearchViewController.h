//
//  SearchViewController.h
//  iphone-new
//
//  Created by Gregory Greyson on 12/4/11.
//  Copyright (c) 2011 University of Pennsylvania. All rights reserved.
//

#import "YouTubeView.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

#import "GData.h"
#import "GDataFeedPhotoAlbum.h"
#import "GDataFeedPhoto.h"

@class ImageRecognition;

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
}

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

@property (nonatomic, retain) ImageRecognition *ir;

@end
