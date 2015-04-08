//
//  Game.m
//  Tennis Match
//
//  Created by Robert Miller on 4/5/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "Game.h"

@implementation Game

-(instancetype)init {
    self = [super init];
    if (self) {
        _teamOneScore = [NSNumber numberWithInt:0];
        _teamTwoScore = [NSNumber numberWithInt:0];
    }
    return self;
}

-(id)initWithCoder:(NSCoder*)aDecoder {
    if (self = [super init]) {
        [self setTeamOneScore:[aDecoder decodeObjectForKey:@"teamOneScore"]];
        [self setTeamTwoScore:[aDecoder decodeObjectForKey:@"teamTwoScore"]];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder*)aCoder {
    [aCoder encodeObject:_teamOneScore forKey:@"teamOneScore"];
    [aCoder encodeObject:_teamTwoScore forKey:@"teamTwoScore"];
}

-(int)gameWinner {
    int winner = 0;
    if ([_teamOneScore intValue] > [_teamTwoScore intValue]) {
        winner = 1;
    }
    else if ([_teamTwoScore intValue] > [_teamOneScore intValue]) {
        winner = 2;
    }
    return winner;
}

@end
