//
//  DailyViewController.h
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/24/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyCoverView.h"
#import "IndexViewController.h"
#import "Share_Mdl.h"

@interface DailyViewController : UIViewController <Index_ViewCntrlDelegate>
{
    NSArray *dailyQuote ;
    NSInteger quoteNum ;
    UIImage * picture;
    NSMutableArray * lastQuoteNum ;
    Share_Mdl *Qpicture ;
    IndexViewController* control1;
    int quoteNumber ;
}
@property (strong, nonatomic) IndexViewController  *control1;

@property(nonatomic,assign) int quoteNumber;
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

//-(void) initWithIndex:(int) index ;

@end
