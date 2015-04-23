//
//  NewMatchViewController.m
//  Tennis Match
//
//  Created by Robert Miller on 4/3/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "NewMatchViewController.h"
#import <FXBlurView/FXBlurView.h>
#import "Match.h"
#import "NewPlayerView.h"
#import "Team.h"
#import <VBFPopFlatButton/VBFPopFlatButton.h>
#import "NewMatchView.h"
#import "AppDelegate.h"
#import "Opponent.h"
#import "Stats.h"

@interface NewMatchViewController () <NewPlayerViewDelegate>

@property(nonatomic,retain) NewPlayerView *playerList;
@property(nonatomic) int playerNumber;
@property(nonatomic) BOOL isSingles;
@property(nonatomic) int teamOneSet;
@property(nonatomic) int teamTwoSet;

@property(nonatomic,retain) UIImageView *tennisView;
@property(nonatomic,retain) NewMatchView *matchView;
@property(nonatomic,retain) FUIButton *playerOneButton;
@property(nonatomic,retain) FUIButton *playerTwoButton;
@property(nonatomic,retain) FUIButton *playerThreeButton;
@property(nonatomic,retain) FUIButton *playerFourButton;
@property(nonatomic,retain) VBFPopFlatButton *closeButton;
@property(nonatomic,retain) VBFPopFlatButton *matchViewButton;

@property(nonatomic,retain) Team *teamOne;
@property(nonatomic,retain) Team *teamTwo;

@end

@implementation NewMatchViewController

#define PLAYERONE   1
#define PLAYERTWO   2
#define PLAYERTHREE 3
#define PLAYERFOUR  4

#define PLAYERONEBUTTON     1
#define PLAYERTWOBUTTON     2
#define PLAYERTHREEBUTTON   3
#define PLAYERFOURBUTTON    4

#define PLAYERONESET    1
#define PLAYERTWOSET    2
#define PLAYERSSET      3

-(instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tennisView = [[UIImageView alloc] initWithFrame:self.view.frame];
    _tennisView.image = [UIImage imageNamed:@"tennis-court.png"];
    _tennisView.userInteractionEnabled = YES;
    [self.view addSubview:_tennisView];
    
    _isSingles = true;
    _teamOneSet = 0;
    _teamTwoSet = 0;
    
    [self configureSingles];
    
    FUIButton *doubleButton = [[FUIButton alloc] init];
    [doubleButton addTarget:self action:@selector(toggleDoubles:) forControlEvents:UIControlEventTouchUpInside];
    doubleButton.buttonColor = [UIColor asbestosColor];
    doubleButton.shadowColor = [UIColor tangerineColor];
    doubleButton.shadowHeight = 2.0f;
    doubleButton.cornerRadius = 6.0f;
    doubleButton.titleLabel.font = [UIFont boldFlatFontOfSize:22.0f];
    [doubleButton setTitle:@"Singles" forState:UIControlStateNormal];
    [doubleButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateNormal];
    [doubleButton sizeToFit];
    CGRect dBFrame = doubleButton.frame;
    dBFrame.size.width = dBFrame.size.width + 12;
    dBFrame.size.height = dBFrame.size.height + 12;
    [doubleButton setFrame:dBFrame];
    [doubleButton setCenter:self.view.center];
    [_tennisView addSubview:doubleButton];
    
    UILabel *serveLabel = [[UILabel alloc] init];
    serveLabel.text = @"First Serve";
    serveLabel.font = [UIFont flatFontOfSize:16.0f];
    serveLabel.tintColor = [UIColor turquoiseColor];
    [serveLabel sizeToFit];
    CGRect lFrame = serveLabel.frame;
    lFrame.size.width = lFrame.size.width + 12;
    lFrame.size.height = lFrame.size.height + 12;
    [serveLabel setFrame:lFrame];
    [serveLabel setCenter:CGPointMake(self.view.center.x, self.view.center.y - 36)];
    [_tennisView addSubview:serveLabel];
    
    _matchView = [[NewMatchView alloc] init];
    [_matchView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    //_matchView.backgroundColor = [UIColor cloudsColor];
    _matchView.parentViewContoller = self;
    [self.view addSubview:_matchView];
    
    _closeButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 3) - 15, self.view.frame.size.height - 60, 30, 30) buttonType:buttonCloseType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
    [_closeButton addTarget:self action:@selector(cancelView) forControlEvents:UIControlEventTouchUpInside];
    _closeButton.roundBackgroundColor = [UIColor asbestosColor];
    _closeButton.lineThickness = 2.0;
    _closeButton.tintColor = [UIColor turquoiseColor];
    [self.view addSubview:_closeButton];
    
    _matchViewButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake((2 * self.view.frame.size.width / 3) - 15, self.view.frame.size.height - 60, 30, 30) buttonType:buttonDownArrowType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
    //[_matchViewButton addTarget:self action:@selector(showMatchView) forControlEvents:UIControlEventTouchUpInside];
    _matchViewButton.roundBackgroundColor = [UIColor darkGrayColor];
    _matchViewButton.lineThickness = 2.0;
    _matchViewButton.tintColor = [UIColor lightGrayColor];
    [self.view addSubview:_matchViewButton];
    
}

-(void)cancelView {
    [self dismissViewControllerAnimated:YES completion:^{
        //up up
        if (_matchView.match) {
            [[[AppDelegate sharedInstance] managedObjectContext] deleteObject:_matchView.match];
        }
    }];
}

-(void)canSave {
    _matchViewButton.roundBackgroundColor = [UIColor asbestosColor];
    _matchViewButton.tintColor = [UIColor turquoiseColor];
    [_matchViewButton addTarget:self action:@selector(saveMatch) forControlEvents:UIControlEventTouchUpInside];
}

