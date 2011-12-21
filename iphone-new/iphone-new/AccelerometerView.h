//
//  AccelerometerView.h
//  imageintent
//
//  Created by Vin on 12/20/11.
//  Copyright (c) 2011 University of Pennsylvania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"

@class SearchViewController;

SearchViewController *controller;

@interface AccelerometerView : UIViewController

- (IBAction)touchDown;
- (IBAction)touchUp;

- (void) setParent: (SearchViewController*) searchViewcontroller;

@property (weak, nonatomic) IBOutlet UIProgressView *xProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *yProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *zProgress;

@end
