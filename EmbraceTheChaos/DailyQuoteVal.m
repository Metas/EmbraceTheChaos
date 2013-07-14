//
//  DailyQuoteVal.m
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 7/13/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import "DailyQuoteVal.h"

@implementation DailyQuoteVal
@synthesize quoteID;
-(id) initWithQuoteID:(int)quoteNum 
{
    self.quoteID = quoteNum;

    return self;
}


@end
