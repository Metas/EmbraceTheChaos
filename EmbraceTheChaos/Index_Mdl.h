//
//  Index_Mdl.h
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 7/11/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Index_Mdl : NSObject
{
    int quoteID;
    int topicID;
    NSString *topic;
    NSString *quote;
    UIImage *pictureVal ;
    NSMutableArray *topicPicture;
}
@property(nonatomic,assign) int quoteID;
@property(nonatomic,assign) int topicID;
@property(nonatomic,retain) NSString* topic;
@property(nonatomic,retain) NSString* quote;
@property(nonatomic,retain) UIImage *pictureVal;
@property(nonatomic,retain) NSMutableArray* topicPicture;

-(id) initWithTopicPic:(int)quoteNum topicID:(int)tpcId topic:(NSString *)tpk quote:(NSString *)quot picture:(UIImage *)pic ;
@end
