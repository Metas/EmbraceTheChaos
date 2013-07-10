//
//  FavoritesViewController.h
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/24/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *favorites;
    

}
@property(nonatomic,retain)NSArray *favorites;
@property(nonatomic,retain) NSMutableArray *sectionKeys;
@property(nonatomic,retain)NSMutableDictionary *sectionContents;
@property (weak, nonatomic) IBOutlet UITableView *tableFav;

-(void) getSectionAndKeyValues;
@end
