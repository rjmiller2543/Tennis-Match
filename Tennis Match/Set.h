//
//  Set.h
//  Tennis Match
//
//  Created by Robert Miller on 4/5/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"

@interface Set : NSObject

@property(nonatomic,retain) NSNumber *teamOneScore;
@property(nonatomic,retain) NSNumber *teamTwoScore;
@property(nonatomic,retain) NSMutableArray *games;
@property(nonatomic,retain) NSNumber *tieBreakScore;

@property(nonatomic) BOOL setHasTieBreak;
@property(nonatomic) BOOL isSuperset;

-(int)hasWinner;
-(BOOL)hasTieBreak;
-(BOOL)setHasTieBreakWinner;

@end
