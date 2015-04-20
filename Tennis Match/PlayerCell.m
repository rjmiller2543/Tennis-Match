//
//  PlayerCell.m
//  Tennis Match
//
//  Created by Robert Miller on 4/8/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "PlayerCell.h"
#import <FlatUIKit.h>
#import <PNChart/PNChart.h>

@implementation PlayerCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)configureCell {
    self.backgroundColor = [UIColor clearColor];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width - 25, 80)];
    containerView.backgroundColor = [UIColor asbestosColor];
    [self addSubview:containerView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 45, 45)];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 45/2;
    imageView.layer.borderWidth = 2;
    imageView.layer.borderColor = [[UIColor turquoiseColor] CGColor];
    imageView.image = [UIImage imageNamed:@"no-player-image.png"];
    if ([_cellPlayer playerImage]) {
        imageView.image = [UIImage imageWithData:[_cellPlayer playerImage]];
    }
    [containerView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, self.frame.size.width, 25)];
    label.text = [_cellPlayer playerName];
    label.font = [UIFont boldFlatFontOfSize:20.0f];
    label.textColor = [UIColor turquoiseColor];
    [label sizeToFit];
    [containerView addSubview:label];
    
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(self.frame.size.width - 80, 5, 70, 70) items:@[[PNPieChartDataItem dataItemWithValue:[[_cellPlayer playerMatchesWon] floatValue] color:[UIColor greenSeaColor] description:@"Wins"], [PNPieChartDataItem dataItemWithValue:([[_cellPlayer playerMatchesPlayed] floatValue] - [[_cellPlayer playerMatchesWon] floatValue]) color:[UIColor alizarinColor] description:@"Losses"]]];
    pieChart.descriptionTextColor = [UIColor cloudsColor];
    pieChart.descriptionTextFont = [UIFont boldFlatFontOfSize:12.0f];
    [pieChart strokeChart];
    [containerView addSubview:pieChart];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
