//
//  CrudOps_Cntrl.h
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 7/9/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrudOps_Cntrl : NSObject
{
    NSInteger quoteId;
    NSInteger topicId; 
    NSInteger picId;
    BOOL isFavorite;
    NSDate *createDate;
    NSString *topicVal;
    NSString *quoteVal;
    NSFileManager *fileMgr;
    NSString *homeDir;
    NSString *title ;
}
@property (nonatomic, assign) NSInteger quoteId;
@property (nonatomic, assign) NSInteger topicId;
@property (nonatomic, assign) NSInteger picId;
@property (nonatomic,retain) NSDate *createDate;
@property (nonatomic,retain) NSString *topicVal;
@property (nonatomic,retain) NSString *quoteVal;
@property (nonatomic,retain) NSString *homeDir;
@property (nonatomic,retain) NSFileManager *fileMgr;
@property (nonatomic,retain) NSString *title;

-(void)CopyDbToDocumentsFolder;
-(NSString *) GetDocumentDirectory;
-(void)InsertRecords:(NSMutableString *)txt :(int) integer :(double) dbl;
-(void)UpdateRecords:(NSString *)txt :(NSMutableString *) utxt;
-(void)DeleteRecords:(NSString *)txt;

@end
