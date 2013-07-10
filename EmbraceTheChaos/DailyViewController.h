//
//  DailyViewController.h
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/24/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyCoverView.h"

@interface DailyViewController : UIViewController
{
    NSArray *dailyQuote ;
    NSInteger quoteNum ;
    UIImage * picture;
    NSMutableArray * lastQuoteNum ;
}

@property(nonatomic,retain)NSArray *dailyQuote;
@property (weak, nonatomic) IBOutlet UIImageView *DailyQuoteView;

//@property (weak, nonatomic) IBOutlet DailyCoverView *cover;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnFavorite;
- (IBAction)btnFavAdd:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSaveImge;
- (IBAction)btnSaveImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnShare;
- (IBAction)btnShare:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnNextQuote;
- (IBAction)btnNextQuote:(id)sender;

-(UIImage*) drawText:(NSString*) text inImage:(UIImage*)  image ;


@end
