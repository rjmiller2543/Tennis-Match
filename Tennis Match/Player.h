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
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) id opponents;
@property (nonatomic, retain) id playerStats;

@end

@interface Opponents : NSValueTransformer

@end

@interface PlayerStats : NSValueTransformer

@end
