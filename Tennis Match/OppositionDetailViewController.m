//
//  OppositionDetailViewController.m
//  Tennis Match
//
//  Created by Robert Miller on 5/4/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "OppositionDetailViewController.h"
#import "Opponent.h"
#import <FlatUIKit.h>
#import <TOMSMorphingLabel/TOMSMorphingLabel.h>
#import <GRKBarGraphView/GRKBarGraphView.h>

@interface OppositionDetailViewController ()

@property(nonatomic,retain) NSMutableArray *boolArray;
@property(nonatomic,retain) UIScrollView *scrollView;

@end

@implementation OppositionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cloudsColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _navBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height /*- _navBar.bounds.size.height*/)];
    [_scrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 980)];
    [self.view addSubview:_scrollView];
    
    [self configureView];
}

-(void)viewDidAppear:(BOOL)animated {
    
}

-(void)configureView {
    /*
    if ([_boolArray objectAtIndex:page-1] == nil) {
        [_boolArray insertObject:[NSNumber numberWithBool:true] atIndex:page-1];
    }
    else if ([[_boolArray objectAtIndex:page-1] boolValue]) {
        //page has already been loaded
        completionHandler(true);
        return;
    }
    */
    //float xOffset = page*[UIScreen mainScreen].bounds.size.width;
    
    //Opponent *opponent = [[_detailPlayer opponents] objectAtIndex:page-1];
    
    UIView *myLineView = [[UIView alloc] initWithFrame:CGRectMake(/*xOffset +*/ 20, 0, 5, _scrollView.contentSize.height)];
    myLineView.backgroundColor = [UIColor asbestosColor];
    [_scrollView addSubview:myLineView];
    
    UIView *oppLineView = [[UIView alloc] initWithFrame:CGRectMake(/*xOffset +*/ [UIScreen mainScreen].bounds.size.width - 25, 0, 5, _scrollView.contentSize.height)];
    oppLineView.backgroundColor = [UIColor asbestosColor];
    [_scrollView addSubview:oppLineView];
    
    Team *teamOne = [_detailOpponent myTeam];
    Team *teamTwo = [_detailOpponent opposingTeam];
    
    [teamOne setTeams];
    [teamTwo setTeams];
    
    int SCORESIZE = 60;
    
    float firstTeamPixelStart = self.navigationController.navigationBar.frame.size.height + 15;
    
    /* setup the first team */
    UIImageView *imageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(/*xOffset +*/ 10, firstTeamPixelStart, 3*SCORESIZE/4, 3*SCORESIZE/4)];;
    imageViewOne.contentMode = UIViewContentModeScaleAspectFit;
    imageViewOne.layer.cornerRadius = 3*SCORESIZE/8;
    imageViewOne.layer.borderColor = [[UIColor grayColor] CGColor];
    imageViewOne.backgroundColor = [UIColor asbestosColor];
    imageViewOne.layer.borderWidth = 2.0;
    imageViewOne.layer.masksToBounds = YES;
    imageViewOne.image = [UIImage imageNamed:@"no-player-image.png"];
    if ([[teamOne playerOne] playerImage]) {
        imageViewOne.image = [UIImage imageWithData:[[teamOne playerOne] playerImage]];
    }
    [_scrollView addSubview:imageViewOne];
    
    UILabel *teamOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(/*xOffset +*/ 3*SCORESIZE/4 + 25, firstTeamPixelStart, self.view.frame.size.width / 2 - 15 - SCORESIZE, SCORESIZE)];
    teamOneLabel.font = [UIFont boldFlatFontOfSize:20.0f];
    teamOneLabel.textAlignment = NSTextAlignmentLeft;
    teamOneLabel.lineBreakMode = NSLineBreakByWordWrapping;
    teamOneLabel.numberOfLines = 0;
    teamOneLabel.text = [[teamOne playerOne] playerName];
    if ([teamOne doubles]) {
        UIImageView *imageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(/*xOffset +*/ SCORESIZE/2, firstTeamPixelStart + SCORESIZE/3, 3*SCORESIZE/4, 3*SCORESIZE/4)];
        imageViewTwo.backgroundColor = [UIColor asbestosColor];
        imageViewTwo.contentMode = UIViewContentModeScaleAspectFit;
        imageViewTwo.layer.cornerRadius = (3*SCORESIZE/4)/2;
        imageViewTwo.layer.borderWidth = 2.0;
        imageViewTwo.layer.borderColor = [[UIColor grayColor] CGColor];
        imageViewTwo.layer.masksToBounds = YES;
        imageViewTwo.image = [UIImage imageNamed:@"no-player-image.png"];
        if ([[teamOne playerTwo] playerImage]) {
            imageViewTwo.image = [UIImage imageWithData:[[teamOne playerTwo] playerImage]];
        }
        [_scrollView addSubview:imageViewTwo];
        
        teamOneLabel.text = [teamOneLabel.text stringByAppendingString:@" & "];
        teamOneLabel.text = [teamOneLabel.text stringByAppendingString:[[teamOne playerTwo] playerName]];
    }
    [_scrollView addSubview:teamOneLabel];
    
    /* setup team two stuff */
    UIImageView *imageViewThree = [[UIImageView alloc] initWithFrame:CGRectMake(/*xOffset +*/ [UIScreen mainScreen].bounds.size.width - 10 - 3*SCORESIZE/4, firstTeamPixelStart, 3*SCORESIZE/4, 3*SCORESIZE/4)];
    imageViewThree.backgroundColor = [UIColor asbestosColor];
    imageViewThree.contentMode = UIViewContentModeScaleAspectFit;
    imageViewThree.layer.cornerRadius = 3*SCORESIZE/8;
    imageViewThree.layer.borderColor = [[UIColor grayColor] CGColor];
    imageViewThree.layer.borderWidth = 2.0;
    imageViewThree.layer.masksToBounds = YES;
    imageViewThree.image = [UIImage imageNamed:@"no-player-image.png"];
    if ([[teamTwo playerOne] playerImage]) {
        imageViewThree.image = [UIImage imageWithData:[[teamTwo playerOne] playerImage]];
    }
    [_scrollView addSubview:imageViewThree];
    
    UILabel *teamTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(/*xOffset +*/ [UIScreen mainScreen].bounds.size.width/2, firstTeamPixelStart, self.view.frame.size.width / 2 - 10  - SCORESIZE, SCORESIZE)];
    teamTwoLabel.font = [UIFont boldFlatFontOfSize:20.0f];
    teamTwoLabel.textAlignment = NSTextAlignmentRight;
    teamTwoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    teamTwoLabel.numberOfLines = 0;
    teamTwoLabel.text = [[teamTwo playerOne] playerName];
    if ([teamTwo doubles]) {
        UIImageView *imageViewFour = [[UIImageView alloc] initWithFrame:CGRectMake(/*xOffset +*/ [UIScreen mainScreen].bounds.size.width - 10 - 3*SCORESIZE/4 - SCORESIZE/2, SCORESIZE/3 + firstTeamPixelStart, 3*SCORESIZE/4, 3*SCORESIZE/4)];
        imageViewFour.backgroundColor = [UIColor asbestosColor];
        imageViewFour.contentMode = UIViewContentModeScaleAspectFit;
        imageViewFour.layer.cornerRadius = 3*SCORESIZE/8;
        imageViewFour.layer.borderWidth = 2.0;
        imageViewFour.layer.borderColor = [[UIColor grayColor] CGColor];
        imageViewFour.layer.masksToBounds = YES;
        imageViewFour.image = [UIImage imageNamed:@"no-player-image.png"];
        if ([[teamTwo playerTwo] playerImage]) {
            imageViewFour.image = [UIImage imageWithData:[[teamTwo playerTwo] playerImage]];
        }
        [_scrollView addSubview:imageViewFour];
        
        teamTwoLabel.text = [teamTwoLabel.text stringByAppendingString:@" & "];
        teamTwoLabel.text = [teamTwoLabel.text stringByAppendingString:[[teamTwo playerTwo] playerName]];
    }
    [_scrollView addSubview:teamTwoLabel];
    
    [self performSelector:@selector(addOppositionMatchesGraph:) withObject:_detailOpponent afterDelay:0.5];
    [self performSelector:@selector(addOppositionSetsGraph:) withObject:_detailOpponent afterDelay:1.0];
    [self performSelector:@selector(addOppositionGamesGraph:) withObject:_detailOpponent afterDelay:1.5];
    //[self performSelector:@selector(addOppositionStatistics:) withObject:opponent afterDelay:2.0];
    
    __weak typeof(self) weakSelf = self;
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        [self addOppositionStatistics:_detailOpponent complete:^(bool complete) {
            //[weakSelf.boolArray insertObject:[NSNumber numberWithBool:true] atIndex:page-1];
            //completionHandler(true);
        }];
    });
    
}

