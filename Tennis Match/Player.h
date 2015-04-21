//
//  Player.h
//  Tennis Match
//
//  Created by Robert Miller on 4/19/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Player : NSManagedObject

@property (nonatomic, retain) NSData * playerImage;
@property (nonatomic, retain) NSString * playerName;
@property (nonatomic, retain) NSString * playerLastName;
@property (nonatomic, retain) NSNumber * playerGamesPlayed;
@property (nonatomic, retain) NSNumber * playerGamesWon;
@property (nonatomic, retain) NSDate * timeStamp;
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

@end
