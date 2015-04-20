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

-(void)savedPlayer;

@end
