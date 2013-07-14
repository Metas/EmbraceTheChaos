//
//  Index_Mdl.m
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 7/11/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import "Index_Mdl.h"

@implementation Index_Mdl
@synthesize quoteID;
@synthesize topicID;
@synthesize quote;
@synthesize topic;
@synthesize pictureVal;
@synthesize topicPicture;

-(id) initWithTopicPic:(int)quoteNum topicID:(int)tpcId topic:(NSString *)tpk quote:(NSString *)quot picture:(UIImage *)pic
{
    self.quoteID = quoteNum;
    self.topicID = tpcId;
    self.topic =tpk;
    self.quote = quot ;
    self.pictureVal = pic;
    return self;
}
-(void) dealloc
{
    self.topic=nil;
    self.quote=nil;
    self.pictureVal=nil;
}


@end
