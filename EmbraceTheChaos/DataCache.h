//
//  DataCache.h
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/30/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCache : NSObject
{
    int fCapacity;
    NSMutableDictionary *fDictionary;
    NSMutableArray *fAge;
}

-(id) initWithCapacity:(int) cap;
-(id)objectForKey:(id) key;
-(void) setObject:(id) value forKey:(id)key;

@end