-(void)addOppositionGamesGraph:(Opponent*)opponent {
    
    //float xOffset = _pageControl.currentPage * [UIScreen mainScreen].bounds.size.width;
    
    Stats *myStats = [opponent myTeamStats];
    Stats *theirStats = [opponent opposingTeamStats];
    
    TOMSMorphingLabel *label = [[TOMSMorphingLabel alloc]initWithFrame:CGRectMake(/*xOffset +*/ 30, /*self.navigationController.navigationBar.frame.size.height +*/ 375, self.view.frame.size.width - 30 - 120, 45)];
    [_scrollView addSubview:label];
    label.font = [UIFont boldFlatFontOfSize:20.0f];
    label.textColor = [UIColor asbestosColor];
    label.text = @"Game Stats: ";
    
    TOMSMorphingLabel *playedLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(/*xOffset + */45, /*self.navigationController.navigationBar.frame.size.height +*/ 420, self.view.frame.size.width - 45 - 120, 25)];
    [_scrollView addSubview:playedLabel];
    playedLabel.textAlignment = NSTextAlignmentLeft;
    playedLabel.textColor = [UIColor asbestosColor];
    //NSString *playedLabelString = @"Played: ";
    //playedLabelString = [playedLabelString stringByAppendingString:[[[_detailPlayer playerStats] playerGamesPlayed] stringValue]];
    //playedLabel.text = playedLabelString;
    playedLabel.text = [[myStats playerGamesWon] stringValue];
    
    TOMSMorphingLabel *wonLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(/*xOffset +*/ [UIScreen mainScreen].bounds.size.width/2, /*self.navigationController.navigationBar.frame.size.height +*/ 420, self.view.frame.size.width/2 - 45, 25)];
    [_scrollView addSubview:wonLabel];
    wonLabel.textAlignment = NSTextAlignmentRight;
    wonLabel.textColor = [UIColor asbestosColor];
    wonLabel.text = [[theirStats playerGamesWon] stringValue];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(/*xOffset +*/ 45, 465, [UIScreen mainScreen].bounds.size.width - 90, 30)];
    [_scrollView addSubview:containerView];
    
    //GRKBarGraphView *graph = [[GRKBarGraphView alloc] initWithFrame:CGRectMake(xOffset + 45, 235, [UIScreen mainScreen].bounds.size.width - 90, 30)];
    GRKBarGraphView *graph = [[GRKBarGraphView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 90, 30)];
    [containerView addSubview:graph];
    [graph setTranslatesAutoresizingMaskIntoConstraints:YES];
    graph.animationDuration = 0.7;
    graph.percent = 0.5;
    graph.barColorUsesTintColor = NO;
    graph.tintColor = [UIColor asbestosColor];
    graph.barColor = [UIColor turquoiseColor];
    graph.backgroundColor = [UIColor alizarinColor];
    float percent = [[myStats playerGamesWon] floatValue] / ([[myStats playerGamesWon] floatValue] + [[theirStats playerGamesWon] floatValue]);
    NSNumber *percentNumber = [NSNumber numberWithFloat:percent];
    
    NSDictionary *dict = @{ @"Graph" : graph, @"Percent" : percentNumber, };
    [self performSelector:@selector(setGraphPercentWithDictionary:) withObject:dict afterDelay:0.5];
    
    //NSDictionary *viewBindings = NSDictionaryOfVariableBindings(_scrollView, graph);
    
    NSDictionary *viewBindings = NSDictionaryOfVariableBindings(containerView, graph);
    
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[graph]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:viewBindings]];
    
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[graph]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:viewBindings]];
    
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:graph attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeHeight multiplier:0 constant:30.0f]];
    
}

