//
//  Stats.m
//  Tennis Match
//
//  Created by Robert Miller on 4/22/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "Stats.h"

@implementation Stats

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setPlayerGamesPlayed:[NSNumber numberWithInt:0]];
        [self setPlayerGamesWon:[NSNumber numberWithInt:0]];
        [self setPlayerMatchesPlayed:[NSNumber numberWithInt:0]];
        [self setPlayerMatchesWon:[NSNumber numberWithInt:0]];
        [self setPlayerSetsPlayed:[NSNumber numberWithInt:0]];
        [self setPlayerSetsWon:[NSNumber numberWithInt:0]];
        [self setAces:[NSNumber numberWithInt:0]];
        [self setDoubleFaults:[NSNumber numberWithInt:0]];
        [self setFaults:[NSNumber numberWithInt:0]];
        [self setFirstServesWon:[NSNumber numberWithInt:0]];
        [self setSecondServesWon:[NSNumber numberWithInt:0]];
        [self setServesMade:[NSNumber numberWithInt:0]];
    }
    return self;
}

-(id)initWithCoder:(NSCoder*)aDecoder {
    if (self = [super init]) {
        [self setPlayerGamesPlayed:[aDecoder decodeObjectForKey:@"gamesPlayed"]];
        [self setPlayerGamesWon:[aDecoder decodeObjectForKey:@"gamesWon"]];
        [self setPlayerMatchesPlayed:[aDecoder decodeObjectForKey:@"matchesPlayed"]];
        [self setPlayerMatchesWon:[aDecoder decodeObjectForKey:@"matchesWon"]];
        [self setPlayerSetsPlayed:[aDecoder decodeObjectForKey:@"setsPlayed"]];
        [self setPlayerSetsWon:[aDecoder decodeObjectForKey:@"setsWon"]];
        [self setAces:[aDecoder decodeObjectForKey:@"aces"]];
        [self setDoubleFaults:[aDecoder decodeObjectForKey:@"doubleFaults"]];
        [self setFaults:[aDecoder decodeObjectForKey:@"faults"]];
        [self setFirstServesWon:[aDecoder decodeObjectForKey:@"firstServesWon"]];
        [self setSecondServesWon:[aDecoder decodeObjectForKey:@"secondServesWon"]];
        [self setServesMade:[aDecoder decodeObjectForKey:@"servesMade"]];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder*)aCoder {
    [aCoder encodeObject:_playerGamesPlayed forKey:@"gamesPlayed"];
    [aCoder encodeObject:_playerGamesWon forKey:@"gamesWon"];
    [aCoder encodeObject:_playerMatchesPlayed forKey:@"matchesPlayed"];
    [aCoder encodeObject:_playerMatchesWon forKey:@"matchesWon"];
    [aCoder encodeObject:_playerSetsPlayed forKey:@"setsPlayed"];
    [aCoder encodeObject:_playerSetsWon forKey:@"setsWon"];
    [aCoder encodeObject:_aces forKey:@"aces"];
    [aCoder encodeObject:_doubleFaults forKey:@"doubleFaults"];
    [aCoder encodeObject:_faults forKey:@"faults"];
    [aCoder encodeObject:_firstServesWon forKey:@"firstServesWon"];
    [aCoder encodeObject:_secondServesWon forKey:@"secondServesWon"];
    [aCoder encodeObject:_servesMade forKey:@"servesMade"];
}

@end
