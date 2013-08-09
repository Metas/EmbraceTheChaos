//
//  DailyViewController.h
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/24/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyCoverView.h"
//#import "IndexViewController.h"
#import "Share_Mdl.h"
#import "FlowCoverView.h"
#import "DailyQuoteVal.h"

@interface DailyViewController : UIViewController <FlowCoverViewDelegate>//Index_ViewCntrlDelegate>
{
    NSArray *dailyQuote ;
    NSInteger quoteNum ;
    UIImage * picture;
    NSMutableArray * lastQuoteNum ;
    Share_Mdl *Qpicture ;
    //IndexViewController* control1;
    int quoteNumber ;
    CGPoint FavCntr;
    CGPoint ShrCntr;
    CGPoint SavCntr;
    CGPoint NxtCntr;
    CGPoint MoreCntr;
}
@property (weak, nonatomic) FlowCoverView  *cover;
//@property (strong, nonatomic) IndexViewController  *control1;
@property(nonatomic,assign) int quoteNumber;
@property(nonatomic,retain)NSArray *dailyQuote;
@property (weak, nonatomic) IBOutlet UIImageView *DailyQuoteView;

//@property (weak, nonatomic) IBOutlet DailyCoverView *cover;


@property (weak, nonatomic) IBOutlet UIButton *btnMore;
@property (weak, nonatomic) IBOutlet UIButton *btnFav;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnShr;

- (IBAction)btnClickFav:(id)sender;
- (IBAction)btnClickSave:(id)sender;
- (IBAction)btnClickShare:(id)sender;
- (IBAction)btnClickNext:(id)sender;

- (IBAction)btnClickMore:(id)sender;




-(UIImage*) drawText:(NSString*) text inImage:(UIImage*)  image ;
-(void) viewDidLoadWithQoteNum:(int)quoteN ;
-(void) animateForward ;
-(int) animateBackward;
- (void) moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option;
//-(void) initWithIndex:(int) index ;

@end