-(void)addOppositionSetsGraph:(Opponent*)opponent {
    
    float xOffset = 0;//_pageControl.currentPage * [UIScreen mainScreen].bounds.size.width;
    
    Stats *myStats = [opponent myTeamStats];
    Stats *theirStats = [opponent opposingTeamStats];
    
    TOMSMorphingLabel *label = [[TOMSMorphingLabel alloc]initWithFrame:CGRectMake(xOffset + 30, /*self.navigationController.navigationBar.frame.size.height +*/ 260, self.view.frame.size.width - 30 - 120, 45)];
    [_scrollView addSubview:label];
    label.font = [UIFont boldFlatFontOfSize:20.0f];
    label.textColor = [UIColor asbestosColor];
    label.text = @"Set Stats: ";
    
    TOMSMorphingLabel *playedLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + 45, /*self.navigationController.navigationBar.frame.size.height +*/ 305, self.view.frame.size.width - 45 - 120, 25)];
    [_scrollView addSubview:playedLabel];
    playedLabel.textAlignment = NSTextAlignmentLeft;
    playedLabel.textColor = [UIColor asbestosColor];
    //NSString *playedLabelString = @"Played: ";
    //playedLabelString = [playedLabelString stringByAppendingString:[[[_detailPlayer playerStats] playerSetsPlayed] stringValue]];
    //playedLabel.text = playedLabelString;
    playedLabel.text = [[myStats playerSetsWon] stringValue];
    
    TOMSMorphingLabel *wonLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width/2, /*self.navigationController.navigationBar.frame.size.height +*/ 305, self.view.frame.size.width/2 - 45, 25)];
    [_scrollView addSubview:wonLabel];
    wonLabel.textAlignment = NSTextAlignmentRight;
    wonLabel.textColor = [UIColor asbestosColor];
    wonLabel.text = [[theirStats playerSetsWon] stringValue];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(xOffset + 45, 350, [UIScreen mainScreen].bounds.size.width - 90, 30)];
    [_scrollView addSubview:containerView];
    
    //GRKBarGraphView *graph = [[GRKBarGraphView alloc] initWithFrame:CGRectMake(xOffset + 45, 235, [UIScreen mainScreen].bounds.size.width - 90, 30)];
    GRKBarGraphView *graph = [[GRKBarGraphView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 90, 30)];
    [containerView addSubview:graph];
    [graph setTranslatesAutoresizingMaskIntoConstraints:YES];
    graph.animationDuration = 0.7;
    graph.percent = 0.5;
    graph.barColorUsesTintColor = NO;
    graph.tintColor = [UIColor asbestosColor];
    graph.barColor = [UIColor turquoiseColor];
    graph.backgroundColor = [UIColor alizarinColor];
    float percent = [[myStats playerSetsWon] floatValue] / ([[myStats playerSetsWon] floatValue] + [[theirStats playerSetsWon] floatValue]);
    NSNumber *percentNumber = [NSNumber numberWithFloat:percent];
    
    NSDictionary *dict = @{ @"Graph" : graph, @"Percent" : percentNumber, };
    [self performSelector:@selector(setGraphPercentWithDictionary:) withObject:dict afterDelay:0.5];
    
    //NSDictionary *viewBindings = NSDictionaryOfVariableBindings(_scrollView, graph);
    
    NSDictionary *viewBindings = NSDictionaryOfVariableBindings(containerView, graph);
    
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[graph]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:viewBindings]];
    
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[graph]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:viewBindings]];
    
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:graph attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeHeight multiplier:0 constant:30.0f]];
    
}

