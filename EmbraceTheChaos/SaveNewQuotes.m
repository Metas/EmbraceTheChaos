//
//  SaveNewQuotes.m
//  EmbraceTheChaos
//
//  Created by ShrutiG on 8/5/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import "SaveNewQuotes.h"

@implementation SaveNewQuotes
@synthesize homeDir;
@synthesize fileMgr;

static SaveNewQuotes *_database;

+(SaveNewQuotes *)database
{
    if(_database == nil)
    {
        @try
        {
            _database = [[SaveNewQuotes alloc]init];
            NSLog(@"Database values %@",_database.description);
            return _database;
        }@catch(NSException *e)
        {
            NSLog(@"Exception %@",e.description);
        }
    }
    else
        return _database;
    
}
-(NSString *)dataFilePath:(BOOL)forSave
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
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
                int val = sqlite3_open([sqLiteDb UTF8String], &_databasepointer) ;
                if (!(val== SQLITE_OK))
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
                
                const char *dbpath = [sqLiteDb UTF8String];
                int val= sqlite3_open(dbpath, &_databasepointer);
                
                if (!(val == SQLITE_OK))
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
    sqlite3_close(_databasepointer);
}

-(void) AddQuote:(NewQuoteVals *)quote
{
    //get the picture id
    int pic_id = [self AddPic:quote.imgUrl];
    //get topic id if the topic is new add it to topic database
    int topic_id =[self getLastTopicID:quote.topic];
    //get the last quoteID
    int quote_id = [self getLastQuoteID];
    //get current date
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd:MM:YYYY"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb ;
    const char *query = "Insert into tbl_quote(quote_id,topic_id,pic_id,isFav,saveYN,createDate,quote_val) VALUES (?,?,?,?,?,?,?)";

    //NSLog(@"Query is %@",);
    //Open db
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"embrace_the_chaos.sqlite3"];
    if (!(sqlite3_open([cruddatabase UTF8String], &cruddb) == SQLITE_OK))
    {
        NSLog(@"Failed to open database!");
    }
    int okVal =sqlite3_prepare_v2(cruddb, query , -1, &stmt, nil);
    if(okVal==SQLITE_OK)
    {
        sqlite3_bind_int(stmt, 1, quote_id);//quote_id
        sqlite3_bind_int(stmt, 2, topic_id);//topic_id
        sqlite3_bind_int(stmt, 3, pic_id);//pic_id
        sqlite3_bind_int(stmt, 4, 0);//isFav
        sqlite3_bind_int(stmt, 5, 0);//saveYN
        sqlite3_bind_text(stmt, 6, [dateString UTF8String], -1, SQLITE_TRANSIENT);//date
        sqlite3_bind_text(stmt, 7,[quote.quote UTF8String], -1, SQLITE_TRANSIENT);//quote
        

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

-(int)AddPic:(NSString *)url
{
    
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb ;
    
    //get the last pic id add one to it and insert anew record, return this id value to be added to tbl_quote
    int pic_id = [self getLastPicID];
    
    //get the image from the url
    NSURL *urlVal = [NSURL URLWithString:url];
    NSData *data = [NSData dataWithContentsOfURL:urlVal];

    if(data.length ==0)
    {
        NSLog(@"No image found.");//put a default image from filestructure here
        data =UIImagePNGRepresentation([UIImage imageNamed:@"A.png"]);
    }
    
    const char *query = "Insert into tbl_picture(pic_id,picture) VALUES (?,?)";
    
    
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"embrace_the_chaos.sqlite3"];
    if (!(sqlite3_open([cruddatabase UTF8String], &cruddb) == SQLITE_OK))
    {
        NSLog(@"Failed to open database!");
    }
    int okVal =sqlite3_prepare_v2(cruddb, query , -1, &stmt, nil);
    if(okVal==SQLITE_OK)
    {
          sqlite3_bind_int(stmt, 1, pic_id);//pic_id
         sqlite3_bind_blob(stmt, 2, [data bytes], [data length], SQLITE_TRANSIENT);//pic
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
    return pic_id ;
}

-(int) getLastPicID
{
    
    int picID =0;
    NSString *query = @"select pic_id from tbl_picture order by pic_id DESC";
    const char *queryVal = [query UTF8String];
    sqlite3_stmt *statement;
    int val = sqlite3_prepare_v2(_databasepointer, queryVal, -1, &statement, nil);
    if(val==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            int pic_ID = sqlite3_column_int(statement,0);
            picID = pic_ID +1 ;
            break ;
        }
        sqlite3_finalize(statement);
    }
    return picID;

}

-(int) getLastQuoteID
{
    
    int quoteID =0;
    NSString *query = @"select quote_id from tbl_quote order by quote_id DESC";
    const char *queryVal = [query UTF8String];
    sqlite3_stmt *statement;
    int val = sqlite3_prepare_v2(_databasepointer, queryVal, -1, &statement, nil);
    if(val==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            int quote_ID = sqlite3_column_int(statement,0);
            quoteID = quote_ID +1 ;
            break ;
        }
        sqlite3_finalize(statement);
    }
    return quoteID;
    
}

-(int)getLastTopicID:(NSString *)Topic
{
    int topicID =0 ;
    int topic_Num =0;
    NSString *query = @"select topic_val, topic_id from tbl_topic";
    const char *queryVal = [query UTF8String];
    sqlite3_stmt *statement;
    int topic_ID =0;
    int val = sqlite3_prepare_v2(_databasepointer, queryVal, -1, &statement, nil);
    if(val==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            NSString *topic ;
            char *topicChars = (char*)sqlite3_column_text(statement, 0) ;
            topic_Num = sqlite3_column_int(statement,1);
            if(topicChars)
            {
                topic = [[NSString alloc]initWithUTF8String:topicChars];
            }
            if([topic isEqualToString:Topic ])//match found no new topic break
            {
                topic_ID =0 ;
                break;
            }
            else
            {
                topic_ID =topic_Num ;
            } 
        }
        sqlite3_finalize(statement);
        if(topic_ID ==0)
        {
            //topic exists return topicNum
            topicID = topic_Num ;
        }
        else
        {
             topicID = topic_ID +1 ;
            [self addTopic:Topic :topicID];
        }
       
    }
    return topicID;

}
-(void)addTopic:(NSString *)Topic :(int)TopicID
{
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb ;
    
    
    const char *query = "Insert into tbl_topic(topic_id,topic_val) VALUES (?,?)";
    
    
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"embrace_the_chaos.sqlite3"];
    if (!(sqlite3_open([cruddatabase UTF8String], &cruddb) == SQLITE_OK))
    {
        NSLog(@"Failed to open database!");
    }
    int okVal =sqlite3_prepare_v2(cruddb, query , -1, &stmt, nil);
    if(okVal==SQLITE_OK)
    {
        sqlite3_bind_int(stmt, 1, TopicID);//topic_id
        sqlite3_bind_text(stmt, 2, [Topic UTF8String], -1, SQLITE_TRANSIENT);//topic
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


@end
