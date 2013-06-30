//
//  DailyViewController.m
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/24/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import "DailyViewController.h"

@implementation DailyViewController
@synthesize btnNextQuote;
@synthesize btnShare;
@synthesize btnSaveImge;
@synthesize cover;
@synthesize btnFavorite;

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
    [self setBtnFavorite:nil];
    [self setBtnSaveImge:nil];
    [self setBtnShare:nil];
    [self setBtnNextQuote:nil];
    [super viewDidUnload];
}
- (IBAction)btnFavAdd:(id)sender {
}
- (IBAction)btnSaveImage:(id)sender {
}
- (IBAction)btnShare:(id)sender {
}
- (IBAction)btnNextQuote:(id)sender {
}
@end
