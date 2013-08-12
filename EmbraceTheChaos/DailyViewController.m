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
#import "ShareViewController.h"

@implementation DailyViewController


@synthesize DailyQuoteView;

@synthesize dailyQuote ;
@synthesize quoteNumber;
@synthesize cover;

-(id) init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
    
}


-(void) viewDidAppear:(BOOL)animated
{
    
    NSLog(@"QuoteNumber is %d",quoteID);
    if(quoteID !=0)
        [self viewDidLoadWithQoteNum:quoteID];
}
-(void) viewDidLoadWithQoteNum:(int)quoteN
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
    
    //[super viewDidLoad];
    //control1 = [[IndexViewController alloc]init];
    
    //[self.control1 setDelegateIndex:self];
    
    Daily_Cntrl *lastQuote = [[Daily_Cntrl alloc]init];
    
    self.dailyQuote =[lastQuote LastQuote: quoteN];
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
-(void) viewDidLoad
{
    //customize
    //CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    //UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if(INTERFACE_IS_PHONE)
    {
      
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height == 480)
            {
                [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background1_320X480.png"]]] ;;
            }
            if(result.height == 568)
            {
                [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background1_320X568.png"]]] ;
            }
            
    }
    else if (INTERFACE_IS_PAD)
    {
            [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background1_768X1024.png"]]] ;

            
    }
    
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
    //get btn original center point
    FavCntr = [self btnFav].center;
    SavCntr = [self btnSave].center;
    NxtCntr =[self btnNext].center;
    ShrCntr =[self btnShr].center;
    MoreCntr =[self btnMore].center;
    
    //hide all buttons
   [self btnFav].hidden =YES;
    [self btnSave].hidden =YES;
    [self btnNext].hidden =YES;
    [self btnShr].hidden =YES;
    
    //insert today date in More
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"d MMM"];
    NSString *dateString = [dateFormat stringFromDate:date];
    [self.btnMore setTitle:dateString forState:UIControlStateNormal];
    
    
    [super viewDidLoad];
    self.cover.delegate = self;
    //control1 = [[IndexViewController alloc]init];
    
    //[self.control1 setDelegateIndex:self];
    @try {
            self.dailyQuote =[Daily_Cntrl database].DailyQuote;
        }
    @catch (NSException *exception) {
        NSLog(@"Exception %@",exception.description);
    }
    
    self.title = @"DailyQuote";
    
    if(dailyQuote.count !=0)
    {
        Daily_Mdl *info=[dailyQuote objectAtIndex:0];
        //to accomodate for null quotes that is text in image
        if((info.quote ==NULL)||(info.quote.length ==0))
            picture = info.pic;
        else
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
        //to accomodate for null quotes that is text in image
        if((info.quote ==NULL)||(info.quote.length ==0))
            picture = info.pic;
        else
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
        //to accomodate for null quotes that is text in image
        if((info.quote ==NULL)||(info.quote.length ==0))
            picture = info.pic;
        else
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


- (IBAction)btnClickFav:(id)sender
{
    //add to sqlite db in fav table
    //Daily_Cntrl *addToFav =[[Daily_Cntrl alloc]init];
    [[Daily_Cntrl database]AddFav:quoteNum];
    //[addToFav AddFav:quoteNum];
}

- (IBAction)btnClickSave:(id)sender
{
    //save this image as a background
    NSData* imageData =  UIImagePNGRepresentation(picture);     // get png representation
    UIImage* pngImage = [UIImage imageWithData:imageData];    // rewrap
    UIImageWriteToSavedPhotosAlbum(pngImage, nil, nil, nil);  // save to photo album

}

- (IBAction)btnClickShare:(id)sender
{
    //call another screen to share with facebook, twitter or email
    NSData* imageData =  UIImagePNGRepresentation(picture);     // get png representation
    UIImage* pngImage = [UIImage imageWithData:imageData];    // rewrap
    Qpicture = [[Share_Mdl alloc]init];
    Qpicture.quotePic = pngImage ;
    [self performSegueWithIdentifier:@"Share" sender:self];

}

- (IBAction)btnClickNext:(id)sender
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

- (IBAction)btnClickMore:(id)sender
{
    if(([self btnFav].hidden)||([self btnNext].hidden) ||([self btnSave].hidden) || ([self btnShr].hidden))
    {
        [self btnFav].hidden =NO;
        [self btnNext].hidden = NO;
        [self btnSave].hidden =NO;
        [self btnShr].hidden =NO;
        [self animateForward];
    }
    else
    {
        int i = [self animateBackward];
        if(i==1)
        {
            [self btnFav].hidden =YES;
            [self btnNext].hidden =YES;
            [self btnSave].hidden =YES;
            [self btnShr].hidden =YES;
        }
        
    }

        
}

-(int) animateBackward
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.12f];
    [self btnMore].center = MoreCntr;
    [self btnFav].center = FavCntr;
    [self btnNext].center = NxtCntr;
    [self btnShr].center = ShrCntr;
    [self btnSave].center = SavCntr;
    [UIView commitAnimations];
    return 1;
    
}
-(void) animateForward
{
    CGPoint newMoreCntr = CGPointMake(MoreCntr.x, MoreCntr.y-30);
        CGPoint newFavCenter = CGPointMake(FavCntr.x-30, FavCntr.y);
        CGPoint newNextCenter = CGPointMake(NxtCntr.x+30, NxtCntr.y);
        CGPoint newSaveCenter = CGPointMake(SavCntr.x-15, SavCntr.y-30);
        CGPoint newShrCenter = CGPointMake(ShrCntr.x+15, ShrCntr.y-30);
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.12f];
        [self btnMore].center = newMoreCntr;
        [self btnFav].center = newFavCenter;
        [self btnNext].center = newNextCenter;
        [self btnSave].center = newSaveCenter;
        [self btnShr].center = newShrCenter;
        [UIView commitAnimations];
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
    
    [self setDailyQuoteView:nil];
    [self setBtnMore:nil];
    [self setBtnFav:nil];
    [self setBtnSave:nil];
    [self setBtnShr:nil];
    [self setBtnNext:nil];
    [super viewDidUnload];
}
- (IBAction)btnFavAdd:(id)sender 
{
}
- (IBAction)btnSaveImage:(id)sender 
{
    
}
- (IBAction)btnShare:(id)sender 
{

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"Share"])
    {
        // Get destination view
        //ShareViewController *vc = [segue destinationViewController];
        [(ShareViewController *)[segue destinationViewController]shareInfo:Qpicture];
        // Pass the information to your destination view
        //[vc shareInfo:Qpicture];
    }
}
- (IBAction)btnNextQuote:(id)sender 
{
    
}
// Add to bottom
- (void)rateView:(FlowCoverView *)rateView ratingDidChange:(int)rating 
{
    quoteNumber = rating;
        [self.tabBarController setSelectedIndex:0]  ;
    //[UIView transitionFromView:self.view toView:[[self.tabBarController.viewControllers objectAtIndex:0] view] duration:1 options:UIModalTransitionStyleFlipHorizontal completion:^(BOOL finished) { if (finished) { [self.tabBarController setSelectedIndex:0]  ;}}];
}

@end
