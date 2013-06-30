//
//  Favorite_Cntrl.m
//  EmbraceTheChaos
//
//  Created by Shruti on 6/23/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import "Favorite_Cntrl.h"
#import "Favorite_Mdl.h"

@implementation Favorite_Cntrl

static Favorite_Cntrl *_database;

+(Favorite_Cntrl *)database
{
    if(_database == nil)
    {
        _database = [[Favorite_Cntrl alloc]init];
    }
    return _database;
}
-(NSString *)dataFilePath:(BOOL)forSave 
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory
                               stringByAppendingPathComponent:@"embrace_the_chaos.sqlite3"];
    if (forSave || 
        [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) 
    {
        return documentsPath;
    } 
    else 
    {
        return [[NSBundle mainBundle] pathForResource:@"embrace_the_chaos" ofType:@"sqlite3"];
    }
    
}

- (id)init 
{
    if ((self = [super init])) 
    {
        //NSString *sqLiteDb = [self dataFilePath:TRUE];
        
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"embrace_the_chaos" ofType:@"sqlite3"];
        
        if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) 
        {
            NSLog(@"Failed to open database!");
        }
    }
    return self;
}

- (void)dealloc 
{
    sqlite3_close(_database);
}
/*c.execute('create table tbl_topic(topic_id integer,topic_val text)')
 c.execute('create table tbl_quote(quote_id integer primary key autoincrement,topic_id integer, pic_id integer, isFav integer, saveYN integer, createDate text, quote_val text)')
*/

- (NSArray *)favouriteQuotes 
{
    
    NSMutableArray *retval = [[NSMutableArray alloc] init] ;
    NSString *query = @"select a.quote_id, a.topic_id, b.topic_val, a.quote_val from tbl_quote a, tbl_topic b where a.isFav=0 and a.topic_id = b.topic_id order by a.topic_id";
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            int quoteNum = sqlite3_column_int(statement,0);
            int topicNum = sqlite3_column_int(statement,1);
            char *topicChars = (char*)sqlite3_column_text(statement, 2);
            char *quoteChars = (char*)sqlite3_column_text(statement, 3);
            NSString *topicVal = [[NSString alloc]initWithUTF8String:topicChars];
            NSString *quoteVal = [[NSString alloc]initWithUTF8String:quoteChars];
            Favorite_Mdl *info = [[Favorite_Mdl alloc]initWithQuoteID:quoteNum topicID:topicNum topic:topicVal quote:quoteVal];
            [retval addObject:info];
        }
        sqlite3_finalize(statement);
    }
    return retval;
    
}
-(void)removeFavoriteQuote:(int)quoteIdNum
{

    static sqlite3_stmt *updateStmt = nil;
    
    if(updateStmt == nil) 
    {
        NSString *query = [NSString stringWithFormat:@"update tbl_quote set isFav=1 where  quote_id = %d and isFav=0 ",quoteIdNum];

        NSLog(@"%@",query);
        sqlite3_stmt *statement;
    
        if(sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)!=SQLITE_OK)
        {
            NSLog(@"ERROR");
        }
        if(SQLITE_DONE != sqlite3_step(statement))
        {
            NSLog(@"ERROR");
        }
        sqlite3_finalize(statement);

    }

    
}

@end
