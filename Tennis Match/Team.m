//
//  Team.m
//  Tennis Match
//
//  Created by Robert Miller on 4/5/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "Team.h"
#import "AppDelegate.h"

@implementation Team

-(void)setTeams {
    _playerOne = [self playerOneFromTeam];
    _playerTwo = [self playerTwoFromTeam];
}

-(void)setTeamPlayerOneFromPlayer:(Player*)player {
    [_teamPlayerOne setName:[player playerName]];
    [_teamPlayerOne setTimeStamp:[player timeStamp]];
}

-(void)setTeamPlayerTwoFromPlayer:(Player*)player {
    [_teamPlayerTwo setName:[player playerName]];
    [_teamPlayerTwo setTimeStamp:[player timeStamp]];
}

-(Player*)playerOneFromTeam {
    if (_playerOne) {
        return _playerOne;
    }
    
    NSManagedObjectContext *context = [[AppDelegate sharedInstance] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(playerName = %@) AND (timeStamp = %@)", [_teamPlayerOne name], [_teamPlayerOne timeStamp]];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    
    return (Player*)[[context executeFetchRequest:fetchRequest error:&error] firstObject];
}

-(Player*)playerTwoFromTeam {
    if (_playerTwo) {
        return _playerTwo;
    }
    
    NSManagedObjectContext *context = [[AppDelegate sharedInstance] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(playerName = %@) AND (timeStamp = %@)", [_teamPlayerTwo name], [_teamPlayerTwo timeStamp]];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    
    return (Player*)[[context executeFetchRequest:fetchRequest error:&error] firstObject];
}

-(void)setPlayerOne:(Player *)playerOne {
    _playerOne = playerOne;
    _teamPlayerOne = [TeamPlayer new];
    [_teamPlayerOne setName:[playerOne playerName]];
    [_teamPlayerOne setTimeStamp:[playerOne timeStamp]];
}

-(void)setPlayerTwo:(Player *)playerTwo {
    _playerTwo = playerTwo;
    _teamPlayerTwo = [TeamPlayer new];
    [_teamPlayerTwo setName:[playerTwo playerName]];
    [_teamPlayerTwo setTimeStamp:[playerTwo timeStamp]];
}

-(id)initWithCoder:(NSCoder*)aDecoder {
    if (self = [super init]) {
        [self setDoubles:[[aDecoder decodeObjectForKey:@"doubles"] boolValue]];
        [self setTeamPlayerOne:[aDecoder decodeObjectForKey:@"playerOne"]];
        [self setTeamPlayerTwo:[aDecoder decodeObjectForKey:@"playerTwo"]];
        
        //_playerOne = [self playerOneFromTeam];
        //_playerTwo = [self playerTwoFromTeam];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder*)aCoder {
    [aCoder encodeObject:[NSNumber numberWithBool:_doubles] forKey:@"doubles"];
    [aCoder encodeObject:_teamPlayerOne forKey:@"playerOne"];
    [aCoder encodeObject:_teamPlayerTwo forKey:@"playerTwo"];
}

@end
