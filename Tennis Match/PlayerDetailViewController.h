//
//  PlayerDetailViewController.h
//  Tennis Match
//
//  Created by Robert Miller on 4/19/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

@interface PlayerDetailViewController : UIViewController

@property(nonatomic,retain) Player *detailPlayer;

@property(assign, nonatomic) NSInteger indexNumber;
@property(nonatomic,retain) UINavigationItem *navItem;
@property(nonatomic,retain) UINavigationBar *navBar;

-(void)savedPlayer;

@end
