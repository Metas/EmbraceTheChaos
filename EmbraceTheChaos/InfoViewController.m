//
//  InfoViewController.m
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/24/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import "InfoViewController.h"
#import "Info_Mdl.h"
#import "Info_Cntrl.h"
#import "WebsiteViewController.h"

@implementation InfoViewController

@synthesize TimeSelected;
@synthesize randomQuote;
@synthesize btnWebsite;
@synthesize btnSupport;
@synthesize btnFeedback;
@synthesize OutletTimeSelect;

-(void) viewDidLoad
{
    [super viewDidLoad];
    //customize
   // UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
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
    TimeSelected = nil;
    [self setOutletTimeSelect:nil];
    [self setBtnFeedback:nil];
    [self setBtnSupport:nil];
    [self setBtnWebsite:nil];
    [super viewDidUnload];
}
- (IBAction)TimeChange:(id)sender 
{
    TimeSelected = [OutletTimeSelect titleForSegmentAtIndex:[OutletTimeSelect selectedSegmentIndex]];
    
    if( [TimeSelected compare:@"OFF"]==0)//cancel all notifications
    {
        [[UIApplication sharedApplication] cancelAllLocalNotifications] ;
        

        [self showAlert:@"You will not recieve a new quote everyday"] ;
    }
    else
    {
        int timeIs ;
        if([TimeSelected compare:@"10 AM"]==0)
        {
            timeIs=15;
           [self showAlert:@"You will recieve a new quote everyday at 10 AM"] ;
        }
        else if([TimeSelected compare:@"2 PM"]==0)
        {
            timeIs=19;
           [self showAlert:@"You will recieve a new quote everyday at 2 PM"] ;
        }
        else if([TimeSelected compare:@"6 PM"]==0)
        {
            timeIs=23 ;
            [self showAlert:@"You will recieve a new quote everyday at 6 PM" ];
        }
        else //default 5 AM
        {
            timeIs=0;
        }
        [self scheduleNotification:timeIs];
    }
}
-(void) showAlert:(NSString *)text
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Quote"message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}
-(void) showAlarm:(NSString *)text
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Quote"message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}
- (IBAction)btnFeedbackClick:(id)sender 
{
    [self composeMail:@"reachshrutinaidu@yahoo.com"];//get proper email address here
}
- (IBAction)btnSupportClick:(id)sender 
{
    [self composeMail:@"reachshrutinaidu@yahoo.com"];//get proper email 
}
- (IBAction)btnWebsiteClick:(id)sender 
{
    [self performSegueWithIdentifier:@"GoToWebsite" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"GoToWebsite"])
    {
        [segue destinationViewController];
    }
}

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
        [mailer setMessageBody:newString isHTML:NO];
        [self presentModalViewController:mailer animated:YES];
    }
    else
    {
        [self showAlert:@"Cannot send email"];
    }
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

-(void) scheduleNotification:(int)Time
{
    //cancel all notifications
    [[UIApplication sharedApplication] cancelAllLocalNotifications] ;
    
    //set gregarion calendar
    
    
    NSDate *date = [NSDate date];
    
    NSCalendar *greg = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *componants = [greg components:NSDayCalendarUnit fromDate:date];
    [componants setHour:Time];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc]init];
    if(localNotif == nil)
    {
        return;
    }
    NSDate *fireDate = [greg dateFromComponents:componants];
    NSLog(@"Date is %@",fireDate);
    //***************testing piece
//    NSDate *now = [NSDate date];
//    NSDate *dateToFire = [now dateByAddingTimeInterval:5] ;
//    NSLog(@"Nowtime %@",now);
//    NSLog(@"Firetime %@",dateToFire);
//    localNotif.fireDate = dateToFire ;
    //***********
    
    localNotif.fireDate = fireDate;
    localNotif.repeatInterval = kCFCalendarUnitDay ;//kCFCalendarUnitMinute;// 
    localNotif.timeZone = [NSTimeZone defaultTimeZone];

    
    //Notification details: get arandom quote here and display
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Object1",@"Key1",nil];
    localNotif.userInfo = infoDict;
    //schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}
@end
