//
//  HistoryEntry.m
//  iphone-new
//
//  Created by Vin on 12/5/11.
//  Copyright (c) 2011 University of Pennsylvania. All rights reserved.
//

#import "HistoryEntry.h"

@implementation HistoryEntry

@synthesize url;
@synthesize name;
@synthesize timeStamp;
@synthesize thumbUrl;
@synthesize description;


- (id)initWithUrl: (NSString*) _url withName: (NSString*)_name withTimeStamp:(NSString*)_timeStamp withThumbUrl:(NSString*)_thumbUrl withDescription: (NSString*) _description {
    
    if (self = [super init]) {
 
        url = [[NSString alloc] initWithString: _url];
        name = [[NSString alloc] initWithString: _name];
        timeStamp = [[NSString alloc] initWithString: _timeStamp];
        thumbUrl = [[NSString alloc] initWithString: _thumbUrl];
        description = [[NSString alloc] initWithString: _description];
        
    }
    
    return self;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        url = [aDecoder decodeObjectForKey:@"url"];
        name = [aDecoder decodeObjectForKey:@"name"];
        timeStamp = [aDecoder decodeObjectForKey:@"timeStamp"];
        thumbUrl = [aDecoder decodeObjectForKey:@"thumbUrl"];
        description = [aDecoder decodeObjectForKey:@"description"];
        
    }
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:url forKey:@"url"];
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:timeStamp forKey:@"timeStamp"];
    [aCoder encodeObject:thumbUrl forKey:@"thumbUrl"];
    [aCoder encodeObject:description forKey:@"description"];
    
}

@end
