//
//  Favorite_Cntrl.h
//  EmbraceTheChaos
//
//  Created by Shruti on 6/23/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Favorite_Cntrl : NSObject
{
    sqlite3 * _database;
}
+ (Favorite_Cntrl *) database;
-(NSString *)dataFilePath:(BOOL)forSave ;
-(NSArray *) favouriteQuotes ;
-(void)removeFavoriteQuote:(int) quoteIdNum;
@end
