//
//  AppDelegate.h
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/23/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,assign) int quoteID;
-(void) customizeAppearance ;
-(void) addQuotes ;
@end
