//
//  HistoryViewController.h
//  iphone-new
//
//  Created by Gregory Greyson on 12/4/11.
//  Copyright (c) 2011 University of Pennsylvania. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GData.h"
#import "GDataServiceGoogleYouTube.h"
#import "GDataEntryPhotoAlbum.h"
#import "GDataEntryPhoto.h"
#import "GDataFeedPhoto.h"
#import "GDataEntryYouTubeUpload.h"
#import "GTMOAuth2Authentication.h"
#import "GTMOAuth2ViewControllerTouch.h"

NSArray *historyElements;

@interface HistoryViewController : UITableViewController
    
- (void)fetchEntryImageURLString:(NSString *)urlString;

- (void)imageFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)data error:(NSError *)error;

@end
