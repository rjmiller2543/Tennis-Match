//
//  SetTypeViewController.h
//  Tennis Match
//
//  Created by Robert Miller on 5/2/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewMatchView.h"

@interface SetTypeViewController : UIViewController

@property(nonatomic) int numberOfSupersetGames;
@property(nonatomic,retain) NewMatchView *matchViewParentView;

-(void)configureView;

@end
