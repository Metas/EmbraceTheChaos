//
//  IndexViewController.m
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/24/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import "IndexViewController.h"
#import "FlowCoverView.h"
#import "DailyViewController.h"


@implementation IndexViewController
@synthesize cover;
@synthesize lblTopic;
@synthesize topicPic ;
//@synthesize delegateIndex;


-(int) setQuoteNumber:(int)quoteNumber
{
    NSLog(@"In IndexControl %d",quoteNumber);

    //[self.delegateIndex rateView:self quoteDidChange:quoteNumber];
    
    
    return 0;
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

- (void)viewDidUnload {
    [self setCover:nil];
    [self setLblTopic:nil];

    [super viewDidUnload];
}
-(void) viewDidLoad
{
    [super viewDidLoad];
    //customize
    //UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if(INTERFACE_IS_PHONE)
    {
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background2_320X480.png"]]] ;;
        }
        if(result.height == 568)
        {
            [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background2_320X568.png"]]] ;
        }
        
    }
    else if (INTERFACE_IS_PAD)
    {
        [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background2_768X1024.png"]]] ;
        
        
    }
    

    self.cover.delegate = self;
    //self.delegateIndex =self;
}
// Add to bottom
- (void)rateView:(FlowCoverView *)rateView ratingDidChange:(int)rating 
{
    quoteID = rating;//global var 

    [self.tabBarController setSelectedIndex:0]  ;
    //[UIView transitionFromView:self.view toView:[[self.tabBarController.viewControllers objectAtIndex:0] view] duration:1 options:UIModalTransitionStyleFlipHorizontal completion:^(BOOL finished) { if (finished) { [self.tabBarController setSelectedIndex:0]  ;}}];
}
@end
