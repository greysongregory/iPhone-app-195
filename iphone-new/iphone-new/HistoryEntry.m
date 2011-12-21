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
 
        url =  _url;
        name = _name;
        timeStamp = _timeStamp;
        thumbUrl = _thumbUrl;
        if (_description) {
            description = _description;
        }
        else{
            description = @"N/A";
        }
        
    }
    
    return self;
    
}

- (NSString*) description{
    return @"url: %@ name: %@ timestamp: %@ thumburl: %@ description: %@", url, name, timeStamp, thumbUrl, description;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        url = [aDecoder decodeObjectForKey:@"url"];
        name = [aDecoder decodeObjectForKey:@"name"];
        timeStamp = [aDecoder decodeObjectForKey:@"timeStamp"];
        thumbUrl = [aDecoder decodeObjectForKey:@"thumbUrl"];
        description = [aDecoder decodeObjectForKey:@"description"];
        NSLog(@"url: %@ name: %@ timestamp: %@ thumburl: %@ description: %@", url, name, timeStamp, thumbUrl, description);
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
