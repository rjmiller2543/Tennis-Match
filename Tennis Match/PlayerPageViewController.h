//
//  PlayerPageViewController.h
//  Tennis Match
//
//  Created by Robert Miller on 5/4/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "Opponent.h"

@interface PlayerPageViewController : UIViewController

@property(nonatomic,retain) UIPageViewController *pageViewController;
@property(nonatomic,retain) Player *detailPlayer;

@end
