//
//  imageRecognition.h
//  iphone-app
//
//  Created by Vin on 12/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"

NSMutableData *receivedData;
SBJsonParser *parser;
int updatePollDelayInSeconds;
BOOL pollInProgress;


@interface ImageRecognition : NSObject

- (NSString*) getCurrentTime;

- (NSString*) createApiSignature: (NSString*) string;
- (void) sendImageForRecognition: (UIImage*) filename;
- (NSMutableData*) paramData: (NSString*)name andValue: (NSString*)value;

- (UIImage *)sizedImageToSpecs:(UIImage *)image;

- (NSString *)stringValue:(id)value;

- (UIImage*)imageWithImage:(UIImage*)image 
              scaledToSize:(CGSize)newSize;

@end
