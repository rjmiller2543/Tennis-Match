//
//  Team.h
//  Tennis Match
//
//  Created by Robert Miller on 4/5/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeamPlayer.h"
#import "Player.h"

@interface Team : NSObject

@property(nonatomic) BOOL doubles;
@property(nonatomic,retain) NSNumber *score;
@property(nonatomic,retain) TeamPlayer *teamPlayerOne;
@property(nonatomic,retain) TeamPlayer *teamPlayerTwo;
@property(nonatomic,retain) Player *playerOne;
@property(nonatomic,retain) Player *playerTwo;

-(Player*)playerOneFromTeam;
-(Player*)playerTwoFromTeam;
-(void)setTeams;

@end
