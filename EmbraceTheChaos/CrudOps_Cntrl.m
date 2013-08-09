//
//  CrudOps_Cntrl.m
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 7/9/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import "CrudOps_Cntrl.h"
#import <sqlite3.h>
#import <sys/xattr.h>

@implementation CrudOps_Cntrl
@synthesize createDate;
@synthesize fileMgr;
@synthesize homeDir;
@synthesize picId;
@synthesize quoteId;
@synthesize quoteVal;
@synthesize title;
@synthesize topicId;
@synthesize topicVal;


- (BOOL)addSkipBackupAttributeToItemAtURL:(NSString *)URL
{
    NSURL *urlRep = [[NSURL alloc]initFileURLWithPath:URL];
    assert([[NSFileManager defaultManager] fileExistsAtPath: [urlRep path]]);
    
    const char* filePath = [[urlRep path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

-(void)CopyDbToDocumentsFolder
{
    NSError *err=nil;
    
    fileMgr = [NSFileManager defaultManager];
    
    NSString *dbpath = [[NSBundle mainBundle] pathForResource:@"embrace_the_chaos" ofType:@"sqlite3"];    
    
    NSString *copydbpath = [self.GetDocumentDirectory
                            
                            stringByAppendingPathComponent:@"embrace_the_chaos.sqlite3"];
    
    
    if ([fileMgr fileExistsAtPath: copydbpath ] == YES)
    {
        NSLog (@"File exists");
        //remove the old file 
        //[fileMgr removeItemAtPath:copydbpath error:&err];
    }
    else
    {
        NSLog (@"File not found");
        //copy the resource sqlite file to document path
        
        if(![fileMgr copyItemAtPath:dbpath toPath:copydbpath error:&err])
        {
            UIAlertView *tellErr = [[UIAlertView alloc] initWithTitle:title message:@"Unable to copy database." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [tellErr show];
        }
        else //copy success now avoid it being backed up in cloud
        {
            if([self addSkipBackupAttributeToItemAtURL:dbpath])
                NSLog(@"Succesfully skipped from copying to cloud");
            else
                 NSLog(@"Something went wrong in skipping copying to cloud");
        }

    }
    
                                

}
-(NSString *) GetDocumentDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *appDir = [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Application Support"];
    if([fileManager fileExistsAtPath:appDir]==NO)
        [fileManager createDirectoryAtPath:appDir withIntermediateDirectories:YES attributes:nil error:nil];
  
    
    fileMgr = [NSFileManager defaultManager];
    
    homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Application Support"];
    
    return homeDir;

}
-(void)InsertRecords:(NSMutableString *)txt :(int) integer :(double) dbl
{
    //fileMgr = [NSFileManager defaultManager];
    //sqlite3_stmt *stmt=nil;
    //sqlite3 *cruddb;
    
    
    //insert
    //const char *sql = "INSERT INTO data(coltext, colint, coldouble) VALUES(?,?,?)";
    
    //Open db
    //NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"cruddb.sqlite"];
//    sqlite3_open([cruddatabase UTF8String], &cruddb);
//    sqlite3_prepare_v2(cruddb, sql, 1, &stmt, NULL);
//    sqlite3_bind_text(stmt, 1, [txt UTF8String], -1, SQLITE_TRANSIENT);
//    sqlite3_bind_int(stmt, 2, integer);
//    sqlite3_bind_double(stmt, 3, dbl);
//    sqlite3_step(stmt);
//    sqlite3_finalize(stmt);
//    sqlite3_close(cruddb); 

    
}
-(void)UpdateRecords:(NSString *)txt :(NSMutableString *) utxt
{
    
}
-(void)DeleteRecords:(NSString *)txt
{
    
}

@end
