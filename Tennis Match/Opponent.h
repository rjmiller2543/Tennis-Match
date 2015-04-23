//
//  Opponent.h
//  Tennis Match
//
//  Created by Robert Miller on 4/22/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"
#import "Player.h"
#import "Stats.h"

@interface Opponent : NSObject

@property (nonatomic, retain) Team * opposingTeam;
@property (nonatomic, retain) Team * myTeam;

@property(nonatomic,retain) Stats *opposingTeamStats;
@property(nonatomic,retain) Stats *myTeamStats;

@end
