//
//  Info_Cntrl.h
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/26/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Info_Cntrl : NSObject
{
    sqlite3 * _database;
}
+ (Info_Cntrl *) database;
-(NSArray *)randomQuote ;

//-(NSString *)dataFilePath:(BOOL)forSave ;
//-(NSArray *) favouriteQuotes ;
//-(void)removeFavoriteQuote:(int) quoteIdNum;

@end
