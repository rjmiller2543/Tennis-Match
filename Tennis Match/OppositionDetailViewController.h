//
//  OppositionDetailViewController.h
//  Tennis Match
//
//  Created by Robert Miller on 5/4/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Opponent.h"
#import "Player.h"

@interface OppositionDetailViewController : UIViewController

@property(nonatomic,retain) Opponent *detailOpponent;

@property(assign, nonatomic) NSInteger indexNumber;
@property(nonatomic,retain) UINavigationItem *navItem;
@property(nonatomic,retain) UINavigationBar *navBar;

@end
