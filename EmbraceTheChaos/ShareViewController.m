//
//  ShareViewController.m
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 7/10/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import "ShareViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>

@implementation ShareViewController
@synthesize Twitter;
@synthesize Facebook;
@synthesize Email;
@synthesize Cancel;
@synthesize shareValue;
@synthesize picture;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)shareInfo:(Share_Mdl *)share
{
    
    self.picture=share.quotePic ;
    NSLog(@"InShare %@",self.picture.description);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //customize
    //UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if(INTERFACE_IS_PHONE)
    {
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background4_320X480.png"]]] ;;
        }
        if(result.height == 568)
        {
            [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background4_320X568.png"]]] ;
        }
        
    }
    else if (INTERFACE_IS_PAD)
    {
        [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background4_768X1024.png"]]] ;
        
        
    }
    


}


- (void)viewDidUnload
{
    [self setTwitter:nil];
    [self setFacebook:nil];
    [self setEmail:nil];
    [self setCancel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)Cancel:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)Email:(id)sender 
{
    [self composeMail:@" "];//get proper email address here
}
#pragma email

-(void) composeMail:(NSString *)emailID
{
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer =[[MFMailComposeViewController alloc]init];
        mailer.mailComposeDelegate =self;
        NSArray *toRecipients = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",emailID],nil];
        [mailer setToRecipients:toRecipients];
        NSMutableString *emailBody =[[NSMutableString alloc]initWithString:@""];
        
        NSString * newString =[emailBody stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        NSData *pngData = UIImagePNGRepresentation(self.picture);
        [mailer addAttachmentData:pngData mimeType:@"image/png" fileName:@"quote.png"];
        [mailer setMessageBody:newString isHTML:NO];
        [self presentModalViewController:mailer animated:YES];
    }
    else
    {
        [self showAlert:@"Cannot send email"];
    }
}
-(void) showAlert:(NSString *)text
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Quote"message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch(result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)Facebook:(id)sender 
{
    
     if (FBSession.activeSession.isOpen) 
     {
         // Yes, we are open, so lets make a request for user details so we can get the user name.
         
         [self promptUserWithAccountName];// a custom method - see below:
     } 
     else 
     {
         // We don't have an active session in this app, so lets open a new
         // facebook session with the appropriate permissions!
         
         // Firstly, construct a permission array.
         // you can find more "permissions strings" at http://developers.facebook.com/docs/authentication/permissions/
         // In this example, we will just request a publish_stream which is required to publish status or photos.
         
         NSArray *permissions = [[NSArray alloc] initWithObjects:
                                 @"publish_stream",
                                 nil];
         
         // OPEN Session!
         [self controlStatusUsable:NO];
         [FBSession openActiveSessionWithPermissions:permissions
                                        allowLoginUI:YES
                                   completionHandler:^(FBSession *session, 
                                                       FBSessionState status, 
                                                       NSError *error) 
         {
           // if login fails for any reason, we alert
           if (error) 
           {
             // show error to user.
            } 
           else if (FB_ISSESSIONOPENWITHSTATE(status)) 
           {
                                           
             // no error, so we proceed with requesting user details of current facebook session.
             [self promptUserWithAccountName];   // a custom method - see below:                              
           }
           [self controlStatusUsable:YES];
        }];
     }
}
-(void)promptUserWithAccountName 
{
    [self controlStatusUsable:NO];
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
         if (!error) {
             
             UIAlertView *tmp = [[UIAlertView alloc] 
                                 initWithTitle:@"Upload to FB?" 
                                 message:[NSString stringWithFormat:@"Upload to ""%@"" Account?", user.name]
                                 delegate:self 
                                 cancelButtonTitle:nil
                                 otherButtonTitles:@"No",@"Yes", nil];
             tmp.tag = 100; // We are also setting the tag to this alert so we can identify it in delegate method later
             [tmp show];
             
         }
         //[self controlStatusUsable:YES]; // whether error occur or not, enable back the UI
     }];  
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex==1) { // yes answer
        
        // did the alert responded to is the one prompting about user name? if so, upload!
        if (alertView.tag==100) 
        {
            // then upload
            [self controlStatusUsable:NO];
            
            // Here is where the UPLOADING HAPPENS!
            [FBRequestConnection startForUploadPhoto:[self picture] 
                                   completionHandler:^(FBRequestConnection *connection, id result, NSError *error) 
            {
              if (!error) 
              {
                UIAlertView *tmp = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Photo Uploaded"delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [tmp show]; 
               } 
              else 
              {
               UIAlertView *tmp = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Some error happened"delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
              [tmp show];
              }
                                       
             [self controlStatusUsable:YES];
           }];
            
        }
        
    }
    
}
-(void)controlStatusUsable:(BOOL)usable 
{  
    if (usable) {  
        //btnUploadImg.userInteractionEnabled = YES;  
        //btnUpdateStatus.userInteractionEnabled = YES;  
        //self.activity.hidden = YES;  
        //[self.activity stopAnimating];  
    } else {  
        //btnUploadImg.userInteractionEnabled = NO;  
        //btnUpdateStatus.userInteractionEnabled = NO;  
        //self.activity.hidden = NO;  
        //[self activity startAnimating];  
    }  
    
}  
- (IBAction)Twitter:(id)sender 
{
    if ([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetSheet = 
        [[TWTweetComposeViewController alloc] init];
        [tweetSheet setInitialText:
         @"Tweeting quotes from Embrace the Chaos App :)"];
        [tweetSheet addImage:[self picture]];
	    [self presentModalViewController:tweetSheet animated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] 
                                  initWithTitle:@"Sorry"                                                             message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"                                                          
                                  delegate:self                                              
                                  cancelButtonTitle:@"OK"                                                   
                                  otherButtonTitles:nil];
        [alertView show];
    }
}
@end
