//
//  Favorite_Mdl.m
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/23/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import "Favorite_Mdl.h"

@implementation Favorite_Mdl

@synthesize quoteID;
@synthesize topicID;
@synthesize quote;
@synthesize topic;

-(id) initWithQuoteID:(int)quoteNum topicID:(int)tpcId topic:(NSString *)tpk quote:(NSString *)quot
{
    self.quoteID = quoteNum;
    self.topicID = tpcId;
    self.topic =tpk;
    self.quote = quot ;
    return self;
}
-(void) dealloc
{
    self.topic=nil;
    self.quote=nil;
}


@end
