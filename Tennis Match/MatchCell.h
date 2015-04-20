//
//  MatchCell.h
//  Tennis Match
//
//  Created by Robert Miller on 4/3/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Match.h"

@interface MatchCell : UITableViewCell

@property(nonatomic,retain) Match *cellMatch;

-(void)configureCell;

@end
