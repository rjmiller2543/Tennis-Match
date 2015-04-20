//
//  MatchCell.m
//  Tennis Match
//
//  Created by Robert Miller on 4/3/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "MatchCell.h"
#import "Team.h"
#import <FlatUIKit/FlatUIKit.h>
#import "Set.h"

@implementation MatchCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)configureCell {
    
    self.backgroundColor = [UIColor clearColor];
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width - 10, 130)];
    containerView.backgroundColor = [UIColor cloudsColor];
    containerView.layer.cornerRadius = 10;
    [self addSubview:containerView];
    
    float SCORESIZE = 58;
    float secondTeamPixelStart = 63;
    float firstTeamPixelStart = 5;
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        SCORESIZE = 48;
        secondTeamPixelStart = 63;
        firstTeamPixelStart = 17;
    }
    
    Team *teamOne = [_cellMatch teamOne];
    Team *teamTwo = [_cellMatch teamTwo];
    
    [teamOne setTeams];
    [teamTwo setTeams];
    
    /* setup the first team */
    UIImageView *imageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(5, firstTeamPixelStart, 3*SCORESIZE/4, 3*SCORESIZE/4)];
    imageViewOne.contentMode = UIViewContentModeScaleAspectFit;
    imageViewOne.layer.cornerRadius = 3*SCORESIZE/8;
    imageViewOne.layer.borderColor = [[UIColor grayColor] CGColor];
    imageViewOne.layer.borderWidth = 2.0;
    imageViewOne.layer.masksToBounds = YES;
    imageViewOne.image = [UIImage imageNamed:@"no-player-image.png"];
    if ([[teamOne playerOne] playerImage]) {
        imageViewOne.image = [UIImage imageWithData:[[teamOne playerOne] playerImage]];
    }
    [containerView addSubview:imageViewOne];
    
    UILabel *teamOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(3*SCORESIZE/4 + 25, firstTeamPixelStart, [UIScreen mainScreen].bounds.size.width / 2 - 15 - SCORESIZE, SCORESIZE)];
    teamOneLabel.font = [UIFont boldFlatFontOfSize:20.0f];
    teamOneLabel.textAlignment = NSTextAlignmentRight;
    teamOneLabel.lineBreakMode = NSLineBreakByWordWrapping;
    teamOneLabel.numberOfLines = 0;
    teamOneLabel.text = [[teamOne playerOne] playerName];
    if ([[_cellMatch doubles] boolValue]) {
        UIImageView *imageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(SCORESIZE/2, firstTeamPixelStart + SCORESIZE/3, 3*SCORESIZE/4, 3*SCORESIZE/4)];
        imageViewTwo.contentMode = UIViewContentModeScaleAspectFit;
        imageViewTwo.layer.cornerRadius = (3*SCORESIZE/4)/2;
        imageViewTwo.layer.borderWidth = 2.0;
        imageViewTwo.layer.borderColor = [[UIColor grayColor] CGColor];
        imageViewTwo.layer.masksToBounds = YES;
        imageViewTwo.image = [UIImage imageNamed:@"no-player-image.png"];
        if ([[teamOne playerTwo] playerImage]) {
            imageViewTwo.image = [UIImage imageWithData:[[teamOne playerTwo] playerImage]];
        }
        [containerView addSubview:imageViewTwo];
        
        teamOneLabel.text = [teamOneLabel.text stringByAppendingString:@" & "];
        teamOneLabel.text = [teamOneLabel.text stringByAppendingString:[[teamOne playerTwo] playerName]];
    }
    [containerView addSubview:teamOneLabel];
    
    /* setup team two stuff */
    UIImageView *imageViewThree = [[UIImageView alloc] initWithFrame:CGRectMake(5, secondTeamPixelStart, 3*SCORESIZE/4, 3*SCORESIZE/4)];
    imageViewThree.contentMode = UIViewContentModeScaleAspectFit;
    imageViewThree.layer.cornerRadius = 3*SCORESIZE/8;
    imageViewThree.layer.borderColor = [[UIColor grayColor] CGColor];
    imageViewThree.layer.borderWidth = 2.0;
    imageViewThree.layer.masksToBounds = YES;
    imageViewThree.image = [UIImage imageNamed:@"no-player-image.png"];
    if ([[teamTwo playerOne] playerImage]) {
        imageViewThree.image = [UIImage imageWithData:[[teamTwo playerOne] playerImage]];
    }
    [containerView addSubview:imageViewThree];
    
    UILabel *teamTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(3*SCORESIZE/4 + 25, secondTeamPixelStart, [UIScreen mainScreen].bounds.size.width / 2 - 15  - SCORESIZE, SCORESIZE)];
    teamTwoLabel.font = [UIFont boldFlatFontOfSize:20.0f];
    teamTwoLabel.textAlignment = NSTextAlignmentRight;
    teamTwoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    teamTwoLabel.numberOfLines = 0;
    teamTwoLabel.text = [[teamTwo playerOne] playerName];
    if ([[_cellMatch doubles] boolValue]) {
        UIImageView *imageViewFour = [[UIImageView alloc] initWithFrame:CGRectMake(SCORESIZE/2, SCORESIZE/3 + secondTeamPixelStart, 3*SCORESIZE/4, 3*SCORESIZE/4)];
        imageViewFour.contentMode = UIViewContentModeScaleAspectFit;
        imageViewFour.layer.cornerRadius = 3*SCORESIZE/8;
        imageViewFour.layer.borderWidth = 2.0;
        imageViewFour.layer.borderColor = [[UIColor grayColor] CGColor];
        imageViewFour.layer.masksToBounds = YES;
        imageViewFour.image = [UIImage imageNamed:@"no-player-image.png"];
        if ([[teamTwo playerTwo] playerImage]) {
            imageViewFour.image = [UIImage imageWithData:[[teamTwo playerTwo] playerImage]];
        }
        [containerView addSubview:imageViewFour];
        
        teamTwoLabel.text = [teamTwoLabel.text stringByAppendingString:@" & "];
        teamTwoLabel.text = [teamTwoLabel.text stringByAppendingString:[[teamTwo playerTwo] playerName]];
    }
    [containerView addSubview:teamTwoLabel];
    
    NSArray *setsArray = [_cellMatch sets];
    for (int i = 0; i < [setsArray count]; i++) {
        
        UITextField *textFieldOne = [[UITextField alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 + SCORESIZE*i, firstTeamPixelStart, SCORESIZE, SCORESIZE)];
        textFieldOne.enabled = NO;
        textFieldOne.borderStyle = UITextBorderStyleLine;
        textFieldOne.textAlignment = NSTextAlignmentCenter;
        textFieldOne.text = [[[setsArray objectAtIndex:i] teamOneScore] stringValue];
        [containerView addSubview:textFieldOne];
        
        UITextField *textFieldTwo = [[UITextField alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 + SCORESIZE*i, SCORESIZE + firstTeamPixelStart, SCORESIZE, SCORESIZE)];
        textFieldTwo.enabled = NO;
        textFieldTwo.borderStyle = UITextBorderStyleLine;
        textFieldTwo.textAlignment = NSTextAlignmentCenter;
        textFieldTwo.text = [[[setsArray objectAtIndex:i] teamTwoScore] stringValue];
        [containerView addSubview:textFieldTwo];
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
