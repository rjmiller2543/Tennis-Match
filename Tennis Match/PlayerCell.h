//
//  PlayerCell.h
//  Tennis Match
//
//  Created by Robert Miller on 4/8/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

@interface PlayerCell : UITableViewCell

@property(nonatomic,retain) Player *cellPlayer;

-(void)configureCell;

@end
