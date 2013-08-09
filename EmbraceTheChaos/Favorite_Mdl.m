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
@synthesize pic;

-(id) initWithQuoteID:(int)quoteNum topicID:(int)tpcId topic:(NSString *)tpk quote:(NSString *)quot pic:(UIImage *)picture
{
    self.quoteID = quoteNum;
    self.topicID = tpcId;
    self.topic =tpk;
    self.quote = quot ;
    self.pic = picture ;
    return self;
}
-(void) dealloc
{
    self.topic=nil;
    self.quote=nil;
    self.pic =nil;
}


@end
