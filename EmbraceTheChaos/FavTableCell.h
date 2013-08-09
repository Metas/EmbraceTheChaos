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
@property (weak, nonatomic) IBOutlet UIButton *Img1Del;
@property (weak, nonatomic) IBOutlet UIButton *Img2Del;
@property (weak, nonatomic) IBOutlet UIButton *Img1More;
@property (weak, nonatomic) IBOutlet UIButton *Img2More;
- (IBAction)Img1Delete:(id)sender;
- (IBAction)Img2Delete:(id)sender;

- (IBAction)Img1More:(id)sender;

- (IBAction)Img2More:(id)sender;

@end
