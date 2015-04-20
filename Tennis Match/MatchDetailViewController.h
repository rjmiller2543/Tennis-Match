//
//  MatchDetailViewController.h
//  Tennis Match
//
//  Created by Robert Miller on 4/19/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Match.h"

@interface MatchDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,retain) Match *detailMatch;
@property(nonatomic,retain) UITableView *tableView;

@end
