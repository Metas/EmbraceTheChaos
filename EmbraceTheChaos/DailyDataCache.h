//
//  DailyDataCache.h
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/30/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyDataCache : NSObject
{
    int D_fCapacity;
    NSMutableDictionary *D_fDictionary;
    NSMutableArray *D_fAge;
}

-(id) initWithCapacity_D:(int) cap;
-(id)objectForKey_D:(id) key;
-(void) setObject_D:(id) value forKey:(id)key;

@end
