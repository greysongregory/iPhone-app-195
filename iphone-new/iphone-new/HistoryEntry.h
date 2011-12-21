//
//  HistoryEntry.h
//  iphone-new
//
//  Created by Vin on 12/5/11.
//  Copyright (c) 2011 University of Pennsylvania. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *url;
NSString *name;
NSString *timeStamp;
NSString *thumbUrl;
NSString *description;


@interface HistoryEntry : NSObject

@property(nonatomic, retain) NSString *url;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *timeStamp;
@property(nonatomic, retain) NSString *thumbUrl;
@property(nonatomic, retain) NSString *description;


- (id)initWithUrl: (NSString*) _url withName: (NSString*)_name withTimeStamp:(NSString*)_timeStamp withThumbUrl:(NSString*)_thumbUrl withDescription: (NSString*) _description;

- (id)initWithCoder:(NSCoder *)aDecoder;

- (NSString*) description;
@end
