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
#import "LoadingView.h"
#import "AccelerometerView.h"

@class ImageRecognition;
@class LoadingView;
@class AccelerometerView;

@interface SearchViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAccelerometerDelegate, CLLocationManagerDelegate> {
    int takeOrChoose;
    
    int totalReadings;
    double totalX;
    double totalY;
    double totalZ;
    UIAccelerometer *theAccelerometer;
    
    
    AccelerometerView *accelView;
    
    int bpm;
    
    
    double lat; 
    double lon;
    
    
    IBOutlet UIButton *takePhoto;
    IBOutlet UIButton *choosePhoto;
    IBOutlet UIButton *accelerometer;
    IBOutlet UIButton *location;
    IBOutlet UIButton *nextVideo;
    
    CLLocationManager *locationManager;
    
    NSMutableData *receivedData;
    @public UIActivityIndicatorView *activityIndicator;
    @public LoadingView *loadingView;
}

- (IBAction)takePhoto:(id)sender;
- (IBAction)choosePhoto:(id)sender;
- (IBAction)useAccelerometer:(id)sender;
- (IBAction)useLocation:(id)sender;
- (void) getNextVideo;

- (void)setupAccelerometer;
- (void)sleepAccelerometer;

- (void) startRecordingAccel;
- (void) stopRecordingAccel;


- (IBAction)useAccelerometer;

- (void) showProgressPage: (UIViewController*) controller;

- (void) sendImage: (UIImage*) image;

- (NSDictionary *)userInfo;

- (NSString*) parseBPMDatabaseResult:(int)beatspm;

- (NSString*) httpRequest:(NSString*)httpString;

@property (nonatomic, retain) UIAccelerometer *theAccelerometer;

@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, retain) ImageRecognition *ir;

@property (nonatomic, retain) LoadingView *loadingView;

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@end
