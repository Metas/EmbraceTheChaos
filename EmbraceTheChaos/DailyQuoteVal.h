//
//  DailyQuoteVal.h
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 7/13/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyQuoteVal : NSObject
{
        int quoteID;
}
@property(nonatomic,assign) int quoteID;
-(id) initWithQuoteID:(int)quoteNum ;

@end
