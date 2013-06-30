//
//  DailyDataCache.m
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/30/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import "DailyDataCache.h"

@implementation DailyDataCache


-(id)initWithCapacity_D:(int)cap
{
    if(nil != (self=[super init]))
    {
        D_fCapacity =cap;
        D_fDictionary =[[NSMutableDictionary alloc] initWithCapacity:cap];
        D_fAge = [[NSMutableArray alloc]initWithCapacity:cap];
    }
    return self;
}
-(void) dealloc
{
    D_fAge = nil;
    D_fDictionary =nil;
}

-(id)objectForKey_D:(id)key
{
    // Pull key out of age array and move to front, indicates recently used
	NSUInteger index = [D_fAge indexOfObject:key];
	if (index == NSNotFound) return nil;
	if (index != 0) {
		[D_fAge removeObjectAtIndex:index];
		[D_fAge insertObject:key atIndex:0];
	}
    
	return [D_fDictionary objectForKey:key];
}

-(void)setObject_D:(id)value forKey:(id)key
{
    // Update the age of the inserted object and delete the oldest if needed
	NSUInteger index = [D_fAge indexOfObject:key];
	if (index != 0) {
		if (index != NSNotFound) {
			[D_fAge removeObjectAtIndex:index];
		}
		[D_fAge insertObject:key atIndex:0];
		
		if ([D_fAge count] > D_fCapacity) {
			id delKey = [D_fAge lastObject];
			[D_fDictionary removeObjectForKey:delKey];
			[D_fAge removeLastObject];
		}
	}
    
	[D_fDictionary setObject:value forKey:key];

}
@end
