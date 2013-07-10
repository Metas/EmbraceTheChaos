//
//  Daily_Cntrl.m
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 7/9/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import "Daily_Cntrl.h"
#import "Daily_Mdl.h"

@implementation Daily_Cntrl
@synthesize homeDir;
@synthesize fileMgr;


static Daily_Cntrl *_database;

+(Daily_Cntrl *)database
{
    if(_database == nil)
    {
        _database = [[Daily_Cntrl alloc]init];
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
            //return self;
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

-(void) AddFav:(NSInteger)quoteID
{

    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb ;
    
    
    //update
    NSString *query = [NSString stringWithFormat:@"Update tbl_quote set isFav=1 where quote_id=%d",quoteID];
    NSLog(@"Query is %@",query);
    //Open db
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"embrace_the_chaos.sqlite3"];
    if (!(sqlite3_open([cruddatabase UTF8String], &cruddb) == SQLITE_OK)) 
    {
        NSLog(@"Failed to open database!");
    }
    int okVal =sqlite3_prepare_v2(cruddb, [query UTF8String], -1, &stmt, nil);
    if(okVal==SQLITE_OK)
    {
        //int value = sqlite3_step(stmt);
        sqlite3_step(stmt);
        sqlite3_finalize(stmt);
    }
    else
    {
        NSLog(@"ERROR %i",sqlite3_errcode(cruddb));
        NSLog(@"Datarows got %d",sqlite3_data_count(stmt));
    }
sqlite3_finalize(stmt);
    sqlite3_close(cruddb);

}

- (NSArray *)DailyQuote 
{
    
    NSMutableArray *retval = [[NSMutableArray alloc] init] ;
    NSString *query = @"select a.quote_id, a.topic_id, b.topic_val, a.quote_val, c.picture from tbl_quote a, tbl_topic b, tbl_picture c where a.topic_id = b.topic_id and c.pic_id= a.pic_id order by RANDOM() LIMIT 1";
    
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            UIImage *picture ;
            int quoteNum = sqlite3_column_int(statement,0);
            int topicNum = sqlite3_column_int(statement,1);
            char *topicChars = (char*)sqlite3_column_text(statement, 2);
            char *quoteChars = (char*)sqlite3_column_text(statement, 3);
            NSString *topicVal = [[NSString alloc]initWithUTF8String:topicChars];
            NSString *quoteVal = [[NSString alloc]initWithUTF8String:quoteChars];
            NSData *data = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 4) length:sqlite3_column_bytes(statement, 4)];
            
            if(data.length ==0)
            {
                NSLog(@"No image found.");//put a default image from filestructure here
                picture =[UIImage imageNamed:@"A.png"];
            }
            else
            {
                NSLog(@"Picture found %d",data.length);
                picture = [[UIImage alloc] initWithData:data]; 
            }
            
            Daily_Mdl *info = [[Daily_Mdl alloc]initWithQuoteID:quoteNum topicID:topicNum topic:topicVal quote:quoteVal pic:picture];
            [retval addObject:info];
        }
        sqlite3_finalize(statement);
    }
    return retval;
    
}

- (NSArray *)LastQuote:(NSInteger)quoteID 
{
    fileMgr = [NSFileManager defaultManager];

    sqlite3 *cruddb ;
    
    
    //select
    NSString *query = [NSString stringWithFormat:@"select a.quote_id, a.topic_id, b.topic_val, a.quote_val, c.picture from tbl_quote a, tbl_topic b, tbl_picture c where a.quote_id=%d",quoteID];

    NSLog(@"Query is %@",query);
    
    //Open db
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"embrace_the_chaos.sqlite3"];
    if (!(sqlite3_open([cruddatabase UTF8String], &cruddb) == SQLITE_OK)) 
    {
        NSLog(@"Failed to open database!");
    }
    
    NSMutableArray *retval = [[NSMutableArray alloc] init] ;

    sqlite3_stmt *statement;
    int okVal =sqlite3_prepare_v2(cruddb, [query UTF8String], -1, &statement, nil);
    if(okVal==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            UIImage *picture ;
            int quoteNum = sqlite3_column_int(statement,0);
            int topicNum = sqlite3_column_int(statement,1);
            char *topicChars = (char*)sqlite3_column_text(statement, 2);
            char *quoteChars = (char*)sqlite3_column_text(statement, 3);
            NSString *topicVal = [[NSString alloc]initWithUTF8String:topicChars];
            NSString *quoteVal = [[NSString alloc]initWithUTF8String:quoteChars];
            NSData *data = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 4) length:sqlite3_column_bytes(statement, 4)];
            
            if(data.length ==0)
            {
                NSLog(@"No image found.");//put a default image from filestructure here
                picture =[UIImage imageNamed:@"A.png"];
            }
            else
            {
                NSLog(@"Picture found %d",data.length);
                picture = [[UIImage alloc] initWithData:data]; 
            }
            
            Daily_Mdl *info = [[Daily_Mdl alloc]initWithQuoteID:quoteNum topicID:topicNum topic:topicVal quote:quoteVal pic:picture];
            [retval addObject:info];
        }
        sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"ERROR %i",sqlite3_errcode(_database));
        NSLog(@"Datarows got %d",sqlite3_data_count(statement));
    }
    sqlite3_finalize(statement);
    sqlite3_close(cruddb);
    return retval;
    
}


@end
