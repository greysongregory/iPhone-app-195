//
//  History.h
//  iphone-new
//
//  Created by Vin on 12/11/11.
//  Copyright (c) 2011 University of Pennsylvania. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HistoryEntry.h"


NSMutableArray *history;

@interface History : NSObject

- (id) init;

- (NSArray*) getEntries;

- (void) addEntry: (HistoryEntry*) entry;

- (void) removeEntry: (HistoryEntry*) entry;

- (void) commit;


@end
