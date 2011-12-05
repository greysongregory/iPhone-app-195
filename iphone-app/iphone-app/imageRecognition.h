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



@interface imageRecognition : NSObject

- (NSString*) getCurrentTime;

- (NSString*) createApiSignature: (NSString*) string;
- (NSString*) getQueryFromImage: (NSString*) filename;

@end
