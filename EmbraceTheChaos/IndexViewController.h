//
//  IndexViewController.h
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/24/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlowCoverView.h"

@interface IndexViewController : UIViewController
@property (weak, nonatomic) IBOutlet FlowCoverView  *cover;
@property (weak, nonatomic) IBOutlet UILabel *lblTopic;


@end
