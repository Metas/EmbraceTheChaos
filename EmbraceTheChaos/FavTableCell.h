//
//  FavTableCell.h
//  EmbraceTheChaos
//
//  Created by ShrutiG on 8/9/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Img01;
@property (weak, nonatomic) IBOutlet UIImageView *Img02;
@property (weak, nonatomic) IBOutlet UIButton *Delete1Img;
@property (weak, nonatomic) IBOutlet UIButton *Detail1Img;

@property (weak, nonatomic) IBOutlet UIButton *Delete2Img;
@property (weak, nonatomic) IBOutlet UIButton *Detail2Img;

@end
