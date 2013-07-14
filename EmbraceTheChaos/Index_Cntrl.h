//
//  Index_Cntrl.h
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 7/11/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "IndexViewController.h"


@interface Index_Cntrl : NSObject
{
    sqlite3 * _database;
    NSFileManager *fileMgr;
    NSString *homeDir;

}
@property (nonatomic,retain) NSString *homeDir;
@property (nonatomic,retain) NSFileManager *fileMgr;
+ (Index_Cntrl *) database;
-(NSArray *)topicPicture ;
-(NSString *) GetDocumentDirectory;
-(UIImage*) drawText:(NSString*) text inImage:(UIImage*)  image ;

@end
