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

@interface NewMatchView : UIView <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,retain) NSMutableArray *setsArray;
@property(nonatomic,retain) Team *teamOne;
@property(nonatomic,retain) Team *teamTwo;
@property(nonatomic,retain) Match *match;
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic) BOOL isDoubles;

@property(nonatomic,retain) id parentViewContoller;

-(void)addNewSet;

@end
