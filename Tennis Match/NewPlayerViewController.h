//
//  NewPlayerViewController.h
//  Tennis Match
//
//  Created by Robert Miller on 4/19/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"
#import "Player.h"

@interface NewPlayerViewController : UIViewController

@property(nonatomic) id thisParentViewController;
@property(nonatomic,retain) Player *editPlayer;

@end
