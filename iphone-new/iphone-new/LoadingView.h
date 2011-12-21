//
//  LoadingView.h
//  imageintent
//
//  Created by Vin on 12/20/11.
//  Copyright (c) 2011 University of Pennsylvania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"

@class SearchViewController;

SearchViewController *controller;


@interface LoadingView : UIViewController

- (void) setParentView: (SearchViewController*) searchViewController;

- (IBAction)getNextVideo;


@end
