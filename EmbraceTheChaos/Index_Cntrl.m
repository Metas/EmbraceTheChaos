//
//  Index_Cntrl.m
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 7/11/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import "Index_Cntrl.h"
#import "Index_Mdl.h"

@implementation Index_Cntrl
@synthesize homeDir;
@synthesize fileMgr;



static Index_Cntrl *_database;

+(Index_Cntrl *)database
{
    if(_database == nil)
    {
        _database = [[Index_Cntrl alloc]init];
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
- (NSArray *)topicPicture 
{
    NSString *topicVal ;
    NSString *quoteVal ;
    fileMgr = [NSFileManager defaultManager];
    sqlite3_stmt *stmt=nil;
    sqlite3 *cruddb ;
    
    NSMutableArray *retval = [[NSMutableArray alloc] init] ;
    
    //select
    NSString *query = [NSString stringWithFormat:@"select a.quote_id, a.topic_id, b.topic_val, a.quote_val, c.picture from tbl_quote a, tbl_topic b, tbl_picture c where a.topic_id = b.topic_id and c.pic_id= a.pic_id "];
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
            UIImage *pictureVal ;
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
                UIImage *imageValue =[UIImage imageNamed:@"A.png"];
                pictureVal =[self drawText:topicVal inImage:imageValue ];
            }
            else
            {
                NSLog(@"Picture found %d",data.length);
                UIImage *imageVal= [[UIImage alloc] initWithData:data];
                pictureVal =[self drawText:topicVal inImage:imageVal ];
            }

            
            Index_Mdl *info = [[Index_Mdl alloc]initWithTopicPic:quoteNum topicID:topicNum topic:topicVal quote:quoteVal picture:pictureVal ];
            [retval addObject:info];
            value= sqlite3_step(stmt);
        }
        sqlite3_finalize(stmt);
    }
    sqlite3_finalize(stmt);
    sqlite3_close(cruddb);
    return retval;
    
}
-(UIImage*) drawText:(NSString*) text 
             inImage:(UIImage*)  image 
{
    
    UIFont *font = [UIFont boldSystemFontOfSize:8];
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    [[UIColor blackColor] set];
    [text drawInRect:CGRectIntegral(rect) withFont:font lineBreakMode:YES alignment:UITextAlignmentLeft]; 
    //[text drawInRect:CGRectIntegral(rect) withFont:font]; 
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
