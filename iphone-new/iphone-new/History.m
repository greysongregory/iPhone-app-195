//
//  History.m
//  iphone-new
//
//  Created by Vin on 12/11/11.
//  Copyright (c) 2011 University of Pennsylvania. All rights reserved.
//

#import "History.h"


@implementation History


- (id) init{
    history = [NSKeyedUnarchiver unarchiveObjectWithFile:@"/history.archive"];
}

- (NSArray*) getEntries{
    return [[NSArray alloc] initWithArray: history];
}

- (void) addEntry: (HistoryEntry*) entry{
    [history addObject: entry];
}

- (void) removeEntry: (HistoryEntry*) entry{
    [history removeObject: entry];
}

- (void) commit{
    [NSKeyedArchiver archiveRootObject:history toFile:@"/history.archive"];
}

@end
