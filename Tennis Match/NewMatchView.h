//
//  NewMatchView.h
//  Tennis Match
//
//  Created by Robert Miller on 4/7/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"
#import "Set.h"
#import "Match.h"
#import "Stats.h"
#import "Opponent.h"

@interface NewMatchView : UIView <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,retain) NSMutableArray *setsArray;
@property(nonatomic,retain) Team *teamOne;
@property(nonatomic,retain) Team *teamTwo;
@property(nonatomic,retain) Match *match;
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic) BOOL isDoubles;
@property(nonatomic) BOOL isSuperset;
@property(nonatomic) int numberOfSupersetGames;

@property(nonatomic,retain) Stats *teamOnePlayerOneStats;
@property(nonatomic,retain) Stats *teamOnePlayerTwoStats;
@property(nonatomic,retain) Stats *teamTwoPlayerOneStats;
@property(nonatomic,retain) Stats *teamTwoPlayerTwoStats;

@property(nonatomic,retain) Stats *teamOneStats;
@property(nonatomic,retain) Stats *teamTwoStats;

@property(nonatomic,retain) id parentViewContoller;

-(void)addNewSet;
-(void)showSetsChoice;
-(void)doneShowingSetsChoice;

@end
