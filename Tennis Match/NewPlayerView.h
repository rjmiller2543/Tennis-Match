//
//  NewPlayerView.h
//  Tennis Match
//
//  Created by Robert Miller on 4/5/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "FXBlurView.h"
#import <CoreData/CoreData.h>
#import "Player.h"
#import <FlatUIKit/FlatUIKit.h>

@class NewPlayerView;
@protocol NewPlayerViewDelegate <NSObject>
-(void)pickedPlayer:(Player*)player;
@end

@interface NewPlayerView : FXBlurView <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate>

@property(nonatomic,retain) UICollectionView *collectionView;
@property(nonatomic,retain) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic,weak) id <NewPlayerViewDelegate> delegate;

@property(nonatomic) id parentViewController;

@end
