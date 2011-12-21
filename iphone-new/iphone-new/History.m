//
//  History.m
//  iphone-new
//
//  Created by Vin on 12/11/11.
//  Copyright (c) 2011 University of Pennsylvania. All rights reserved.
//

#import "History.h"


@implementation History


+ (void) init{
    NSString *localPath = @"Documents/history.archive";
    NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:localPath];
    history = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
    NSLog(@"History loaded %@", history);
    if (history == nil){
        NSLog(@"creating new history");
        history = [[NSMutableArray alloc] init];
    }
}

+ (NSArray*) getEntries{
    [self init];
    return [[NSArray alloc] initWithArray: history];
}

+ (void) addEntry: (HistoryEntry*) entry{
    [self init];
    [history addObject: entry];
    [self commit];
    NSLog(@"History updated: %@", history);
}

+ (void) removeEntry: (HistoryEntry*) entry{
    [self init];
    [history removeObject: entry];
    [self commit];
}

+ (void) commit{
    NSString *localPath = @"Documents/history.archive";
    NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:localPath];
    [NSKeyedArchiver archiveRootObject:history toFile:fullPath];
}

@end