-(void)addOppositionMatchesGraph:(Opponent*)opponent {
    
    float xOffset = 0;//_pageControl.currentPage * [UIScreen mainScreen].bounds.size.width;
    
    Stats *myStats = [opponent myTeamStats];
    Stats *theirStats = [opponent opposingTeamStats];
    
    TOMSMorphingLabel *label = [[TOMSMorphingLabel alloc]initWithFrame:CGRectMake(xOffset + 30, /*self.navigationController.navigationBar.frame.size.height +*/ 145, self.view.frame.size.width - 30 - 120, 45)];
    [_scrollView addSubview:label];
    label.font = [UIFont boldFlatFontOfSize:20.0f];
    label.textColor = [UIColor asbestosColor];
    label.text = @"Match Stats:";
    
    TOMSMorphingLabel *playedLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + 45, /*self.navigationController.navigationBar.frame.size.height +*/ 190, self.view.frame.size.width/2 - 45, 25)];
    [_scrollView addSubview:playedLabel];
    playedLabel.textAlignment = NSTextAlignmentLeft;
    playedLabel.textColor = [UIColor asbestosColor];
    //NSString *playedLabelString =
    //playedLabelString = [playedLabelString stringByAppendingString:[[[_detailPlayer playerStats] playerMatchesPlayed] stringValue]];
    playedLabel.text = [[myStats playerMatchesWon] stringValue];
    //playedLabel.text = [playedLabel.text stringByAppendingString:[[_detailPlayer playerSetsPlayed] stringValue]];
    
    TOMSMorphingLabel *wonLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width/2, /*self.navigationController.navigationBar.frame.size.height +*/ 190, self.view.frame.size.width/2 - 45, 25)];
    [_scrollView addSubview:wonLabel];
    wonLabel.textAlignment = NSTextAlignmentRight;
    wonLabel.textColor = [UIColor asbestosColor];
    wonLabel.text = [[theirStats playerMatchesWon] stringValue];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(xOffset + 45, 235, [UIScreen mainScreen].bounds.size.width - 90, 30)];
    [_scrollView addSubview:containerView];
    
    //GRKBarGraphView *graph = [[GRKBarGraphView alloc] initWithFrame:CGRectMake(xOffset + 45, 235, [UIScreen mainScreen].bounds.size.width - 90, 30)];
    GRKBarGraphView *graph = [[GRKBarGraphView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 90, 30)];
    [containerView addSubview:graph];
    [graph setTranslatesAutoresizingMaskIntoConstraints:YES];
    graph.animationDuration = 0.7;
    graph.percent = 0.5;
    graph.barColorUsesTintColor = NO;
    graph.tintColor = [UIColor asbestosColor];
    graph.barColor = [UIColor turquoiseColor];
    graph.backgroundColor = [UIColor alizarinColor];
    float percent = [[myStats playerMatchesWon] floatValue] / ([[myStats playerMatchesWon] floatValue] + [[theirStats playerMatchesWon] floatValue]);
    NSNumber *percentNumber = [NSNumber numberWithFloat:percent];
    
    NSDictionary *dict = @{ @"Graph" : graph, @"Percent" : percentNumber, };
    [self performSelector:@selector(setGraphPercentWithDictionary:) withObject:dict afterDelay:0.5];
    
    //NSDictionary *viewBindings = NSDictionaryOfVariableBindings(_scrollView, graph);
    
    NSDictionary *viewBindings = NSDictionaryOfVariableBindings(containerView, graph);
    
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[graph]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:viewBindings]];
    
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[graph]-0-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:viewBindings]];
    
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:graph attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeHeight multiplier:0 constant:30.0f]];
    
}

