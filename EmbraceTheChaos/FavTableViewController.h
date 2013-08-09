//
//  FavTableViewController.h
//  EmbraceTheChaos
//
//  Created by ShrutiG on 8/9/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyQuoteVal.h"

@interface FavTableViewController : UITableViewController
{
    NSArray *favorites;
    int rowCount;
    UIButton *btnDeleteOne ;
    UIButton *btnDeleteTwo ;
    UIButton *btnMoreOne ;
    UIButton *btnMoreTwo ;
    NSMutableArray *TwoQuoteImageArray ;
}

    @property (nonatomic, strong) NSArray *QuoteImages;

@property(nonatomic,retain)NSArray *favorites;
@property(nonatomic,retain) NSMutableArray *sectionKeys;
@property(nonatomic,retain)NSMutableDictionary *sectionContents;

-(void) getSectionAndKeyValues;
@end
