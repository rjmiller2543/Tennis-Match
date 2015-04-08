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
    }
    return self;
}

-(id)initWithCoder:(NSCoder*)aDecoder {
    if (self = [super init]) {
        [self setGames:[aDecoder decodeObjectForKey:@"games"]];
        [self setTeamOneScore:[aDecoder decodeObjectForKey:@"teamOneScore"]];
        [self setTeamTwoScore:[aDecoder decodeObjectForKey:@"teamTwoScore"]];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder*)aCoder {
    [aCoder encodeObject:_games forKey:@"games"];
    [aCoder encodeObject:_teamOneScore forKey:@"teamOneScore"];
    [aCoder encodeObject:_teamTwoScore forKey:@"teamTwoScore"];
}

-(BOOL)hasWinner {
    BOOL returnBool;
    if (([_teamOneScore intValue] == 6) && ([_teamTwoScore intValue] != 6)) {
        returnBool = true;
    }
    else if (([_teamTwoScore intValue] == 6) && ([_teamOneScore intValue] != 6)) {
        returnBool = true;
    }
    else {
        returnBool = false;
    }
    
    return returnBool;
}

@end
