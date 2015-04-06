//
//  Player.h
//  Tennis Match
//
//  Created by Robert Miller on 4/3/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Player : NSManagedObject

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * playerName;
@property (nonatomic, retain) NSNumber * playerWins;
@property (nonatomic, retain) NSNumber * playerGames;

@end
