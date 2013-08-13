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

-(void) viewDidUnload
{
    favorites =nil;
    [super viewDidUnload];
}
-(void)viewDidLoad
{
    if(INTERFACE_IS_PHONE)
    {
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background3_320X480.png"]]] ;;
        }
        if(result.height == 568)
        {
            [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background3_320X568.png"]]] ;
        }
        
    }
    else if (INTERFACE_IS_PAD)
    {
        [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background3_768X1024.png"]]] ;
        
        
    }
    [self viewDidAppear:YES];
   // self.favorites =[Favorite_Cntrl database].favouriteQuotes;

    //[self getSectionAndKeyValues];

}

-(void) viewDidAppear:(BOOL)animated
{
    favorites =nil;
    self.favorites =[Favorite_Cntrl database].favouriteQuotes;
    
    [self getSectionAndKeyValues];
    [self.tableView reloadData];
}

-(void) getSectionAndKeyValues
{
    [self setSectionKeys:nil];
    [self setSectionContents:nil];
    
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
    TwoQuoteImageArray =nil;
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
    UIButton *btnDeleteOne ;
    UIButton *btnDeleteTwo ;
    UIButton *btnMoreOne ;
    UIButton *btnMoreTwo ;
    static NSString *cellIdentifier=@"Cell";
    FavTableCell *cell =(FavTableCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil)
    {
        cell = [[FavTableCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    UIButton *btn = nil;
    
    NSArray *Array1 = [cell.Img01 subviews] ;
    for (btn in Array1){
        if ([btn isKindOfClass:[UIButton class]]){
            [btn removeFromSuperview];
        }
    }
    
    UIButton *btn2 = nil;
    
    NSArray *Array2 = [cell.Img02 subviews] ;
    for (btn2 in Array2){
        if ([btn2 isKindOfClass:[UIButton class]]){
            [btn2 removeFromSuperview];
        }
    }
    
    
    if (INTERFACE_IS_PAD)
    {
        btnDeleteOne = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDeleteOne.frame=CGRectMake([cell Img01].center.x+([cell Img01].frame.size.width/2) -50, 2, 35,35);
        btnDeleteOne.tag = indexPath.row;
        [btnDeleteOne setBackgroundImage:[UIImage imageNamed:@"btnDelete_60.png"] forState:UIControlStateNormal];
        [btnDeleteOne addTarget:self action:@selector(btnDeleteOneTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        btnMoreOne = [UIButton buttonWithType:UIButtonTypeCustom];
        btnMoreOne.frame=CGRectMake([cell Img01].center.x+([cell Img01].frame.size.width/2) -50, 45, 35,35);
        btnMoreOne.tag = indexPath.row;
        [btnMoreOne setBackgroundImage:[UIImage imageNamed:@"btnDetail_60.png"] forState:UIControlStateNormal];
        [btnMoreOne addTarget:self action:@selector(btnMoreOneTapped:) forControlEvents:UIControlEventTouchUpInside];

        btnDeleteTwo = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDeleteTwo.frame=CGRectMake(cell.Img02.center.x-(cell.Img02.frame.size.width/2)-170, 2, 35,35);
        //btnDeleteTwo.frame=CGRectMake(100, 45, 35,35);
        
        btnDeleteTwo.tag = indexPath.row;
        
        [btnDeleteTwo setBackgroundImage:[UIImage imageNamed:@"btnDelete_60.png"] forState:UIControlStateNormal];
        [btnDeleteTwo addTarget:self action:@selector(btnDeleteTwoTapped:) forControlEvents:UIControlEventTouchUpInside];
        btnMoreTwo = [UIButton buttonWithType:UIButtonTypeCustom];
        btnMoreTwo.frame=CGRectMake([cell Img02].center.x-([cell Img02].frame.size.width/2)-170 , 45, 35,35);
        btnMoreTwo.tag = indexPath.row;
        [btnMoreTwo setBackgroundImage:[UIImage imageNamed:@"btnDetail_60.png"] forState:UIControlStateNormal];
        [btnMoreTwo addTarget:self action:@selector(btnMoreTwoTapped:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else//iphone
    {
        btnDeleteOne = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDeleteOne.frame=CGRectMake([cell Img01].center.x+([cell Img01].frame.size.width/2) -50, 2, 35,35);
        btnDeleteOne.tag = indexPath.row;
        [btnDeleteOne setBackgroundImage:[UIImage imageNamed:@"btnDelete_40.png"] forState:UIControlStateNormal];
        [btnDeleteOne addTarget:self action:@selector(btnDeleteOneTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        btnMoreOne = [UIButton buttonWithType:UIButtonTypeCustom];
        btnMoreOne.frame=CGRectMake([cell Img01].center.x+([cell Img01].frame.size.width/2) -50, 45, 35,35);
        btnMoreOne.tag = indexPath.row;
        [btnMoreOne setBackgroundImage:[UIImage imageNamed:@"btnDetail_40.png"] forState:UIControlStateNormal];
        [btnMoreOne addTarget:self action:@selector(btnMoreOneTapped:) forControlEvents:UIControlEventTouchUpInside];

        btnDeleteTwo = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDeleteTwo.frame=CGRectMake(cell.Img02.center.x-(cell.Img02.frame.size.width/2)-70, 2, 35,35);
        
        btnDeleteTwo.tag = indexPath.row;
        
        [btnDeleteTwo setBackgroundImage:[UIImage imageNamed:@"btnDelete_40.png"] forState:UIControlStateNormal];
        [btnDeleteTwo addTarget:self action:@selector(btnDeleteTwoTapped:) forControlEvents:UIControlEventTouchUpInside];
        btnMoreTwo = [UIButton buttonWithType:UIButtonTypeCustom];
        btnMoreTwo.frame=CGRectMake([cell Img02].center.x-([cell Img02].frame.size.width/2)-70 , 45, 35,35);
        btnMoreTwo.tag = indexPath.row;
        [btnMoreTwo setBackgroundImage:[UIImage imageNamed:@"btnDetail_40.png"] forState:UIControlStateNormal];
        [btnMoreTwo addTarget:self action:@selector(btnMoreTwoTapped:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
  
    

    NSArray *subArray = [[NSArray alloc]initWithArray: [TwoQuoteImageArray objectAtIndex:[indexPath row]]];
  

    
    if(subArray.count ==2)
    {
        //clear out
        [cell Img01].image = nil;
        [cell Img02].image =nil;
        //a hack

        
        UIImage *img = [subArray objectAtIndex:0];
        UIImage *img1 = [subArray objectAtIndex:1];

        [cell Img01].image = img;
        [cell Img01].userInteractionEnabled =YES;
        [cell Img02].image =img1;
        [cell Img02].userInteractionEnabled =YES;
        
        [cell.Img01 addSubview:btnDeleteOne];
        [cell.Img01 addSubview:btnMoreOne];
        [cell.Img02 addSubview:btnDeleteTwo];
        [cell.Img02 addSubview:btnMoreTwo];
        btnDeleteOne =nil;
        btnDeleteTwo = nil;
        btnMoreOne =nil;
        btnMoreTwo =nil;
        
    }
    else
    {
        //clear out
        
        [cell Img01].image = nil;
        [cell Img02].image =nil;
        //[cell.Img02 removeFromSuperview];
        UIImage *img = [subArray objectAtIndex:0];

        [cell Img01].image = img;
        [cell.Img01 addSubview:btnDeleteOne];
        [cell.Img01 addSubview:btnMoreOne];

        [cell Img01].userInteractionEnabled =YES;
        btnDeleteOne =nil;
        btnMoreOne =nil;
    }
    
    return cell;
}

-(IBAction)btnDeleteOneTapped:(id)sender
{
    
    UIButton *Button=(id)sender;
    
    int index=Button.tag;
    int ind ;
    if(index ==0)//do nothing
    {
        ind = index;
    }
    else
    {
        ind = index+index;
    }
    if(ind >= favorites.count)//then the last object was deleted
        ind = favorites.count-1;
    
    Favorite_Mdl *info=[favorites objectAtIndex:ind];
    int quoteIDVal = [info quoteID];
    Favorite_Cntrl *removeFav =[[Favorite_Cntrl alloc]init];
    [removeFav removeFavoriteQuote:quoteIDVal];
    
    favorites =nil;
    TwoQuoteImageArray =nil;
    self.favorites =nil;
    //[self viewDidAppear:YES];
    self.favorites =[Favorite_Cntrl database].favouriteQuotes;
    
    [self getSectionAndKeyValues];
    [self.tableView reloadData];
     
}
-(IBAction)btnDeleteTwoTapped:(id)sender
{
    
    UIButton *Button=(id)sender;
    
    int index=Button.tag;
    int ind ;
    if(index ==0)//add one
    {
        ind = index +1;
    }
    else
    {
        ind = index+index+1;
    }
    
    if(ind >= favorites.count)//then the last object was deleted
        ind = favorites.count-1 ;
    
    
    
    Favorite_Mdl *info=[favorites objectAtIndex:ind];
    int quoteIDVal = [info quoteID];
    Favorite_Cntrl *removeFav =[[Favorite_Cntrl alloc]init];
    [removeFav removeFavoriteQuote:quoteIDVal];
    
    favorites =nil;
    TwoQuoteImageArray =nil;
    self.favorites =nil;
    self.favorites =[Favorite_Cntrl database].favouriteQuotes;

    
    [self getSectionAndKeyValues];
    [self.tableView reloadData];
    //btnDeleteTwo.hidden =YES;
    
    //[self viewDidAppear:YES];
    
}
-(IBAction)btnMoreOneTapped:(id)sender
{
    
    UIButton *Button=(id)sender;
    
    int index=Button.tag;
    int ind ;
    if(index ==0)//do nothing
    {
        ind = index;
    }
    else
    {
        ind = index+index;
    }
    if(ind >= favorites.count)//then the last object was selected
        ind = favorites.count-1 ;
    //call daily view controller
    Favorite_Mdl *info=[favorites objectAtIndex:ind];
    quoteID = [info quoteID];
    
    
    [self.tabBarController setSelectedIndex:0]  ;
    
}
-(IBAction)btnMoreTwoTapped:(id)sender
{
    
    UIButton *Button=(id)sender;
    
    int index=Button.tag;
    int ind ;
    if(index ==0)//add one
    {
        ind = index +1;
    }
    else
    {
        ind = index+index+1;
    }
    if(ind >= favorites.count)//then the last object was selected
        ind = favorites.count -1;
    //call daily view controller
    Favorite_Mdl *info=[favorites objectAtIndex:ind];
    quoteID = [info quoteID];
    
    
    [self.tabBarController setSelectedIndex:0]  ;
    
}


@end
