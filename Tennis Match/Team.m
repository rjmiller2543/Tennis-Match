//
//  Team.m
//  Tennis Match
//
//  Created by Robert Miller on 4/5/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "Team.h"

@implementation Team

-(id)initWithCoder:(NSCoder*)aDecoder {
    if (self = [super init]) {
        [self setDoubles:[[aDecoder decodeObjectForKey:@"doubles"] boolValue]];
        [self setPlayerOne:[aDecoder decodeObjectForKey:@"playerOne"]];
        [self setPlayerTwo:[aDecoder decodeObjectForKey:@"playerTwo"]];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder*)aCoder {
    [aCoder encodeObject:[NSNumber numberWithBool:_doubles] forKey:@"doubles"];
    [aCoder encodeObject:_playerOne forKey:@"playerOne"];
    [aCoder encodeObject:_playerTwo forKey:@"playerTwo"];
}

@end
