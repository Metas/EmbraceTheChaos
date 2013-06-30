//
//  InfoViewController.h
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/24/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>



@interface InfoViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    NSString * TimeSelected;
    NSArray *randomQuote ;
}

//vars
@ property(nonatomic, retain) NSString * TimeSelected ;
@ property (nonatomic,retain)NSArray *randomQuote;

//view and action
@property (weak, nonatomic) IBOutlet UISegmentedControl *OutletTimeSelect;
- (IBAction)TimeChange:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnFeedback;
- (IBAction)btnFeedbackClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnSupport;
- (IBAction)btnSupportClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnWebsite;
- (IBAction)btnWebsiteClick:(id)sender;

//methods
-(void) scheduleNotification: (int) Time;
-(void) showAlert:(NSString *)text ;
-(void) showAlarm:(NSString *)text ;
-(void) composeMail:(NSString *)emailID ;
@end
