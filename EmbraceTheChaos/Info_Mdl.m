//
//  Info_Mdl.m
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/26/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import "Info_Mdl.h"

@implementation Info_Mdl
@synthesize quoteID;
@synthesize topicID;
@synthesize quote;
@synthesize topic;

-(id) initWithRandomQuote:(int)quoteNum topic:(NSString *)tpk quote:(NSString *)quot
{
    self.quoteID = quoteNum;
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
