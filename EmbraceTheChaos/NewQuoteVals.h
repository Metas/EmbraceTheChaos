//
//  NewQuoteVals.h
//  EmbraceTheChaos
//
//  Created by ShrutiG on 8/3/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewQuoteVals : NSObject
{
    int quoteID;
    int topicID;
    NSString *topic;
    NSString *quote;
    NSString *imgKey;
    NSString *UserName ;
    NSString *imgUrl;
    UIImage *pic ;
}
@property(nonatomic,assign) int quoteID;
@property(nonatomic,assign) int topicID;
@property(nonatomic,retain) NSString* topic;
@property(nonatomic,retain) NSString* quote;

@property(nonatomic,retain)NSString *imgKey;
@property(nonatomic,retain)NSString *UserName ;
@property(nonatomic,retain)NSString *imgUrl;
@property(nonatomic,retain) UIImage *pic;
@end
