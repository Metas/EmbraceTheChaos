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
@synthesize delegateIndex;


-(int) setQuoteNumber:(int)quoteNumber
{
    NSLog(@"In IndexControl %d",quoteNumber);

    [self.delegateIndex rateView:self quoteDidChange:quoteNumber];
    
    
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
    self.cover.delegate = self;
    self.delegateIndex =self;
}
// Add to bottom
- (void)rateView:(FlowCoverView *)rateView ratingDidChange:(int)rating 
{
    quoteNum = rating;
    
    int val = [self setQuoteNumber:quoteNum];
    if(val ==0)
    [self.tabBarController setSelectedIndex:0]  ;
    //[UIView transitionFromView:self.view toView:[[self.tabBarController.viewControllers objectAtIndex:0] view] duration:1 options:UIModalTransitionStyleFlipHorizontal completion:^(BOOL finished) { if (finished) { [self.tabBarController setSelectedIndex:0]  ;}}];
}
@end
