//
//  FavoritesViewController.m
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/24/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import "FavoritesViewController.h"
#import "Favorite_Mdl.h"
#import "Favorite_Cntrl.h"

@implementation FavoritesViewController
@synthesize favorites;
@synthesize sectionKeys;
@synthesize sectionContents;

-(id) init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}
-(void) viewDidLoad
{
    [super viewDidLoad];
    self.favorites =[Favorite_Cntrl database].favouriteQuotes;
    self.title = @"Favorites";
    [self getSectionAndKeyValues];

    
}
-(void) getSectionAndKeyValues
{
    NSMutableDictionary *contents = [[NSMutableDictionary alloc]init];
    NSMutableArray *keys =[[NSMutableArray alloc]init];
    int oldTopicId =0;
    NSString *oldTopicValue;
    NSMutableArray* sectionVals =[[NSMutableArray alloc]init];
    if(favorites.count!=0)
    {
        for(int i=0; i<=[favorites count];i++)
        {
            if(i==[favorites count])
            {
                [keys addObject:oldTopicValue];
            
                NSArray *array = [NSArray arrayWithArray:sectionVals];
                
                [contents setObject:array forKey:oldTopicValue];
             
                break;
            }
            Favorite_Mdl *info=[favorites objectAtIndex:i];
            int newTopicId = [info topicID];
            if(oldTopicId != newTopicId)
            {
            if(oldTopicId ==0)
            {
                oldTopicId = [info topicID];
                oldTopicValue =[info topic];
                [sectionVals addObject:[info quote]];
            }
            else
            {
                [keys addObject:oldTopicValue];
                NSArray *array = [NSArray arrayWithArray:sectionVals];
                
                [contents setObject:array forKey:oldTopicValue];
                
                [sectionVals removeAllObjects];
                oldTopicId = newTopicId;
                oldTopicValue =[info topic];
                [sectionVals addObject:[info quote]];
            }
        }  
        else
        {
            NSString *quoteIs =[info quote] ;
            [sectionVals addObject:quoteIs] ;
        }
    }
    [self setSectionKeys:keys];
    [self setSectionContents:contents];
    }
}

-(void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [ sectionKeys count];
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [[self sectionKeys] objectAtIndex:section];
    NSArray *contents = [[self sectionContents] objectForKey:key];
    NSInteger rows = [contents count] ;    
    return rows;
}
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    NSString *key = [[self sectionKeys] objectAtIndex:section];
    
    return key;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [[self sectionKeys] objectAtIndex:[indexPath section]];
    NSArray *contents = [[self sectionContents] objectForKey:key];
    NSString *contentForThisRow = [contents objectAtIndex:[indexPath row]];
    
    static NSString *cellIdentifier=@"Cell";
    UITableViewCell *cell =(UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell!= nil)
    {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = contentForThisRow;
    return cell;
}


- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath 
{
   
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //NSString *key = [[self sectionKeys] objectAtIndex:[indexPath section]];
        //NSArray *contents = [[self sectionContents] objectForKey:key];
        //NSString *contentForThisRow = [contents objectAtIndex:[indexPath row]];
        Favorite_Mdl *info=[favorites objectAtIndex:[indexPath row]];
        int quoteIDVal = [info quoteID];
        Favorite_Cntrl *removeFav =[[Favorite_Cntrl alloc]init];
        [removeFav removeFavoriteQuote:quoteIDVal];
         //NSArray *contents = [[self sectionContents] objectForKey:key];
        
        //[tableView deleteRowsAtIndexPaths:contents withRowAnimation:YES];
    }
    [tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
