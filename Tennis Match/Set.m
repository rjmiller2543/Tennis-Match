//
//  Set.m
//  Tennis Match
//
//  Created by Robert Miller on 4/5/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "Set.h"

@implementation Set

-(instancetype)init {
    self = [super init];
    if (self) {
        //set up
        _games = [[NSMutableArray alloc] init];
        _teamOneScore = [[NSNumber alloc] initWithInt:0];
        _teamTwoScore = [[NSNumber alloc] initWithInt:0];
        _setHasTieBreak = false;
        _tieBreakScore = [[NSNumber alloc] initWithInt:0];
    }
    return self;
}

-(id)initWithCoder:(NSCoder*)aDecoder {
    if (self = [super init]) {
        [self setGames:[aDecoder decodeObjectForKey:@"games"]];
        [self setTeamOneScore:[aDecoder decodeObjectForKey:@"teamOneScore"]];
        [self setTeamTwoScore:[aDecoder decodeObjectForKey:@"teamTwoScore"]];
        [self setTieBreakScore:[aDecoder decodeObjectForKey:@"tieBreakScore"]];
        [self setSetHasTieBreak:[[aDecoder decodeObjectForKey:@"hasTieBreak"] boolValue]];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder*)aCoder {
    [aCoder encodeObject:_games forKey:@"games"];
    [aCoder encodeObject:_teamOneScore forKey:@"teamOneScore"];
    [aCoder encodeObject:_teamTwoScore forKey:@"teamTwoScore"];
    [aCoder encodeObject:_tieBreakScore forKey:@"tieBreakScore"];
    [aCoder encodeObject:[NSNumber numberWithBool:_setHasTieBreak] forKey:@"hasTieBreak"];
}

-(BOOL)setHasTieBreak {
    return _setHasTieBreak;
}

-(BOOL)hasTieBreak {
    BOOL tieBreak = false;
    
    if (([_teamOneScore intValue] == 6) && ([_teamTwoScore intValue] == 6)) {
        tieBreak = true;
        _setHasTieBreak = true;
    }
    
    return tieBreak;
}

-(int)hasWinner {
    int winner;
    if (([_teamOneScore intValue] == 6) && (([_teamTwoScore intValue] != 5) && ([_teamTwoScore intValue] != 6) && ([_teamTwoScore intValue] != 7))) {
        winner = 1;
    }
    else if ([_teamOneScore intValue] == 7) {
        if ([_teamTwoScore intValue] == 5) {
            winner = 1;
        }
        else if ([_teamTwoScore intValue] == 6) {
            winner = 1;
        }
        else {
            winner = 3;
        }
    }
    else if (([_teamTwoScore intValue] == 6) && (([_teamOneScore intValue] != 5) && ([_teamOneScore intValue] != 6) && ([_teamOneScore intValue] != 7))) {
        winner = 2;
    }
    else if ([_teamTwoScore intValue] == 7) {
        if ([_teamOneScore intValue] == 5) {
            winner = 2;
        }
        else if ([_teamOneScore intValue] == 6) {
            winner = 2;
        }
        else {
            winner = 3;
        }
    }
    else {
        winner = 0;
    }
    
    return winner;
}

@end
