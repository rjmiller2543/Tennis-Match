//
//  Opponent.m
//  Tennis Match
//
//  Created by Robert Miller on 4/22/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "Opponent.h"

@implementation Opponent

-(id)initWithCoder:(NSCoder*)aDecoder {
    if (self = [super init]) {
        [self setOpposingTeam:[aDecoder decodeObjectForKey:@"opposingTeam"]];
        [self setMyTeam:[aDecoder decodeObjectForKey:@"myTeam"]];
        [self setOpposingTeamStats:[aDecoder decodeObjectForKey:@"opposingTeamStats"]];
        [self setMyTeamStats:[aDecoder decodeObjectForKey:@"myTeamStats"]];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder*)aCoder {
    [aCoder encodeObject:_opposingTeam forKey:@"opposingTeam"];
    [aCoder encodeObject:_myTeam forKey:@"myTeam"];
    [aCoder encodeObject:_opposingTeamStats forKey:@"opposingTeamStats"];
    [aCoder encodeObject:_myTeamStats forKey:@"myTeamStats"];
}

@end
