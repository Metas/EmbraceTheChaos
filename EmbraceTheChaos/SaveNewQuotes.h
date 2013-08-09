//
//  SaveNewQuotes.h
//  EmbraceTheChaos
//
//  Created by ShrutiG on 8/5/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "NewQuoteVals.h"

@interface SaveNewQuotes : NSObject //<XMLParserDelegate>
{
    sqlite3 * _databasepointer;
    NSFileManager *fileMgr;
    NSString *homeDir;
    NSString *sqLiteDb ;
}
@property (nonatomic,retain) NSString *homeDir;
@property (nonatomic,retain) NSFileManager *fileMgr;
+ (SaveNewQuotes *) database;
-(NSString *)dataFilePath:(BOOL)forSave ;
//-(NSArray *) DailyQuote ;
//-(NSArray *) LastQuote:(NSInteger) quoteID ;
-(void) AddQuote:(NewQuoteVals *)quote ;
-(int) AddPic:(NSString*) url;
-(int) getLastPicID ;
-(int) getLastTopicID :(NSString*)Topic ;
-(void) addTopic:(NSString*)Topic :(int)TopicID ;
-(int) getLastQuoteID;
-(NSString *) GetDocumentDirectory;

@end
