//
//  Daily_Mdl.h
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 7/9/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Daily_Mdl : NSObject
{
    int quoteID;
    int topicID;
    NSString *topic;
    NSString *quote;
    UIImage *pic ;
}
@property(nonatomic,assign) int quoteID;
@property(nonatomic,assign) int topicID;
@property(nonatomic,retain) NSString* topic;
@property(nonatomic,retain) NSString* quote;
@property(nonatomic,retain) UIImage *pic;

-(id) initWithQuoteID:(int)quoteNum topicID:(int)tpcId topic:(NSString *)tpk quote:(NSString *)quot pic:(UIImage *)picture ;
@end
