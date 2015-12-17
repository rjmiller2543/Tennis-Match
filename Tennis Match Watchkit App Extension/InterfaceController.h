//
//  InterfaceController.h
//  Tennis Match Watchkit App Extension
//
//  Created by Robert Miller on 12/15/15.
//  Copyright © 2015 Robert Miller. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "Match.h"

@interface InterfaceController : WKInterfaceController

@property(nonatomic,retain) IBOutlet WKInterfaceLabel *playerOneLabel;
@property(nonatomic,retain) IBOutlet WKInterfaceLabel *playerOneSets;
@property(nonatomic,retain) IBOutlet WKInterfaceLabel *playerOneScore;
@property(nonatomic,retain) IBOutlet WKInterfaceLabel *playerTwoLabel;
@property(nonatomic,retain) IBOutlet WKInterfaceLabel *playerTwoSets;
@property(nonatomic,retain) IBOutlet WKInterfaceLabel *playerTwoScore;

@property(nonatomic,retain) Match *match;

-(IBAction)menuOnePressed:(id)sender;
-(IBAction)menuTwoPressed:(id)sender;
-(IBAction)menuThreePressed:(id)sender;
-(IBAction)menuFourPressed:(id)sender;

@end
