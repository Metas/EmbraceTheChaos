//
//  DataCache.m
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/30/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import "DataCache.h"

@implementation DataCache

-(id)initWithCapacity:(int)cap
{
    if(nil != (self=[super init]))
    {
        fCapacity =cap;
        fDictionary =[[NSMutableDictionary alloc] initWithCapacity:cap];
        fAge = [[NSMutableArray alloc]initWithCapacity:cap];
    }
    return self;
}

-(void) dealloc
{
    fAge = nil;
    fDictionary =nil;
}

- (id)objectForKey:(id)key
{
	// Pull key out of age array and move to front, indicates recently used
	NSUInteger index = [fAge indexOfObject:key];
	if (index == NSNotFound) return nil;
	if (index != 0) {
		[fAge removeObjectAtIndex:index];
		[fAge insertObject:key atIndex:0];
	}
    
	return [fDictionary objectForKey:key];
}

- (void)setObject:(id)value forKey:(id)key
{
	// Update the age of the inserted object and delete the oldest if needed
	NSUInteger index = [fAge indexOfObject:key];
	if (index != 0) {
		if (index != NSNotFound) {
			[fAge removeObjectAtIndex:index];
		}
		[fAge insertObject:key atIndex:0];
		
		if ([fAge count] > fCapacity) {
			id delKey = [fAge lastObject];
			[fDictionary removeObjectForKey:delKey];
			[fAge removeLastObject];
		}
	}
    
	[fDictionary setObject:value forKey:key];
}



@end
