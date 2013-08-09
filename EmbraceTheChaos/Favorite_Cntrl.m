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

@synthesize homeDir;
@synthesize fileMgr;

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
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
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

    homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Application Support"];
    
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

- (NSArray *)favouriteQuotes 
{
    NSString *topicVal;
    NSString *quoteVal;
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb ;

    NSMutableArray *retval = [[NSMutableArray alloc] init] ;
    
    //select
    NSString *query = [NSString stringWithFormat:@"select a.quote_id, a.topic_id, b.topic_val, a.quote_val, c.picture from tbl_quote a, tbl_topic b , tbl_picture c  where a.isFav=1 and a.topic_id = b.topic_id and c.pic_id= a.pic_id order by a.topic_id"];
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
       
        int value= sqlite3_step(stmt);
        while(value==SQLITE_ROW)
        {
            UIImage *picture ;
            int quoteNum = sqlite3_column_int(stmt,0);
            int topicNum = sqlite3_column_int(stmt,1);
            char *topicChars = (char*)sqlite3_column_text(stmt, 2);
            char *quoteChars = (char*)sqlite3_column_text(stmt, 3);
            if(topicChars)
            {
                topicVal = [[NSString alloc]initWithUTF8String:topicChars];
            }
            
            if(quoteChars)
            {
                quoteVal = [[NSString alloc]initWithUTF8String:quoteChars];
            }
            NSData *data = [[NSData alloc] initWithBytes:sqlite3_column_blob(stmt, 4) length:sqlite3_column_bytes(stmt, 4)];
            
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
            Favorite_Mdl *info = [[Favorite_Mdl alloc]initWithQuoteID:quoteNum topicID:topicNum topic:topicVal quote:quoteVal pic:picture];
            [retval addObject:info];
             value= sqlite3_step(stmt);
        }
        sqlite3_finalize(stmt);
    }
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);
    return retval;
    
}
-(void)removeFavoriteQuote:(int)quoteIdNum
{
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb ;
    //select
    NSString *query = [NSString stringWithFormat:@"update tbl_quote set isFav=0 where  quote_id = %d",quoteIdNum];
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
        int val =sqlite3_step(stmt);
        NSLog(@"Value of sqlite%d",val);
    }
    else
    {
        
    }
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);

    
}

@end
