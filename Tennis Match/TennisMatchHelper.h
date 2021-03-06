//
//  TennisMatchHelper.h
//  Tennis Match
//
//  Created by Robert Miller on 4/3/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "Player.h"
#import "TeamPlayer.h"
#import "Game.h"
#import "Set.h"
#import "Team.h"
#import "Match.h"
//#import <FlatUIKit/FlatUIKit.h>

#ifndef Tennis_Match_TennisMatchHelper_h
#define Tennis_Match_TennisMatchHelper_h

#define PLAYERSOURCE    @"Player"
#define MATCHSOURCE     @"Match"

#define TENNISBALLCOLOR [UIColor colorWithRed:0xad/0xff green:0xff/0xff blue:0x2f/0xff alpha:1.0]

#define kUpdateScore    @"updateScore"

#define kPlayerOneUp    @"playerOneUp"
#define kPlayerOneDn    @"playerOneDown"
#define kPlayerTwoUp    @"playerTwoUp"
#define kPlayerTwoDn    @"playerTwoDown"

#define kTeamOneName    @"TeamOneName"
#define kTeamTwoName    @"TeamTwoName"

#define kTeamOneScore   @"TeamOneScore"
#define kTeamTwoScore   @"TeamTwoScore"

#define kTeamOneSets    @"TeamOneSets"
#define kTeamTwoSets    @"TeamTwoSets"

#define kServingPlayer  @"ServingPlayer"

#endif
