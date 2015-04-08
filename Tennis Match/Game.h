//
//  Game.h
//  Tennis Match
//
//  Created by Robert Miller on 4/5/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Game : NSObject

@property(nonatomic,retain) NSNumber *teamOneScore;
@property(nonatomic,retain) NSNumber *teamTwoScore;

-(int)gameWinner;

@end
