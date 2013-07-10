//
//  DailyViewController.m
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/24/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import "DailyViewController.h"
#import "Daily_Mdl.h"
#import "Daily_Cntrl.h"

@implementation DailyViewController

@synthesize btnNextQuote;
@synthesize btnShare;
@synthesize btnSaveImge;
@synthesize DailyQuoteView;
//@synthesize cover;
@synthesize btnFavorite;
@synthesize dailyQuote ;

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
    //set the right swipe gesture here
    self.DailyQuoteView.userInteractionEnabled =YES;
    UISwipeGestureRecognizer *SwipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeRight:)];
    [SwipeRight setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self DailyQuoteView] addGestureRecognizer:SwipeRight];
    
    //set the Left swipe gesture here
    self.DailyQuoteView.userInteractionEnabled =YES;
    UISwipeGestureRecognizer *SwipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeLeft:)];
    [SwipeLeft setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self DailyQuoteView] addGestureRecognizer:SwipeLeft];

    lastQuoteNum =[[NSMutableArray alloc]init];
    
    [super viewDidLoad];
    self.dailyQuote =[Daily_Cntrl database].DailyQuote;
    self.title = @"DailyQuote";
    
    if(dailyQuote.count !=0)
    {
        Daily_Mdl *info=[dailyQuote objectAtIndex:0];
        picture = [self drawText:info.quote inImage:info.pic ];
        quoteNum = info.quoteID ;
        [lastQuoteNum addObject: [NSNumber numberWithInt:quoteNum]];
    [[self DailyQuoteView]setImage:picture];
    }
    else
    {
        NSLog(@"GOT EMPTY VALUES");
    }
    
    //[self getSectionAndKeyValues];
    
    
}
#pragma Gesture recognizers
-(void)handleSwipeLeft:(UISwipeGestureRecognizer *)recognizer 
{
    
    
    NSLog(@"Left Swipe received.");
    //get another rndom quote
    
    Daily_Cntrl *lastQuote = [[Daily_Cntrl alloc]init];
    int lastNumberIs ;
    int i= [lastQuoteNum count];
    if(i !=0)
    {
        int j = i-2;
        if(j <= 0)
            j=0;
       lastNumberIs  = [[lastQuoteNum objectAtIndex:j]intValue];  
    }
    else
        lastNumberIs = 0;
    self.dailyQuote =[lastQuote LastQuote: lastNumberIs];
    self.title = @"DailyQuote";
    
    if(dailyQuote.count !=0)
    {
        Daily_Mdl *info=[dailyQuote objectAtIndex:0];
        picture = [self drawText:info.quote inImage:info.pic ];
        quoteNum = info.quoteID ;
        [[self DailyQuoteView]setImage:picture];
        
    }
    else
    {
        NSLog(@"GOT EMPTY VALUES");
    }
    
   
    

}

-(void)handleSwipeRight:(UISwipeGestureRecognizer *)recognizer 
{
    NSLog(@"Right Swipe received.");
    //get another rndom quote
    self.dailyQuote =[Daily_Cntrl database].DailyQuote;
    self.title = @"DailyQuote";
    
    if(dailyQuote.count !=0)
    {
        Daily_Mdl *info=[dailyQuote objectAtIndex:0];
        picture = [self drawText:info.quote inImage:info.pic ];
        quoteNum = info.quoteID ;
        [lastQuoteNum addObject: [NSNumber numberWithInt:quoteNum]];
        [[self DailyQuoteView]setImage:picture];
        
    }
    else
    {
        NSLog(@"GOT EMPTY VALUES");
    }
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


- (void)viewDidUnload 
{
    //[self setCover:nil];
    [self setBtnFavorite:nil];
    [self setBtnSaveImge:nil];
    [self setBtnShare:nil];
    [self setBtnNextQuote:nil];
    [self setDailyQuoteView:nil];
    [super viewDidUnload];
}
- (IBAction)btnFavAdd:(id)sender 
{
    //add to sqlite db in fav table
    //Daily_Cntrl *addToFav =[[Daily_Cntrl alloc]init];
    [[Daily_Cntrl database]AddFav:quoteNum];
    //[addToFav AddFav:quoteNum];
}
- (IBAction)btnSaveImage:(id)sender 
{
    //save this image as a background
    NSData* imageData =  UIImagePNGRepresentation(picture);     // get png representation
    UIImage* pngImage = [UIImage imageWithData:imageData];    // rewrap
    UIImageWriteToSavedPhotosAlbum(pngImage, nil, nil, nil);  // save to photo album
    
}
- (IBAction)btnShare:(id)sender 
{
    //call another screen to share with facebook, twitter or email
}
- (IBAction)btnNextQuote:(id)sender 
{
    //get another rndom quote
    self.dailyQuote =[Daily_Cntrl database].DailyQuote;
    self.title = @"DailyQuote";
    
    if(dailyQuote.count !=0)
    {
        Daily_Mdl *info=[dailyQuote objectAtIndex:0];
        picture = [self drawText:info.quote inImage:info.pic ];
        quoteNum = info.quoteID ;
        [lastQuoteNum addObject: [NSNumber numberWithInt:quoteNum]];
        [[self DailyQuoteView]setImage:picture];
        
    }
    else
    {
        NSLog(@"GOT EMPTY VALUES");
    }

    
}
@end
