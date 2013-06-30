//
//  Info_Mdl.h
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/26/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Info_Mdl : NSObject
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

-(id) initWithRandomQuote:(int)quoteNum topic:(NSString *)tpk quote:(NSString *)quot ;
@end
