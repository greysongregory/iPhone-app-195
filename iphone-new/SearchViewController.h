//
//  SearchViewController.h
//  iphone-new
//
//  Created by Gregory Greyson on 12/4/11.
//  Copyright (c) 2011 University of Pennsylvania. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    int takeOrChoose;
    
    IBOutlet UIButton *takePhoto;
    IBOutlet UIButton *choosePhoto;
    IBOutlet UIButton *accelerometer;
    IBOutlet UIButton *location;
    
}

- (IBAction)takePhoto:(id)sender;
- (IBAction)choosePhoto:(id)sender;
- (IBAction)useAccelerometer:(id)sender;
- (IBAction)useLocation:(id)sender;

@end
