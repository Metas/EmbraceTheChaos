//
//  Daily_Cntrl.h
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 7/9/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface Daily_Cntrl : NSObject
{
        sqlite3 * _databasepointer;
    NSFileManager *fileMgr;
    NSString *homeDir;
    NSString *sqLiteDb ; 
}
@property (nonatomic,retain) NSString *homeDir;
@property (nonatomic,retain) NSFileManager *fileMgr;
+ (Daily_Cntrl *) database;
-(NSString *)dataFilePath:(BOOL)forSave ;
-(NSArray *) DailyQuote ;
-(NSArray *) LastQuote:(NSInteger) quoteID ;
-(void) AddFav:(NSInteger)quoteID ;
//-(void)removeFavoriteQuote:(int) quoteIdNum;
-(NSString *) GetDocumentDirectory;
@end
