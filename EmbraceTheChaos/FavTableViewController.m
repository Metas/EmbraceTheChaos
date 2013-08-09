//
//  FavTableViewController.m
//  EmbraceTheChaos
//
//  Created by ShrutiG on 8/9/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import "FavTableViewController.h"
#import "FavTableCell.h"
#import "Favorite_Mdl.h"
#import "Favorite_Cntrl.h"
#import <QuartzCore/QuartzCore.h>

@implementation FavTableViewController
@synthesize QuoteImages;
@synthesize favorites;
@synthesize sectionKeys;
@synthesize sectionContents;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}

-(void)viewDidLoad
{
    
    self.favorites =[Favorite_Cntrl database].favouriteQuotes;

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
                    if((info.quote !=  NULL)||(info.quote.length !=0))
                    {
                        [sectionVals addObject:[info quote]];
                        //add picture is there
                    }
                    if(info.pic != NULL)
                        [sectionVals addObject:[info pic]];
                }
                else
                {
                    [keys addObject:oldTopicValue];
                    NSArray *array = [NSArray arrayWithArray:sectionVals];
                    
                    [contents setObject:array forKey:oldTopicValue];
                    
                    [sectionVals removeAllObjects];
                    oldTopicId = newTopicId;
                    oldTopicValue =[info topic];
                    if((info.quote !=  NULL)||(info.quote.length !=0))
                    {
                        [sectionVals addObject:[info quote]];
                        //add picture is there
                    }
                    if(info.pic != NULL)
                        [sectionVals addObject:[info pic]];
                    
                }
            }
            else
            {
                if((info.quote !=  NULL)||(info.quote.length !=0))
                {
                    [sectionVals addObject:[info quote]];
                    //add picture is there
                }
                if(info.pic != NULL)
                    [sectionVals addObject:[info pic]];
                
            }
        }
        [self setSectionKeys:keys];
        [self setSectionContents:contents];
        
    }
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [ sectionKeys count];
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [[self sectionKeys] objectAtIndex:section];
    NSArray *contents = [[self sectionContents] objectForKey:key];
    
    TwoQuoteImageArray = [[NSMutableArray alloc] init];
    
    for(int i=0,k=0; i<contents.count;i++,k++)
    {
        int count = i+1;
        if(count<contents.count)
        {
            NSMutableArray* tempVal = [[NSMutableArray alloc]initWithCapacity:2];
            int j = i ;
            [tempVal insertObject:[contents objectAtIndex:j] atIndex:0];
            j++ ;
            [tempVal insertObject:[contents objectAtIndex:j] atIndex:1];
            
            [TwoQuoteImageArray insertObject:tempVal atIndex:k];
            i++;
        }
        else if(count==contents.count)//last val
        {
            [TwoQuoteImageArray insertObject:[NSMutableArray arrayWithObjects:[contents objectAtIndex:i],nil] atIndex:k];
        }
    }

    
    NSInteger rows = TwoQuoteImageArray.count ;
    rowCount =0;
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
    static NSString *cellIdentifier=@"Cell";
    FavTableCell *cell =(FavTableCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];



    btnDeleteOne = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDeleteOne.frame=CGRectMake([cell Img01].center.x+([cell Img01].frame.size.width/2) +2, 2, 30,30);
    btnDeleteOne.tag = indexPath.row;
    [btnDeleteOne setBackgroundImage:[UIImage imageNamed:@"Delete_Icon_32.png"] forState:UIControlStateNormal];
    [btnDeleteOne addTarget:self action:@selector(btnDeleteOneTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    btnMoreOne = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMoreOne.frame=CGRectMake([cell Img01].center.x+([cell Img01].frame.size.width/2) +2, 45, 30,30);
    btnMoreOne.tag = indexPath.row;
    [btnMoreOne setBackgroundImage:[UIImage imageNamed:@"More_Icon.png"] forState:UIControlStateNormal];
    [btnMoreOne addTarget:self action:@selector(btnMoreOneTapped:) forControlEvents:UIControlEventTouchUpInside];

    
    btnDeleteTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDeleteTwo.frame=CGRectMake([cell Img02].center.x+([cell Img02].frame.size.width/2) +2, 2, 30,30);
    btnDeleteTwo.tag = indexPath.row;
    
    [btnDeleteTwo setBackgroundImage:[UIImage imageNamed:@"Delete_Icon_32.png"] forState:UIControlStateNormal];
    [btnDeleteTwo addTarget:self action:@selector(btnDeleteTwoTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    btnMoreTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMoreTwo.frame=CGRectMake([cell Img02].center.x+([cell Img02].frame.size.width/2) +2, 45, 30,30);
    btnMoreTwo.tag = indexPath.row;
    [btnMoreTwo setBackgroundImage:[UIImage imageNamed:@"More_Icon.png"] forState:UIControlStateNormal];
    [btnMoreTwo addTarget:self action:@selector(btnMoreTwoTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (cell == nil)
    {
        cell = [[FavTableCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    NSArray *subArray = [[NSArray alloc]initWithArray: [TwoQuoteImageArray objectAtIndex:[indexPath row]]];
    if(subArray.count ==2)
    {
        UIImage *img = [subArray objectAtIndex:0];
        UIImage *img1 = [subArray objectAtIndex:1];
        [cell addSubview:btnDeleteOne] ;
        [cell addSubview:btnMoreOne] ;
        [cell Img01].image = img;
        
        [cell Img02].image =img1;
        [cell addSubview:btnDeleteTwo];
        [cell addSubview:btnMoreTwo] ;
    }
    else
    {
        UIImage *img = [subArray objectAtIndex:0];
        [cell Img01].image = img;
        [cell addSubview:btnDeleteOne] ;
        [cell addSubview:btnMoreOne] ;
    }
    
    return cell;
}

-(IBAction)btnDeleteOneTapped:(id)sender
{
    
    UIButton *Button=(id)sender;
    
    int index=Button.tag;
    Favorite_Mdl *info=[favorites objectAtIndex:index];
    int quoteIDVal = [info quoteID];
    Favorite_Cntrl *removeFav =[[Favorite_Cntrl alloc]init];
    [removeFav removeFavoriteQuote:quoteIDVal];
    
    rowCount =0 ;
    self.favorites =[Favorite_Cntrl database].favouriteQuotes;
    self.title = @"Favorites";
    
    
    [self getSectionAndKeyValues];
    //[self tableView].reloadData;
    
}
-(IBAction)btnDeleteTwoTapped:(id)sender
{
    
    UIButton *Button=(id)sender;
    
    int index=Button.tag;
    Favorite_Mdl *info=[favorites objectAtIndex:index];
    int quoteIDVal = [info quoteID];
    Favorite_Cntrl *removeFav =[[Favorite_Cntrl alloc]init];
    [removeFav removeFavoriteQuote:quoteIDVal];
    
    rowCount =0 ;
    self.favorites =[Favorite_Cntrl database].favouriteQuotes;
    self.title = @"Favorites";
    
    
    [self getSectionAndKeyValues];
    //[self tableView].reloadData;
    
}
-(IBAction)btnMoreOneTapped:(id)sender
{
    
    UIButton *Button=(id)sender;
    
    int index=Button.tag;
    //call daily view controller
    Favorite_Mdl *info=[favorites objectAtIndex:index];
    //  Favorite_Mdl *info=[favorites objectAtIndex:rowCount];
    quoteID = [info quoteID];
    
    
    [self.tabBarController setSelectedIndex:0]  ;
    
}
-(IBAction)btnMoreTwoTapped:(id)sender
{
    
    UIButton *Button=(id)sender;
    
    int index=Button.tag;
    //call daily view controller
    Favorite_Mdl *info=[favorites objectAtIndex:index];
    //  Favorite_Mdl *info=[favorites objectAtIndex:rowCount];
    quoteID = [info quoteID];
    
    
    [self.tabBarController setSelectedIndex:0]  ;
    
}


@end
