//
//  FavTableCell.m
//  EmbraceTheChaos
//
//  Created by ShrutiG on 8/9/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import "FavTableCell.h"


@implementation FavTableCell

@synthesize Img01;
@synthesize Img02;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)Img1Delete:(id)sender {


}

- (IBAction)Img2Delete:(id)sender {
}

- (IBAction)Img1More:(id)sender {
}

- (IBAction)Img2More:(id)sender {
}
@end
