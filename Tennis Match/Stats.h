//
//  Stats.h
//  Tennis Match
//
//  Created by Robert Miller on 4/22/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stats : NSObject

@property (nonatomic, retain) NSNumber * playerGamesPlayed;
@property (nonatomic, retain) NSNumber * playerGamesWon;
@property (nonatomic, retain) NSNumber * playerMatchesPlayed;
@property (nonatomic, retain) NSNumber * playerMatchesWon;
@property (nonatomic, retain) NSNumber * playerSetsPlayed;
@property (nonatomic, retain) NSNumber * playerSetsWon;
@property (nonatomic, retain) NSNumber * aces;
@property (nonatomic, retain) NSNumber * doubleFaults;
@property (nonatomic, retain) NSNumber * faults;
@property (nonatomic, retain) NSNumber * firstServesWon;
@property (nonatomic, retain) NSNumber * secondServesWon;
@property (nonatomic, retain) NSNumber * servesMade;

@property (nonatomic, retain) NSNumber * acesTwo;
@property (nonatomic, retain) NSNumber * doubleFaultsTwo;
@property (nonatomic, retain) NSNumber * faultsTwo;
@property (nonatomic, retain) NSNumber * firstServesWonTwo;
@property (nonatomic, retain) NSNumber * secondServesWonTwo;
@property (nonatomic, retain) NSNumber * servesMadeTwo;

@end
