//
//  WebsiteViewController.h
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/26/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebsiteViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *viewWebsite;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnBck;
- (IBAction)btnBckClick:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationItem *nav;

@end