-(void)setGraphPercentWithDictionary:(NSDictionary*)dict {
    GRKBarGraphView *graph = (GRKBarGraphView*)dict[@"Graph"];
    NSNumber *percent = (NSNumber*)dict[@"Percent"];
    graph.percent = [percent floatValue];
}

-(void)addOppositionStatistics:(Opponent*)opponent complete:(void(^)(bool complete))completionhandler {
    
    Stats *myTeamStats = [opponent myTeamStats];
    Stats *oppTeamStats = [opponent opposingTeamStats];
    
    float xOffset = 0;//_pageControl.currentPage * [UIScreen mainScreen].bounds.size.width;
    
    TOMSMorphingLabel *servingStatsLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + 30, /*self.navigationController.navigationBar.frame.size.height +*/ 500, self.view.frame.size.width - 70 - 120, 45)];
    [_scrollView addSubview:servingStatsLabel];
    servingStatsLabel.font = [UIFont boldFlatFontOfSize:20.0f];
    servingStatsLabel.textColor = [UIColor asbestosColor];
    servingStatsLabel.text = @"Serving Stats: ";
    
    TOMSMorphingLabel *acesLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width / 2 - 100, 545, 200, 25)];
    [_scrollView addSubview:acesLabel];
    acesLabel.textAlignment = NSTextAlignmentCenter;
    acesLabel.textColor = [UIColor asbestosColor];
    acesLabel.text = @"Aces:";
    
    TOMSMorphingLabel *acesWon = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + 45, 575, 120, 25)];
    [_scrollView addSubview:acesWon];
    acesWon.textAlignment = NSTextAlignmentLeft;
    acesWon.textColor = [UIColor asbestosColor];
    int acesWonInteger = [[myTeamStats aces] intValue] + [[myTeamStats acesTwo] intValue];
    acesWon.text = [[NSNumber numberWithInt:acesWonInteger] stringValue];
    
    TOMSMorphingLabel *acesLost = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width - 45 - 120, 575, 120, 25)];
    [_scrollView addSubview:acesLost];
    acesLost.textAlignment = NSTextAlignmentRight;
    acesLost.textColor = [UIColor asbestosColor];
    int acesLostInteger = [[oppTeamStats aces] intValue] + [[oppTeamStats acesTwo] intValue];
    acesLost.text = [[NSNumber numberWithInt:acesLostInteger] stringValue];
    
    TOMSMorphingLabel *doubleFaultsLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width / 2 - 100, 605, 200, 25)];
    [_scrollView addSubview:doubleFaultsLabel];
    doubleFaultsLabel.textAlignment = NSTextAlignmentCenter;
    doubleFaultsLabel.textColor = [UIColor asbestosColor];
    doubleFaultsLabel.text = @"Double Faults:";
    
    TOMSMorphingLabel *doubleFaults = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + 45, 635, 120, 25)];
    [_scrollView addSubview:doubleFaults];
    doubleFaults.textAlignment = NSTextAlignmentLeft;
    doubleFaults.textColor = [UIColor asbestosColor];
    int doubleFaultsInteger = [[myTeamStats doubleFaults] intValue] + [[myTeamStats doubleFaultsTwo] intValue];
    doubleFaults.text = [[NSNumber numberWithInt:doubleFaultsInteger] stringValue];
    
    TOMSMorphingLabel *doubleFaultsLost = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width - 45 - 120, 635, 120, 25)];
    [_scrollView addSubview:doubleFaultsLost];
    doubleFaultsLost.textAlignment = NSTextAlignmentRight;
    doubleFaultsLost.textColor = [UIColor asbestosColor];
    int doubleFaultsLostInteger = [[oppTeamStats doubleFaults] intValue] + [[oppTeamStats doubleFaultsTwo] intValue];
    doubleFaultsLost.text = [[NSNumber numberWithInt:doubleFaultsLostInteger] stringValue];
    
    TOMSMorphingLabel *firstServeLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width / 2 - 100, 665, 200, 25)];
    [_scrollView addSubview:firstServeLabel];
    firstServeLabel.textAlignment = NSTextAlignmentCenter;
    firstServeLabel.textColor = [UIColor asbestosColor];
    firstServeLabel.text = @"First Serves Won:";
    
    float servesMadeInteger = [[myTeamStats servesMade] floatValue] + [[myTeamStats servesMadeTwo] floatValue];
    float servesMadeLostInteger = [[oppTeamStats servesMade] floatValue] + [[oppTeamStats servesMadeTwo] floatValue];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
    
    TOMSMorphingLabel *firstServes = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + 45, 695, 120, 25)];
    [_scrollView addSubview:firstServes];
    firstServes.textAlignment = NSTextAlignmentLeft;
    firstServes.textColor = [UIColor asbestosColor];
    if ([[myTeamStats servesMade] intValue] == 0) {
        firstServes.text = @"0%(0)";
    }
    else {
        float firstServeInteger = [[myTeamStats firstServesWon] floatValue] + [[myTeamStats firstServesWonTwo] floatValue];
        float firstServePercentage = (firstServeInteger / servesMadeInteger);// * 100;
        NSNumber *firstServePercentageNumber = [NSNumber numberWithFloat:firstServePercentage];
        NSString *firstServeString = [formatter stringFromNumber:firstServePercentageNumber];
        firstServeString = [firstServeString stringByAppendingString:@"("];
        firstServeString = [firstServeString stringByAppendingString:[[NSNumber numberWithInt:firstServeInteger] stringValue]];
        firstServeString = [firstServeString stringByAppendingString:@")"];
        firstServes.text = firstServeString;
    }
    
    TOMSMorphingLabel *firstServesLost = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width - 45 - 120, 695, 120, 25)];
    [_scrollView addSubview:firstServesLost];
    firstServesLost.textAlignment = NSTextAlignmentRight;
    firstServesLost.textColor = [UIColor asbestosColor];
    if (servesMadeInteger == 0) {
        firstServesLost.text = @"0%(0)";
    }
    else {
        float firstServeLostInteger = [[oppTeamStats firstServesWon] floatValue] + [[oppTeamStats firstServesWonTwo] floatValue];
        float firstServePercentageLost = (firstServeLostInteger / servesMadeLostInteger);// * 100;
        NSNumber *firstServePercentageNumberLost = [NSNumber numberWithFloat:firstServePercentageLost];
        NSString *firstServeStringLost = [formatter stringFromNumber:firstServePercentageNumberLost];
        firstServeStringLost = [firstServeStringLost stringByAppendingString:@"("];
        firstServeStringLost = [firstServeStringLost stringByAppendingString:[[NSNumber numberWithInt:firstServeLostInteger] stringValue]];
        firstServeStringLost = [firstServeStringLost stringByAppendingString:@")"];
        firstServesLost.text = firstServeStringLost;
    }
    
    TOMSMorphingLabel *secondServesLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width / 2 - 100, 725, 200, 25)];
    [_scrollView addSubview:secondServesLabel];
    secondServesLabel.textAlignment = NSTextAlignmentCenter;
    secondServesLabel.textColor = [UIColor asbestosColor];
    secondServesLabel.text = @"Second Serves Won:";
    
    TOMSMorphingLabel *secondServes = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + 45, 755, 120, 25)];
    [_scrollView addSubview:secondServes];
    secondServes.textAlignment = NSTextAlignmentLeft;
    secondServes.textColor = [UIColor asbestosColor];
    if (servesMadeInteger == 0) {
        secondServes.text = @"0%(0)";
    }
    else {
        float secondServesInteger = [[myTeamStats secondServesWon] floatValue] + [[myTeamStats secondServesWonTwo] floatValue];
        float secondServePercentage = (secondServesInteger / servesMadeInteger);// * 100;
        NSNumber *secondServePercentageNumber = [NSNumber numberWithFloat:secondServePercentage];
        NSString *secondServeString = [formatter stringFromNumber:secondServePercentageNumber];
        secondServeString = [secondServeString stringByAppendingString:@"("];
        secondServeString = [secondServeString stringByAppendingString:[[NSNumber numberWithInt:secondServesInteger] stringValue]];
        secondServeString = [secondServeString stringByAppendingString:@")"];
        secondServes.text = secondServeString;
    }
    
    TOMSMorphingLabel *secondServesLost = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width - 45 - 120, 755, 120, 25)];
    [_scrollView addSubview:secondServesLost];
    secondServesLost.textAlignment = NSTextAlignmentRight;
    secondServesLost.textColor = [UIColor asbestosColor];
    if (servesMadeInteger == 0) {
        secondServesLost.text = @"0%(0)";
    }
    else {
        float secondServesLostInteger = [[oppTeamStats secondServesWon] floatValue] + [[oppTeamStats secondServesWonTwo] floatValue];
        float secondServePercentageLost = (secondServesLostInteger / servesMadeLostInteger);// * 100;
        NSNumber *secondServePercentageNumberLost = [NSNumber numberWithFloat:secondServePercentageLost];
        NSString *secondServeStringLost = [formatter stringFromNumber:secondServePercentageNumberLost];
        secondServeStringLost = [secondServeStringLost stringByAppendingString:@"("];
        secondServeStringLost = [secondServeStringLost stringByAppendingString:[[NSNumber numberWithInt:secondServesLostInteger] stringValue]];
        secondServeStringLost = [secondServeStringLost stringByAppendingString:@")"];
        secondServesLost.text = secondServeStringLost;
    }
    
    TOMSMorphingLabel *servesMadeLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100, 785, 200, 25)];
    [_scrollView addSubview:servesMadeLabel];
    servesMadeLabel.textAlignment = NSTextAlignmentCenter;
    servesMadeLabel.textColor = [UIColor asbestosColor];
    servesMadeLabel.text = @"Service Games Played";
    
    TOMSMorphingLabel *servesMade = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + 45, 815, 120, 25)];
    [_scrollView addSubview:servesMade];
    servesMade.textAlignment = NSTextAlignmentLeft;
    servesMade.textColor = [UIColor asbestosColor];
    servesMade.text = [[NSNumber numberWithInt:servesMadeInteger] stringValue];
    
    TOMSMorphingLabel *servesMadeLost = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width - 45 - 120, 815, 120, 25)];
    [_scrollView addSubview:servesMadeLost];
    servesMadeLost.textAlignment = NSTextAlignmentRight;
    servesMadeLost.textColor = [UIColor asbestosColor];
    servesMadeLost.text = [[NSNumber numberWithInt:servesMadeLostInteger] stringValue];
    
    completionhandler(true);
    
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
