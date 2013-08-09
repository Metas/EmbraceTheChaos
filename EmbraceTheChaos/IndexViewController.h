//
//  IndexViewController.h
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/24/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlowCoverView.h"
#import "Index_Mdl.h"
#import "Index_Cntrl.h"
#import "DailyQuoteVal.h"

//@class IndexViewController;
//@protocol Index_ViewCntrlDelegate
//- (void)rateView:(IndexViewController *)rateView quoteDidChange:(int) quoteId;
//@end
@interface IndexViewController : UIViewController<FlowCoverViewDelegate>
{
    NSArray *topicPic ;
    int quoteNum ;
}
@property(nonatomic,retain)NSArray *topicPic;

@property (weak, nonatomic) IBOutlet FlowCoverView  *cover;
@property (weak, nonatomic) IBOutlet UILabel *lblTopic;
//@property (assign,nonatomic) id <Index_ViewCntrlDelegate> delegateIndex;
-(int) setQuoteNumber:(int) quoteNumber ;
@end
