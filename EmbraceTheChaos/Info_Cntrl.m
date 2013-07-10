//
//  Info_Cntrl.m
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/26/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import "Info_Cntrl.h"
#import "Info_Mdl.h"

@implementation Info_Cntrl
@synthesize homeDir;
@synthesize fileMgr;
static Info_Cntrl *_database;

+(Info_Cntrl *)database
{
    if(_database == nil)
    {
        _database = [[Info_Cntrl alloc]init];
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
-(NSString *) GetDocumentDirectory
{
    fileMgr = [NSFileManager defaultManager];
    homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    return homeDir;
    
}



- (id)init 
{
    if ((self = [super init])) 
    {
        NSString *sqLiteDb ; 
        
        @try
        {
            sqLiteDb = [self dataFilePath:TRUE];
             NSLog(@"Database location is:%@",sqLiteDb);
            if(sqLiteDb.length ==0)
            {
                //sqlite db is not found in documents directory so see the resources directory
                NSFileManager *filemgr = [NSFileManager defaultManager];
                sqLiteDb = [[NSBundle mainBundle] pathForResource:@"embrace_the_chaos" ofType:@"sqlite3"];
                BOOL success =[filemgr fileExistsAtPath:sqLiteDb];
                if(!success)
                {
                    NSLog(@"Cannot locate database file '%@'.",sqLiteDb);
                }
                if (!(sqlite3_open([sqLiteDb UTF8String], &_database) == SQLITE_OK)) 
                {
                    NSLog(@"Failed to open database!");
                }
                
            }
            else//database is in documents directory
            {
                NSFileManager *filemgr = [NSFileManager defaultManager];
                BOOL success =[filemgr fileExistsAtPath:sqLiteDb];
                if(!success)
                {
                    NSLog(@"Cannot locate database file '%@'.",sqLiteDb);
                }
                if (!(sqlite3_open([sqLiteDb UTF8String], &_database) == SQLITE_OK)) 
                {
                    NSLog(@"Failed to open database!");
                }
                
            }
        }
        @catch(NSException *exc)
        {
            NSLog(@"An exception occured %@",[exc reason]);
        }
        @finally 
        {
            return self;
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
-(NSArray *)randomQuote
{
    NSMutableArray * retVal =[[NSMutableArray alloc]init];
    NSString *query = @"select a.quote_id,b.topic_val, a.quote_val from tbl_quote a, tbl_topic b where a.topic_id = b.topic_id order by RANDOM() LIMIT 1";
    
    sqlite3_stmt *statement;
     NSLog(@"%@",query);
    if(sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW )
        {
              
        int quoteNum = (int) sqlite3_column_int(statement, 0);
        char *topicChars = (char*)sqlite3_column_text(statement, 1);
        char *quoteChars = (char*)sqlite3_column_text(statement, 2);
        NSString *topicVal = [[NSString alloc]initWithUTF8String:topicChars];
        NSString *quoteVal = [[NSString alloc]initWithUTF8String:quoteChars];
        Info_Mdl *info = [[Info_Mdl alloc]initWithRandomQuote:quoteNum topic:topicVal quote:quoteVal];
        [retVal addObject:info];
        //retVal = [[topicVal stringByAppendingString:@": "]stringByAppendingString:quoteVal];
        }
        sqlite3_finalize(statement);
    }
    return retVal;

}


@end
