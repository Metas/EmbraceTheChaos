//
//  AppDelegate.m
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/23/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import "AppDelegate.h"
#import "CrudOps_Cntrl.h"
#import <FacebookSDK/FacebookSDK.h>
#import "WebserviceCall.h"


@implementation AppDelegate
@synthesize quoteID;
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //copy database from resources(which is read only to documents where you can perform writes and reads
    
    CrudOps_Cntrl *dbControl = [[CrudOps_Cntrl alloc]init];
    [dbControl CopyDbToDocumentsFolder];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [self customizeAppearance];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    NSDictionary *remoteNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    //copy this to if you recieve remote notif
    //[self addQuotes];
    if(remoteNotif)
    {
        //call webservice to get last 5 quotes
        NSLog(@"RemoteNotification recieved;App did finishlaunching launched");
        [self addQuotes];
    }
    return YES;
}

#pragma remoteNotification
-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token =[deviceToken description];
    NSLog(@"My token is :%@",token) ;
    token = [token stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    WebserviceCall *ws = [[WebserviceCall alloc]init];
    [ws executeForToken:token];
    
}
-(void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
     NSLog(@"Failed to get token, error: %@",error) ;
}
-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"Push Alert" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    //call webservice to get last 5 quotes
    NSLog(@"RemoteNotification recieved;AppdidRecieveRemoteNotification launched");
    [self addQuotes];
}
-(void) addQuotes
{
    WebserviceCall *ws = [[WebserviceCall alloc]init];
    [ws execute];
}
#pragma customize
-(void) customizeAppearance
{
    UIImage *gradientImage ;
    if(INTERFACE_IS_PAD)
    {
        gradientImage = [[UIImage imageNamed:@"A.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    else
    {
         gradientImage = [[UIImage imageNamed:@"A.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    //Customize for all navigation bars
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.05 green:0.3 blue:0.53 alpha:1.0], UITextAttributeTextColor,[UIColor                                                                                                                                                                                          colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, -0.1)],UITextAttributeTextShadowOffset,[UIFont fontWithName:@"Arial-Bold" size:0.0],UITextAttributeFont,nil]];
    
    //Customize tab bars
    [[UITabBar appearance]setTintColor:[UIColor colorWithRed:13/255 green:82/255 blue:136/255 alpha:1.0]];
    
    [[UIBarButtonItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],UITextAttributeTextColor,[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, .1)],UITextAttributeTextShadowOffset,[UIFont fontWithName:@"Arial-Bold" size:0.0],UITextAttributeFont, nil] forState:UIControlStateNormal];
    
    //segment control
    [[UISegmentedControl appearance] setTintColor:[UIColor colorWithRed:13/255 green:82/255 blue:136/255 alpha:1.0]];
}

#pragma Facebook
//Facebook
- (BOOL)application:(UIApplication *)application 
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url]; 
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [FBSession.activeSession close];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

//- (void)applicationWillTerminate:(UIApplication *)application
//{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
//}

@end
