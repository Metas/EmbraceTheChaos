//
//  ShareViewController.h
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 7/10/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Share_Mdl.h"
#import <MessageUI/MessageUI.h>


@interface ShareViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    Share_Mdl * shareValue;
    UIImage *picture ;
    UIActivityIndicatorView *activity;
}
@property(nonatomic,retain)Share_Mdl *shareValue;
@property(nonatomic, retain)UIImage *picture;

@property (weak, nonatomic) IBOutlet UIButton *Twitter;
@property (weak, nonatomic) IBOutlet UIButton *Facebook;
@property (weak, nonatomic) IBOutlet UIButton *Email;
@property (weak, nonatomic) IBOutlet UIButton *Cancel;
- (IBAction)Cancel:(id)sender;
- (IBAction)Email:(id)sender;
- (IBAction)Facebook:(id)sender;
- (IBAction)Twitter:(id)sender;
-(void) shareInfo:(Share_Mdl*) share  ;
-(void) composeMail:(NSString *)emailID ;
-(void) showAlert:(NSString *)text ;
-(void)promptUserWithAccountName;
-(void)controlStatusUsable:(BOOL)usable;
@end
