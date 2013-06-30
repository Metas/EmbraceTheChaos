//
//  Favorite_Mdl.h
//  EmbraceTheChaos
//
//  Created by Shruti on 6/23/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSDate.h>

@interface Favorite_Mdl : NSObject
{
    int quoteID;
    int topicID;
    NSString *topic;
    NSString *quote;
}
@property(nonatomic,assign) int quoteID;
@property(nonatomic,assign) int topicID;
@property(nonatomic,retain) NSString* topic;
@property(nonatomic,retain) NSString* quote;

-(id) initWithQuoteID:(int)quoteNum topicID:(int)tpcId topic:(NSString *)tpk quote:(NSString *)quot ;
@end