-(void)saveMatch {
    NSLog(@"save match");
    
    [_matchView.match setTimeStamp:[NSDate date]];
    [_matchView.match setDoubles:[NSNumber numberWithBool:!_isSingles]];
    [_matchView.match setSets:_matchView.setsArray];
    
    [[_teamOne playerOne] setPlayerStats:_matchView.teamOnePlayerOneStats];
    [[_teamTwo playerOne] setPlayerStats:_matchView.teamTwoPlayerOneStats];
    if (_matchView.isDoubles) {
        [[_teamOne playerTwo] setPlayerStats:_matchView.teamOnePlayerTwoStats];
        [[_teamTwo playerTwo] setPlayerStats:_matchView.teamTwoPlayerTwoStats];
    }
    
    NSArray *playerOneOpponents = [[_teamOne playerOne] opponents];
    Opponent *matchOpponent = nil;
    for (Opponent *tmp in playerOneOpponents) {
        if (_isSingles) {
            if ([[[[tmp opposingTeam] playerOne] playerName] isEqualToString:[[_teamTwo playerOne] playerName]]) {
                if ([[[[tmp opposingTeam] playerOne] timeStamp] isEqualToDate:[[_teamTwo playerOne] timeStamp]]) {
                    matchOpponent = tmp;
                }
            }
        }
        else {
            if ([[[[tmp opposingTeam] playerOne] playerName] isEqualToString:[[_teamTwo playerOne] playerName]]) {
                if ([[[[tmp opposingTeam] playerOne] timeStamp] isEqualToDate:[[_teamTwo playerOne] timeStamp]]) {
                    if ([[[[tmp opposingTeam] playerTwo] playerName] isEqualToString:[[_teamTwo playerTwo] playerName]]) {
                        if ([[[[tmp opposingTeam] playerTwo] timeStamp] isEqualToDate:[[_teamTwo playerTwo] timeStamp]]) {
                            matchOpponent = tmp;
                        }
                    }
                }
            }
        }
    }
    if (matchOpponent != nil) {
        Stats *oldStat = [matchOpponent opposingTeamStats];
        
        int oldMatches = [[oldStat playerMatchesPlayed] intValue];
        [oldStat setPlayerMatchesPlayed:[NSNumber numberWithInt:oldMatches+1]];
        int oldMatchesWon = [[oldStat playerMatchesWon] intValue];
        oldMatchesWon = oldMatchesWon + [[_matchView.teamTwoStats playerMatchesWon] intValue];
        [oldStat setPlayerMatchesPlayed:[NSNumber numberWithInt:oldMatchesWon]];
        
        int oldSets = [[oldStat playerSetsPlayed] intValue];
        [oldStat setPlayerSetsPlayed:[NSNumber numberWithInt:oldSets+[_matchView.teamTwoStats.playerSetsPlayed intValue]]];
        int oldSetsWon = [[oldStat playerSetsWon] intValue];
        [oldStat setPlayerSetsWon:[NSNumber numberWithInt:oldSetsWon+[_matchView.teamTwoStats.playerSetsWon intValue]]];
        
        int oldGames = [[oldStat playerGamesPlayed] intValue];
        [oldStat setPlayerGamesPlayed:[NSNumber numberWithInt:oldGames+[_matchView.teamTwoStats.playerGamesPlayed intValue]]];
        
        int oldAces = [[oldStat aces] intValue];
        [oldStat setAces:[NSNumber numberWithInt:oldAces+[_matchView.teamTwoStats.aces intValue]]];
        
        int oldFaults = [[oldStat faults] intValue];
        [oldStat setFaults:[NSNumber numberWithInt:oldFaults+[_matchView.teamTwoStats.faults intValue]]];
        
        int oldDoubleFaults = [[oldStat doubleFaults] intValue];
        [oldStat setDoubleFaults:[NSNumber numberWithInt:oldDoubleFaults+[_matchView.teamTwoStats.doubleFaults intValue]]];
        
        int oldFirstServesWon = [[oldStat firstServesWon] intValue];
        [oldStat setFirstServesWon:[NSNumber numberWithInt:oldFirstServesWon+[_matchView.teamTwoStats.firstServesWon intValue]]];
        
        int oldSecondServesWon = [[oldStat secondServesWon] intValue];
        [oldStat setSecondServesWon:[NSNumber numberWithInt:oldSecondServesWon+[_matchView.teamTwoStats.secondServesWon intValue]]];
        
        int oldServes = [[oldStat servesMade] intValue];
        [oldStat setServesMade:[NSNumber numberWithInt:oldServes+[_matchView.teamTwoStats.servesMade intValue]]];
        
        [matchOpponent setOpposingTeamStats:oldStat];
        
        Stats *myStats = [matchOpponent myTeamStats];
        
        int myMatches = [[myStats playerMatchesPlayed] intValue];
        [oldStat setPlayerMatchesPlayed:[NSNumber numberWithInt:myMatches+1]];
        int myMatchesWon = [[myStats playerMatchesWon] intValue];
        myMatchesWon = myMatchesWon + [[_matchView.teamOneStats playerMatchesWon] intValue];
        [myStats setPlayerMatchesPlayed:[NSNumber numberWithInt:myMatchesWon]];
        
        int mySets = [[myStats playerSetsPlayed] intValue];
        [myStats setPlayerSetsPlayed:[NSNumber numberWithInt:mySets+[_matchView.teamOneStats.playerSetsPlayed intValue]]];
        int mySetsWon = [[myStats playerSetsWon] intValue];
        [myStats setPlayerSetsWon:[NSNumber numberWithInt:mySetsWon+[_matchView.teamOneStats.playerSetsWon intValue]]];
        
        int myGames = [[myStats playerGamesPlayed] intValue];
        [myStats setPlayerGamesPlayed:[NSNumber numberWithInt:myGames+[_matchView.teamOneStats.playerGamesPlayed intValue]]];
        
        int myAces = [[myStats aces] intValue];
        [myStats setAces:[NSNumber numberWithInt:myAces+[_matchView.teamOneStats.aces intValue]]];
        
        int myFaults = [[myStats faults] intValue];
        [myStats setFaults:[NSNumber numberWithInt:myFaults+[_matchView.teamOneStats.faults intValue]]];
        
        int myDoubleFaults = [[myStats doubleFaults] intValue];
        [myStats setDoubleFaults:[NSNumber numberWithInt:myDoubleFaults+[_matchView.teamOneStats.doubleFaults intValue]]];
        
        int myFirstServesWon = [[myStats firstServesWon] intValue];
        [myStats setFirstServesWon:[NSNumber numberWithInt:myFirstServesWon+[_matchView.teamOneStats.firstServesWon intValue]]];
        
        int mySecondServesWon = [[myStats secondServesWon] intValue];
        [myStats setSecondServesWon:[NSNumber numberWithInt:mySecondServesWon+[_matchView.teamOneStats.secondServesWon intValue]]];
        
        int myServes = [[myStats servesMade] intValue];
        [myStats setServesMade:[NSNumber numberWithInt:myServes+[_matchView.teamOneStats.servesMade intValue]]];
        
        [matchOpponent setOpposingTeamStats:myStats];
    }
    else {
        [matchOpponent setOpposingTeam:_teamTwo];
        [matchOpponent setOpposingTeamStats:_matchView.teamTwoStats];
        [matchOpponent setMyTeam:_teamOne];
        [matchOpponent setMyTeamStats:_matchView.teamOneStats];
    }
    
    if (!_isSingles) {
        
        NSArray *playerTwoOpponents = [[_teamOne playerTwo] opponents];
        Opponent *matchOneTwoOpponent = nil;
        for (Opponent *tmp in playerTwoOpponents) {
            if (_isSingles) {
                if ([[[[tmp opposingTeam] playerOne] playerName] isEqualToString:[[_teamTwo playerOne] playerName]]) {
                    if ([[[[tmp opposingTeam] playerOne] timeStamp] isEqualToDate:[[_teamTwo playerOne] timeStamp]]) {
                        matchOneTwoOpponent = tmp;
                    }
                }
            }
            else {
                if ([[[[tmp opposingTeam] playerOne] playerName] isEqualToString:[[_teamTwo playerOne] playerName]]) {
                    if ([[[[tmp opposingTeam] playerOne] timeStamp] isEqualToDate:[[_teamTwo playerOne] timeStamp]]) {
                        if ([[[[tmp opposingTeam] playerTwo] playerName] isEqualToString:[[_teamTwo playerTwo] playerName]]) {
                            if ([[[[tmp opposingTeam] playerTwo] timeStamp] isEqualToDate:[[_teamTwo playerTwo] timeStamp]]) {
                                matchOneTwoOpponent = tmp;
                            }
                        }
                    }
                }
            }
        }
        if (matchOneTwoOpponent != nil) {
            Stats *oldStat = [matchOneTwoOpponent opposingTeamStats];
            
            int oldMatches = [[oldStat playerMatchesPlayed] intValue];
            [oldStat setPlayerMatchesPlayed:[NSNumber numberWithInt:oldMatches+1]];
            int oldMatchesWon = [[oldStat playerMatchesWon] intValue];
            oldMatchesWon = oldMatchesWon + [[_matchView.teamTwoStats playerMatchesWon] intValue];
            [oldStat setPlayerMatchesPlayed:[NSNumber numberWithInt:oldMatchesWon]];
            
            int oldSets = [[oldStat playerSetsPlayed] intValue];
            [oldStat setPlayerSetsPlayed:[NSNumber numberWithInt:oldSets+[_matchView.teamTwoStats.playerSetsPlayed intValue]]];
            int oldSetsWon = [[oldStat playerSetsWon] intValue];
            [oldStat setPlayerSetsWon:[NSNumber numberWithInt:oldSetsWon+[_matchView.teamTwoStats.playerSetsWon intValue]]];
            
            int oldGames = [[oldStat playerGamesPlayed] intValue];
            [oldStat setPlayerGamesPlayed:[NSNumber numberWithInt:oldGames+[_matchView.teamTwoStats.playerGamesPlayed intValue]]];
            
            int oldAces = [[oldStat aces] intValue];
            [oldStat setAces:[NSNumber numberWithInt:oldAces+[_matchView.teamTwoStats.aces intValue]]];
            
            int oldFaults = [[oldStat faults] intValue];
            [oldStat setFaults:[NSNumber numberWithInt:oldFaults+[_matchView.teamTwoStats.faults intValue]]];
            
            int oldDoubleFaults = [[oldStat doubleFaults] intValue];
            [oldStat setDoubleFaults:[NSNumber numberWithInt:oldDoubleFaults+[_matchView.teamTwoStats.doubleFaults intValue]]];
            
            int oldFirstServesWon = [[oldStat firstServesWon] intValue];
            [oldStat setFirstServesWon:[NSNumber numberWithInt:oldFirstServesWon+[_matchView.teamTwoStats.firstServesWon intValue]]];
            
            int oldSecondServesWon = [[oldStat secondServesWon] intValue];
            [oldStat setSecondServesWon:[NSNumber numberWithInt:oldSecondServesWon+[_matchView.teamTwoStats.secondServesWon intValue]]];
            
            int oldServes = [[oldStat servesMade] intValue];
            [oldStat setServesMade:[NSNumber numberWithInt:oldServes+[_matchView.teamTwoStats.servesMade intValue]]];
            
            [matchOneTwoOpponent setOpposingTeamStats:oldStat];
            
            Stats *myStats = [matchOpponent myTeamStats];
            
            int myMatches = [[myStats playerMatchesPlayed] intValue];
            [oldStat setPlayerMatchesPlayed:[NSNumber numberWithInt:myMatches+1]];
            int myMatchesWon = [[myStats playerMatchesWon] intValue];
            myMatchesWon = myMatchesWon + [[_matchView.teamOneStats playerMatchesWon] intValue];
            [myStats setPlayerMatchesPlayed:[NSNumber numberWithInt:myMatchesWon]];
            
            int mySets = [[myStats playerSetsPlayed] intValue];
            [myStats setPlayerSetsPlayed:[NSNumber numberWithInt:mySets+[_matchView.teamOneStats.playerSetsPlayed intValue]]];
            int mySetsWon = [[myStats playerSetsWon] intValue];
            [myStats setPlayerSetsWon:[NSNumber numberWithInt:mySetsWon+[_matchView.teamOneStats.playerSetsWon intValue]]];
            
            int myGames = [[myStats playerGamesPlayed] intValue];
            [myStats setPlayerGamesPlayed:[NSNumber numberWithInt:myGames+[_matchView.teamOneStats.playerGamesPlayed intValue]]];
            
            int myAces = [[myStats aces] intValue];
            [myStats setAces:[NSNumber numberWithInt:myAces+[_matchView.teamOneStats.aces intValue]]];
            
            int myFaults = [[myStats faults] intValue];
            [myStats setFaults:[NSNumber numberWithInt:myFaults+[_matchView.teamOneStats.faults intValue]]];
            
            int myDoubleFaults = [[myStats doubleFaults] intValue];
            [myStats setDoubleFaults:[NSNumber numberWithInt:myDoubleFaults+[_matchView.teamOneStats.doubleFaults intValue]]];
            
            int myFirstServesWon = [[myStats firstServesWon] intValue];
            [myStats setFirstServesWon:[NSNumber numberWithInt:myFirstServesWon+[_matchView.teamOneStats.firstServesWon intValue]]];
            
            int mySecondServesWon = [[myStats secondServesWon] intValue];
            [myStats setSecondServesWon:[NSNumber numberWithInt:mySecondServesWon+[_matchView.teamOneStats.secondServesWon intValue]]];
            
            int myServes = [[myStats servesMade] intValue];
            [myStats setServesMade:[NSNumber numberWithInt:myServes+[_matchView.teamOneStats.servesMade intValue]]];
            
            [matchOneTwoOpponent setOpposingTeamStats:myStats];
        }
        else {
            [matchOneTwoOpponent setOpposingTeam:_teamTwo];
            [matchOneTwoOpponent setOpposingTeamStats:_matchView.teamTwoStats];
            [matchOneTwoOpponent setMyTeam:_teamOne];
            [matchOneTwoOpponent setMyTeamStats:_matchView.teamOneStats];
        }
    }
    
    NSArray *playerTwoOpponents = [[_teamTwo playerOne] opponents];
    Opponent *matchTwoOpponent = nil;
    for (Opponent *tmp in playerTwoOpponents) {
        if (_isSingles) {
            if ([[[[tmp opposingTeam] playerOne] playerName] isEqualToString:[[_teamOne playerOne] playerName]]) {
                if ([[[[tmp opposingTeam] playerOne] timeStamp] isEqualToDate:[[_teamOne playerOne] timeStamp]]) {
                    matchTwoOpponent = tmp;
                }
            }
        }
        else {
            if ([[[[tmp opposingTeam] playerOne] playerName] isEqualToString:[[_teamOne playerOne] playerName]]) {
                if ([[[[tmp opposingTeam] playerOne] timeStamp] isEqualToDate:[[_teamOne playerOne] timeStamp]]) {
                    if ([[[[tmp opposingTeam] playerTwo] playerName] isEqualToString:[[_teamOne playerTwo] playerName]]) {
                        if ([[[[tmp opposingTeam] playerTwo] timeStamp] isEqualToDate:[[_teamOne playerTwo] timeStamp]]) {
                            matchTwoOpponent = tmp;
                        }
                    }
                }
            }
        }
    }
    if (matchTwoOpponent != nil) {
        Stats *oldStat = [matchTwoOpponent opposingTeamStats];
        
        int oldMatches = [[oldStat playerMatchesPlayed] intValue];
        [oldStat setPlayerMatchesPlayed:[NSNumber numberWithInt:oldMatches+1]];
        int oldMatchesWon = [[oldStat playerMatchesWon] intValue];
        oldMatchesWon = oldMatchesWon + [[_matchView.teamTwoStats playerMatchesWon] intValue];
        [oldStat setPlayerMatchesPlayed:[NSNumber numberWithInt:oldMatchesWon]];
        
        int oldSets = [[oldStat playerSetsPlayed] intValue];
        [oldStat setPlayerSetsPlayed:[NSNumber numberWithInt:oldSets+[_matchView.teamTwoStats.playerSetsPlayed intValue]]];
        int oldSetsWon = [[oldStat playerSetsWon] intValue];
        [oldStat setPlayerSetsWon:[NSNumber numberWithInt:oldSetsWon+[_matchView.teamTwoStats.playerSetsWon intValue]]];
        
        int oldGames = [[oldStat playerGamesPlayed] intValue];
        [oldStat setPlayerGamesPlayed:[NSNumber numberWithInt:oldGames+[_matchView.teamTwoStats.playerGamesPlayed intValue]]];
        
        int oldAces = [[oldStat aces] intValue];
        [oldStat setAces:[NSNumber numberWithInt:oldAces+[_matchView.teamTwoStats.aces intValue]]];
        
        int oldFaults = [[oldStat faults] intValue];
        [oldStat setFaults:[NSNumber numberWithInt:oldFaults+[_matchView.teamTwoStats.faults intValue]]];
        
        int oldDoubleFaults = [[oldStat doubleFaults] intValue];
        [oldStat setDoubleFaults:[NSNumber numberWithInt:oldDoubleFaults+[_matchView.teamTwoStats.doubleFaults intValue]]];
        
        int oldFirstServesWon = [[oldStat firstServesWon] intValue];
        [oldStat setFirstServesWon:[NSNumber numberWithInt:oldFirstServesWon+[_matchView.teamTwoStats.firstServesWon intValue]]];
        
        int oldSecondServesWon = [[oldStat secondServesWon] intValue];
        [oldStat setSecondServesWon:[NSNumber numberWithInt:oldSecondServesWon+[_matchView.teamTwoStats.secondServesWon intValue]]];
        
        int oldServes = [[oldStat servesMade] intValue];
        [oldStat setServesMade:[NSNumber numberWithInt:oldServes+[_matchView.teamTwoStats.servesMade intValue]]];
        
        [matchTwoOpponent setOpposingTeamStats:oldStat];
        
        Stats *myStats = [matchOpponent myTeamStats];
        
        int myMatches = [[myStats playerMatchesPlayed] intValue];
        [oldStat setPlayerMatchesPlayed:[NSNumber numberWithInt:myMatches+1]];
        int myMatchesWon = [[myStats playerMatchesWon] intValue];
        myMatchesWon = myMatchesWon + [[_matchView.teamOneStats playerMatchesWon] intValue];
        [myStats setPlayerMatchesPlayed:[NSNumber numberWithInt:myMatchesWon]];
        
        int mySets = [[myStats playerSetsPlayed] intValue];
        [myStats setPlayerSetsPlayed:[NSNumber numberWithInt:mySets+[_matchView.teamOneStats.playerSetsPlayed intValue]]];
        int mySetsWon = [[myStats playerSetsWon] intValue];
        [myStats setPlayerSetsWon:[NSNumber numberWithInt:mySetsWon+[_matchView.teamOneStats.playerSetsWon intValue]]];
        
        int myGames = [[myStats playerGamesPlayed] intValue];
        [myStats setPlayerGamesPlayed:[NSNumber numberWithInt:myGames+[_matchView.teamOneStats.playerGamesPlayed intValue]]];
        
        int myAces = [[myStats aces] intValue];
        [myStats setAces:[NSNumber numberWithInt:myAces+[_matchView.teamOneStats.aces intValue]]];
        
        int myFaults = [[myStats faults] intValue];
        [myStats setFaults:[NSNumber numberWithInt:myFaults+[_matchView.teamOneStats.faults intValue]]];
        
        int myDoubleFaults = [[myStats doubleFaults] intValue];
        [myStats setDoubleFaults:[NSNumber numberWithInt:myDoubleFaults+[_matchView.teamOneStats.doubleFaults intValue]]];
        
        int myFirstServesWon = [[myStats firstServesWon] intValue];
        [myStats setFirstServesWon:[NSNumber numberWithInt:myFirstServesWon+[_matchView.teamOneStats.firstServesWon intValue]]];
        
        int mySecondServesWon = [[myStats secondServesWon] intValue];
        [myStats setSecondServesWon:[NSNumber numberWithInt:mySecondServesWon+[_matchView.teamOneStats.secondServesWon intValue]]];
        
        int myServes = [[myStats servesMade] intValue];
        [myStats setServesMade:[NSNumber numberWithInt:myServes+[_matchView.teamOneStats.servesMade intValue]]];
        
        [matchTwoOpponent setOpposingTeamStats:myStats];
    }
    else {
        [matchTwoOpponent setOpposingTeam:_teamTwo];
        [matchTwoOpponent setOpposingTeamStats:_matchView.teamTwoStats];
        [matchTwoOpponent setMyTeam:_teamOne];
        [matchTwoOpponent setMyTeamStats:_matchView.teamOneStats];
    }
    
    if (!_isSingles) {
        
        NSArray *playerTwoOpponents = [[_teamTwo playerTwo] opponents];
        Opponent *matchTwoTwoOpponent = nil;
        for (Opponent *tmp in playerTwoOpponents) {
            if (_isSingles) {
                if ([[[[tmp opposingTeam] playerOne] playerName] isEqualToString:[[_teamOne playerOne] playerName]]) {
                    if ([[[[tmp opposingTeam] playerOne] timeStamp] isEqualToDate:[[_teamOne playerOne] timeStamp]]) {
                        matchTwoTwoOpponent = tmp;
                    }
                }
            }
            else {
                if ([[[[tmp opposingTeam] playerOne] playerName] isEqualToString:[[_teamOne playerOne] playerName]]) {
                    if ([[[[tmp opposingTeam] playerOne] timeStamp] isEqualToDate:[[_teamOne playerOne] timeStamp]]) {
                        if ([[[[tmp opposingTeam] playerTwo] playerName] isEqualToString:[[_teamOne playerTwo] playerName]]) {
                            if ([[[[tmp opposingTeam] playerTwo] timeStamp] isEqualToDate:[[_teamOne playerTwo] timeStamp]]) {
                                matchTwoTwoOpponent = tmp;
                            }
                        }
                    }
                }
            }
        }
        if (matchTwoTwoOpponent != nil) {
            Stats *oldStat = [matchTwoTwoOpponent opposingTeamStats];
            
            int oldMatches = [[oldStat playerMatchesPlayed] intValue];
            [oldStat setPlayerMatchesPlayed:[NSNumber numberWithInt:oldMatches+1]];
            int oldMatchesWon = [[oldStat playerMatchesWon] intValue];
            oldMatchesWon = oldMatchesWon + [[_matchView.teamTwoStats playerMatchesWon] intValue];
            [oldStat setPlayerMatchesPlayed:[NSNumber numberWithInt:oldMatchesWon]];
            
            int oldSets = [[oldStat playerSetsPlayed] intValue];
            [oldStat setPlayerSetsPlayed:[NSNumber numberWithInt:oldSets+[_matchView.teamTwoStats.playerSetsPlayed intValue]]];
            int oldSetsWon = [[oldStat playerSetsWon] intValue];
            [oldStat setPlayerSetsWon:[NSNumber numberWithInt:oldSetsWon+[_matchView.teamTwoStats.playerSetsWon intValue]]];
            
            int oldGames = [[oldStat playerGamesPlayed] intValue];
            [oldStat setPlayerGamesPlayed:[NSNumber numberWithInt:oldGames+[_matchView.teamTwoStats.playerGamesPlayed intValue]]];
            
            int oldAces = [[oldStat aces] intValue];
            [oldStat setAces:[NSNumber numberWithInt:oldAces+[_matchView.teamTwoStats.aces intValue]]];
            
            int oldFaults = [[oldStat faults] intValue];
            [oldStat setFaults:[NSNumber numberWithInt:oldFaults+[_matchView.teamTwoStats.faults intValue]]];
            
            int oldDoubleFaults = [[oldStat doubleFaults] intValue];
            [oldStat setDoubleFaults:[NSNumber numberWithInt:oldDoubleFaults+[_matchView.teamTwoStats.doubleFaults intValue]]];
            
            int oldFirstServesWon = [[oldStat firstServesWon] intValue];
            [oldStat setFirstServesWon:[NSNumber numberWithInt:oldFirstServesWon+[_matchView.teamTwoStats.firstServesWon intValue]]];
            
            int oldSecondServesWon = [[oldStat secondServesWon] intValue];
            [oldStat setSecondServesWon:[NSNumber numberWithInt:oldSecondServesWon+[_matchView.teamTwoStats.secondServesWon intValue]]];
            
            int oldServes = [[oldStat servesMade] intValue];
            [oldStat setServesMade:[NSNumber numberWithInt:oldServes+[_matchView.teamTwoStats.servesMade intValue]]];
            
            [matchTwoTwoOpponent setOpposingTeamStats:oldStat];
            
            Stats *myStats = [matchOpponent myTeamStats];
            
            int myMatches = [[myStats playerMatchesPlayed] intValue];
            [oldStat setPlayerMatchesPlayed:[NSNumber numberWithInt:myMatches+1]];
            int myMatchesWon = [[myStats playerMatchesWon] intValue];
            myMatchesWon = myMatchesWon + [[_matchView.teamOneStats playerMatchesWon] intValue];
            [myStats setPlayerMatchesPlayed:[NSNumber numberWithInt:myMatchesWon]];
            
            int mySets = [[myStats playerSetsPlayed] intValue];
            [myStats setPlayerSetsPlayed:[NSNumber numberWithInt:mySets+[_matchView.teamOneStats.playerSetsPlayed intValue]]];
            int mySetsWon = [[myStats playerSetsWon] intValue];
            [myStats setPlayerSetsWon:[NSNumber numberWithInt:mySetsWon+[_matchView.teamOneStats.playerSetsWon intValue]]];
            
            int myGames = [[myStats playerGamesPlayed] intValue];
            [myStats setPlayerGamesPlayed:[NSNumber numberWithInt:myGames+[_matchView.teamOneStats.playerGamesPlayed intValue]]];
            
            int myAces = [[myStats aces] intValue];
            [myStats setAces:[NSNumber numberWithInt:myAces+[_matchView.teamOneStats.aces intValue]]];
            
            int myFaults = [[myStats faults] intValue];
            [myStats setFaults:[NSNumber numberWithInt:myFaults+[_matchView.teamOneStats.faults intValue]]];
            
            int myDoubleFaults = [[myStats doubleFaults] intValue];
            [myStats setDoubleFaults:[NSNumber numberWithInt:myDoubleFaults+[_matchView.teamOneStats.doubleFaults intValue]]];
            
            int myFirstServesWon = [[myStats firstServesWon] intValue];
            [myStats setFirstServesWon:[NSNumber numberWithInt:myFirstServesWon+[_matchView.teamOneStats.firstServesWon intValue]]];
            
            int mySecondServesWon = [[myStats secondServesWon] intValue];
            [myStats setSecondServesWon:[NSNumber numberWithInt:mySecondServesWon+[_matchView.teamOneStats.secondServesWon intValue]]];
            
            int myServes = [[myStats servesMade] intValue];
            [myStats setServesMade:[NSNumber numberWithInt:myServes+[_matchView.teamOneStats.servesMade intValue]]];
            
            [matchTwoTwoOpponent setOpposingTeamStats:myStats];
        }
        else {
            [matchTwoTwoOpponent setOpposingTeam:_teamTwo];
            [matchTwoTwoOpponent setOpposingTeamStats:_matchView.teamTwoStats];
            [matchTwoTwoOpponent setMyTeam:_teamOne];
            [matchTwoTwoOpponent setMyTeamStats:_matchView.teamOneStats];
        }
    }
    
    [_matchView.match setTeamOneMatchStats:_matchView.teamOneStats];
    [_matchView.match setTeamTwoMatchStats:_matchView.teamTwoStats];
    
   // NSLog(@"team one: %@ team two: %@", [[[_matchView.match teamOne] playerOneFromTeam] playerName], [[[_matchView.match teamTwo] playerOneFromTeam] playerName]);
    
    NSError *error = nil;
    if ([[[AppDelegate sharedInstance] managedObjectContext] save:&error]) {
        NSLog(@"error saving match with error: %@", error);
    }
    
    [UIView animateWithDuration:0.8 animations:^{
        [_tennisView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [_matchView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        [_closeButton setFrame:CGRectMake((self.view.frame.size.width / 3) - 15, self.view.frame.size.height - 60, 30, 30)];
        [_matchViewButton setFrame:CGRectMake((2 * self.view.frame.size.width / 3) - 15, self.view.frame.size.height - 60, 30, 30)];
        [_matchViewButton animateToType:buttonOkType];
    } completion:^(BOOL finished) {
        //up up
        [self dismissViewControllerAnimated:YES completion:^{
            //up up
        }];
    }];
}

-(void)showMatchView {
    [_matchView setIsDoubles:!_isSingles];
    [_matchView setTeamOne:_teamOne];
    [_matchView setTeamTwo:_teamTwo];
    [_matchView addNewSet];
    
    [UIView animateWithDuration:0.8 animations:^{
        [_tennisView setFrame:CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        [_matchView setFrame:self.view.frame];
        [_closeButton setFrame:CGRectMake(self.view.frame.size.width /3 - 15, 30, 30, 30)];
        [_matchViewButton setFrame:CGRectMake(2 * self.view.frame.size.width / 3 - 15, 30, 30, 30)];
        _matchViewButton.roundBackgroundColor = [UIColor darkGrayColor];
        _matchViewButton.tintColor = [UIColor lightGrayColor];
        [_matchViewButton animateToType:buttonOkType];
    } completion:^(BOOL finished) {
        //up up
        NSLog(@"completed animations");
        [_matchViewButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
        
    }];
}

-(void)configureSingles {
    
    _playerOneButton = [[FUIButton alloc] init];
    [_playerOneButton addTarget:self action:@selector(addPlayerOne) forControlEvents:UIControlEventTouchUpInside];
    _playerOneButton.buttonColor = [UIColor nephritisColor];
    _playerOneButton.shadowColor = [UIColor turquoiseColor];
    _playerOneButton.shadowHeight = 3.0f;
    _playerOneButton.cornerRadius = 6.0f;
    _playerOneButton.titleLabel.font = [UIFont boldFlatFontOfSize:22.0f];
    [_playerOneButton setTitle:@"Add Player One" forState:UIControlStateNormal];
    [_playerOneButton setTitleColor:[UIColor midnightBlueColor] forState:UIControlStateNormal];
    [_playerOneButton sizeToFit];
    CGRect oneFrame = _playerOneButton.frame;
    oneFrame.size.width = oneFrame.size.width + 12;
    oneFrame.size.height = oneFrame.size.height + 12;
    [_playerOneButton setFrame:oneFrame];
    [_playerOneButton setCenter:CGPointMake(self.view.frame.size.width / 2, 120)];
    _playerOneButton.tag = PLAYERONEBUTTON;
    //[self.view addSubview:_playerOneButton];
    [_tennisView addSubview:_playerOneButton];
    
    _playerTwoButton = [[FUIButton alloc] init];
    [_playerTwoButton addTarget:self action:@selector(addPlayerTwo) forControlEvents:UIControlEventTouchUpInside];
    _playerTwoButton.buttonColor = [UIColor nephritisColor];
    _playerTwoButton.shadowColor = [UIColor turquoiseColor];
    _playerTwoButton.shadowHeight = 3.0f;
    _playerTwoButton.cornerRadius = 6.0f;
    _playerTwoButton.titleLabel.font = [UIFont boldFlatFontOfSize:22.0f];
    [_playerTwoButton setTitle:@"Add Player Two" forState:UIControlStateNormal];
    [_playerTwoButton setTitleColor:[UIColor midnightBlueColor] forState:UIControlStateNormal];
    [_playerTwoButton sizeToFit];
    CGRect twoFrame = _playerTwoButton.frame;
    twoFrame.size.width = twoFrame.size.width + 12;
    twoFrame.size.height = twoFrame.size.height + 12;
    [_playerTwoButton setFrame:twoFrame];
    [_playerTwoButton setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 120)];
    _playerTwoButton.tag = PLAYERTWOBUTTON;
    //[self.view addSubview:_playerTwoButton];
    [_tennisView addSubview:_playerTwoButton];
    
}

-(void)configureDoubles {
    
    _playerOneButton = [[FUIButton alloc] init];
    [_playerOneButton addTarget:self action:@selector(addPlayerOne) forControlEvents:UIControlEventTouchUpInside];
    _playerOneButton.buttonColor = [UIColor nephritisColor];
    _playerOneButton.shadowColor = [UIColor turquoiseColor];
    _playerOneButton.shadowHeight = 3.0f;
    _playerOneButton.cornerRadius = 6.0f;
    _playerOneButton.titleLabel.font = [UIFont boldFlatFontOfSize:22.0f];
    [_playerOneButton setTitle:@"Add Player One" forState:UIControlStateNormal];
    [_playerOneButton setTitleColor:[UIColor midnightBlueColor] forState:UIControlStateNormal];
    [_playerOneButton sizeToFit];
    CGRect oneFrame = _playerOneButton.frame;
    oneFrame.size.width = oneFrame.size.width + 12;
    oneFrame.size.height = oneFrame.size.height + 12;
    [_playerOneButton setFrame:oneFrame];
    [_playerOneButton setCenter:CGPointMake(self.view.frame.size.width / 2, 120)];
    _playerOneButton.tag = PLAYERONEBUTTON;
    //[self.view addSubview:_playerOneButton];
    [_tennisView addSubview:_playerOneButton];
    
    _playerTwoButton = [[FUIButton alloc] init];
    [_playerTwoButton addTarget:self action:@selector(addPlayerTwo) forControlEvents:UIControlEventTouchUpInside];
    _playerTwoButton.buttonColor = [UIColor nephritisColor];
    _playerTwoButton.shadowColor = [UIColor turquoiseColor];
    _playerTwoButton.shadowHeight = 3.0f;
    _playerTwoButton.cornerRadius = 6.0f;
    _playerTwoButton.titleLabel.font = [UIFont boldFlatFontOfSize:22.0f];
    [_playerTwoButton setTitle:@"Add Player Two" forState:UIControlStateNormal];
    [_playerTwoButton setTitleColor:[UIColor midnightBlueColor] forState:UIControlStateNormal];
    [_playerTwoButton sizeToFit];
    CGRect twoFrame = _playerTwoButton.frame;
    twoFrame.size.width = twoFrame.size.width + 12;
    twoFrame.size.height = twoFrame.size.height + 12;
    [_playerTwoButton setFrame:twoFrame];
    [_playerTwoButton setCenter:CGPointMake(self.view.frame.size.width / 2, 160)];
    _playerTwoButton.tag = PLAYERTWOBUTTON;
    //[self.view addSubview:_playerTwoButton];
    [_tennisView addSubview:_playerTwoButton];
    
    _playerThreeButton = [[FUIButton alloc] init];
    [_playerThreeButton addTarget:self action:@selector(addPlayerThree) forControlEvents:UIControlEventTouchUpInside];
    _playerThreeButton.buttonColor = [UIColor nephritisColor];
    _playerThreeButton.shadowColor = [UIColor turquoiseColor];
    _playerThreeButton.shadowHeight = 3.0f;
    _playerThreeButton.cornerRadius = 6.0f;
    _playerThreeButton.titleLabel.font = [UIFont boldFlatFontOfSize:22.0f];
    [_playerThreeButton setTitle:@"Add Player Three" forState:UIControlStateNormal];
    [_playerThreeButton setTitleColor:[UIColor midnightBlueColor] forState:UIControlStateNormal];
    [_playerThreeButton sizeToFit];
    CGRect threeFrame = _playerThreeButton.frame;
    threeFrame.size.width = threeFrame.size.width + 12;
    threeFrame.size.height = threeFrame.size.height + 12;
    [_playerThreeButton setFrame:threeFrame];
    [_playerThreeButton setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 120)];
    _playerThreeButton.tag = PLAYERTHREEBUTTON;
    //[self.view addSubview:_playerThreeButton];
    [_tennisView addSubview:_playerThreeButton];
    
    _playerFourButton = [[FUIButton alloc] init];
    [_playerFourButton addTarget:self action:@selector(addPlayerFour) forControlEvents:UIControlEventTouchUpInside];
    _playerFourButton.buttonColor = [UIColor nephritisColor];
    _playerFourButton.shadowColor = [UIColor turquoiseColor];
    _playerFourButton.shadowHeight = 3.0f;
    _playerFourButton.cornerRadius = 6.0f;
    _playerFourButton.titleLabel.font = [UIFont boldFlatFontOfSize:22.0f];
    [_playerFourButton setTitle:@"Add Player Four" forState:UIControlStateNormal];
    [_playerFourButton setTitleColor:[UIColor midnightBlueColor] forState:UIControlStateNormal];
    [_playerFourButton sizeToFit];
    CGRect fourFrame = _playerFourButton.frame;
    fourFrame.size.width = fourFrame.size.width + 12;
    fourFrame.size.height = fourFrame.size.height + 12;
    [_playerFourButton setFrame:fourFrame];
    [_playerFourButton setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 160)];
    _playerFourButton.tag = PLAYERFOUR;
    //[self.view addSubview:_playerFourButton];
    [_tennisView addSubview:_playerFourButton];
    
}

-(void)toggleDoubles:(id)sender {
    FUIButton *button = (FUIButton*)sender;
    
    //for (id button in [self.view subviews]) {
    for (id button in [_tennisView subviews]) {
        if ([button class] == [FUIButton class]) {
            FUIButton *tmp = (FUIButton*)button;
            if (tmp.tag == PLAYERONEBUTTON) {
                [tmp removeFromSuperview];
            }
            if (tmp.tag == PLAYERTWOBUTTON) {
                [tmp removeFromSuperview];
            }
            if (tmp.tag == PLAYERTHREEBUTTON) {
                [tmp removeFromSuperview];
            }
            if (tmp.tag == PLAYERFOURBUTTON) {
                [tmp removeFromSuperview];
            }
        }
    }
    
    if (_isSingles) {
        [self configureDoubles];
        [button setTitle:@"Doubles" forState:UIControlStateNormal];
        [button sizeToFit];
        CGRect dBFrame = button.frame;
        dBFrame.size.width = dBFrame.size.width + 12;
        dBFrame.size.height = dBFrame.size.height + 12;
        [button setFrame:dBFrame];
        _isSingles = false;
    }
    else {
        [self configureSingles];
        [button setTitle:@"Singles" forState:UIControlStateNormal];
        [button sizeToFit];
        CGRect dBFrame = button.frame;
        dBFrame.size.width = dBFrame.size.width + 12;
        dBFrame.size.height = dBFrame.size.height + 12;
        [button setFrame:dBFrame];
        _isSingles = true;
    }
}

-(void)addPlayerListWindow {
    
    _playerList = [[NewPlayerView alloc] init];
    _playerList.delegate = self;
    _playerList.parentViewController = self;
    _playerList.blurRadius = 20.0;
    [_playerList setFrame:CGRectMake(0, self.view.frame.size.height+5, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_playerList];
}

-(void)addPlayerOne {
    [self addPlayerListWindow];
    [UIView animateWithDuration:0.5 animations:^{
        [_playerList setFrame:self.view.frame];
    } completion:^(BOOL finished) {
        //up up
    }];
    _playerNumber = PLAYERONE;
}

-(void)addPlayerTwo {
    [self addPlayerListWindow];
    [UIView animateWithDuration:0.5 animations:^{
        [_playerList setFrame:self.view.frame];
    } completion:^(BOOL finished) {
        //up up
    }];
    _playerNumber = PLAYERTWO;
}

-(void)addPlayerThree {
    [self addPlayerListWindow];
    [UIView animateWithDuration:0.5 animations:^{
        [_playerList setFrame:self.view.frame];
    } completion:^(BOOL finished) {
        //up up
    }];
    _playerNumber = PLAYERTHREE;
}

-(void)addPlayerFour {
    [self addPlayerListWindow];
    [UIView animateWithDuration:0.5 animations:^{
        [_playerList setFrame:self.view.frame];
    } completion:^(BOOL finished) {
        //up up
    }];
    _playerNumber = PLAYERFOUR;
}

-(void)closePlayerList {
    [UIView animateWithDuration:0.5 animations:^{
        [_playerList setFrame:CGRectMake(0, self.view.frame.size.height+5, self.view.frame.size.width, self.view.frame.size.height)];
    } completion:^(BOOL finished) {
        //up up
        if ((_teamOneSet == 3) && (_teamTwoSet == 3))  {
            [_matchViewButton addTarget:self action:@selector(showMatchView) forControlEvents:UIControlEventTouchUpInside];
            _matchViewButton.roundBackgroundColor = [UIColor asbestosColor];
            _matchViewButton.tintColor = [UIColor turquoiseColor];
        }
        [_playerList removeFromSuperview];
    }];
}

-(void)setPlayerButtonWithPlayer:(Player*)player {
    switch (_playerNumber) {
        case PLAYERONE:
            [_playerOneButton setTitle:[player playerName] forState:UIControlStateNormal];
            break;
        case PLAYERTWO:
            [_playerTwoButton setTitle:[player playerName] forState:UIControlStateNormal];
            break;
        case PLAYERTHREE:
            [_playerThreeButton setTitle:[player playerName] forState:UIControlStateNormal];
            break;
        case PLAYERFOUR:
            [_playerFourButton setTitle:[player playerName] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

-(void)pickedPlayer:(Player *)player {
    if (player == nil) {
        //Do nothing then close
    }
    else {
        [self setPlayerButtonWithPlayer:player];
        if (_isSingles) {
            switch (_playerNumber) {
                case PLAYERONE:{
                    _teamOne = [[Team alloc] init];
                    [_teamOne setPlayerOne:player];
                    _teamOneSet = PLAYERSSET;
                    break;
                }
                case PLAYERTWO:{
                    _teamTwo = [[Team alloc] init];
                    [_teamTwo setPlayerOne:player];
                    _teamTwoSet = PLAYERSSET;
                    break;
                }
                default:
                    break;
            }
            
        }
        else {
            switch (_playerNumber) {
                case PLAYERONE:{
                    if (_teamOne) {
                        [_teamOne setPlayerOne:player];
                    }
                    else {
                        _teamOne = [[Team alloc] init];
                        [_teamOne setPlayerOne:player];
                    }
                    if (_teamOneSet & 1) {
                        //Do nothing player one aleady set
                    }
                    else {
                        _teamOneSet += PLAYERONESET;
                    }
                    break;
                }
                case PLAYERTWO:{
                    if (_teamOne) {
                        [_teamOne setPlayerTwo:player];
                    }
                    else {
                        _teamOne = [[Team alloc] init];
                        [_teamOne setPlayerTwo:player];
                    }
                    if (_teamOneSet & 2) {
                        //Do nothing player two set
                    }
                    else {
                        _teamOneSet += PLAYERTWOSET;
                    }
                    break;
                }
                case PLAYERTHREE:{
                    if (_teamTwo) {
                        [_teamTwo setPlayerOne:player];
                    }
                    else {
                        _teamTwo = [[Team alloc] init];
                        [_teamTwo setPlayerOne:player];
                    }
                    if (_teamTwoSet & 1) {
                        //Do nothing player one aleady set
                    }
                    else {
                        _teamTwoSet += PLAYERONESET;
                    }
                    break;
                }
                case PLAYERFOUR:{
                    if (_teamTwo) {
                        [_teamTwo setPlayerTwo:player];
                    }
                    else {
                        _teamTwo = [[Team alloc] init];
                        [_teamTwo setPlayerTwo:player];
                    }
                    if (_teamTwoSet & 2) {
                        //Do nothing player two set
                    }
                    else {
                        _teamTwoSet += PLAYERTWOSET;
                    }
                    break;
                }
                
                default:
                    break;
            }
        }
    }
    
    [self closePlayerList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
