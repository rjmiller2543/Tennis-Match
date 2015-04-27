//
//  PlayerDetailViewController.m
//  Tennis Match
//
//  Created by Robert Miller on 4/19/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "PlayerDetailViewController.h"
#import <PNChart/PNChart.h>
#import <FlatUIKit.h>
#import <TOMSMorphingLabel/TOMSMorphingLabel.h>
#import "NewPlayerViewController.h"
#import <MZFormSheetController/MZFormSheetController.h>
#import "Stats.h"
#import <GRKBarGraphView/GRKBarGraphView.h>
#import <VBFPopFlatButton/VBFPopFlatButton.h>
#import "Opponent.h"

@interface PlayerDetailViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,retain) UIImageView *imageView;
@property(nonatomic,retain) UILabel *nameLabel;
@property(nonatomic,retain) UILabel *lastNameLabel;

@property(nonatomic,retain) UIPageControl *pageControl;

@property(nonatomic,retain) NSMutableArray *boolArray;

@end

@implementation PlayerDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cloudsColor];
    
    [self configureView];
    
    _boolArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [[_detailPlayer opponents] count]; i++) {
        [_boolArray addObject:[NSNumber numberWithBool:false]];
    }
    
    [self performSelector:@selector(addPlayerMatchesGraph) withObject:nil afterDelay:0.5];
    [self performSelector:@selector(addPlayerSetsGraph) withObject:nil afterDelay:1.0];
    [self performSelector:@selector(addPlayerGamesGraph) withObject:nil afterDelay:1.5];
    [self performSelector:@selector(addServingStatistics) withObject:nil afterDelay:2.0];
    
    //[self bottomLayout];
    
}

-(void)configureView {
    
    self.title = [_detailPlayer playerName];
    //[self.navigationController setTitle:@"Player"];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPlayer)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    self.view.backgroundColor = [UIColor cloudsColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.pagingEnabled = YES;
    //_scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * ([[_detailPlayer opponents] count] + 1), 980);
    [self.view addSubview:_scrollView];
    
    _scrollView.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *swipe = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    //[swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    swipe.delegate = self;
    [swipe setCancelsTouchesInView:YES];
    [swipe setMinimumNumberOfTouches:1];
    [_scrollView addGestureRecognizer:swipe];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/2, 30)];
    [_pageControl setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height - 40)];
    [_pageControl addTarget:self action:@selector(pageChanged) forControlEvents:UIControlEventValueChanged];
    _pageControl.hidesForSinglePage = YES;
    _pageControl.numberOfPages = [[_detailPlayer opponents] count] + 1;
    [_pageControl setPageIndicatorTintColor:[UIColor asbestosColor]];
    [_pageControl setCurrentPageIndicatorTintColor:[UIColor turquoiseColor]];
    [self.view addSubview:_pageControl];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 5, _scrollView.contentSize.height)];
    lineView.backgroundColor = [UIColor asbestosColor];
    //[_scrollView addSubview:lineView];
    [_scrollView addSubview:lineView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, /*self.navigationController.navigationBar.frame.size.height +*/ 45, 90, 90)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.backgroundColor = [UIColor cloudsColor];
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = 45;
    _imageView.layer.borderWidth = 5;
    _imageView.layer.borderColor = [[UIColor asbestosColor] CGColor];
    if ([_detailPlayer playerImage]) {
        _imageView.image = [UIImage imageWithData:[_detailPlayer playerImage]];
    }
    else {
        _imageView.image = [UIImage imageNamed:@"no-player-image.png"];
        _imageView.userInteractionEnabled = YES;
    }
    [_scrollView addSubview:_imageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, /*self.navigationController.navigationBar.frame.size.height +*/ 45, self.view.frame.size.width - 110, 45)];
    _nameLabel.text = [_detailPlayer playerName];
    _nameLabel.font = [UIFont boldFlatFontOfSize:22.0f];
    [_scrollView addSubview:_nameLabel];
    
    _lastNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, /*self.navigationController.navigationBar.frame.size.height +*/ 90, self.view.frame.size.width - 110, 45)];
    _lastNameLabel.text = [_detailPlayer playerLastName];
    _lastNameLabel.font = [UIFont boldFlatFontOfSize:22.0f];
    [_scrollView addSubview:_lastNameLabel];
    
}

/*
-(void)switchViews {
    
    if (_isUp) {
        _isUp = false;
        [UIView animateWithDuration:0.7 animations:^{
            [_scrollView setFrame:CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
            [_bottomView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [_downButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 40, self.navigationController.navigationBar.frame.size.height + 40, 30, 30)];
            [_downButton animateToType:buttonUpBasicType];
            [self bottomLayout];
        } completion:^(BOOL finished) {
            // up up
        }];
    }
    else {
        _isUp = true;
        [UIView animateWithDuration:0.7 animations:^{
            [_scrollView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [_bottomView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
            [_downButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - 40, 30, 30)];
            [_downButton animateToType:buttonDownBasicType];
            //[self bottomLayout];
        } completion:^(BOOL finished) {
            // up up
        }];
    }
    
}
*/

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint velocity = [panGestureRecognizer velocityInView:_scrollView];
    return (fabs(velocity.x) > fabs(velocity.y));
}

-(void)pageChanged
{
    NSLog(@"page changed");
    int xOffset = _pageControl.currentPage * _scrollView.frame.size.width;
    //[_scrollView setContentOffset:CGPointMake(xOffset, 0)];
    [_scrollView scrollRectToVisible:CGRectMake(xOffset, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
    //[self oppositionLayout:_pageControl.currentPage];
}

-(void)swipe:(id)sender {
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer*)sender;
    
    CGPoint velocity = [pan velocityInView:_scrollView];
    
    if (velocity.x < -100) {
        if (_pageControl.currentPage < (_pageControl.numberOfPages - 1)) {
            [pan setEnabled:NO];
            _pageControl.currentPage = _pageControl.currentPage + 1;
            [_scrollView setContentOffset:CGPointMake(_pageControl.currentPage * [UIScreen mainScreen].bounds.size.width, 0) animated:YES];
            [self oppositionLayout:_pageControl.currentPage complete:^(bool complete) {
                if (complete) {
                    [pan setEnabled:YES];
                }
            }];
        }
    }
    else if (velocity.x > 100) {
        if (_pageControl.currentPage > 0) {
            [pan setEnabled:NO];
            _pageControl.currentPage = _pageControl.currentPage - 1;
            [_scrollView setContentOffset:CGPointMake(_pageControl.currentPage * [UIScreen mainScreen].bounds.size.width, 0) animated:YES];
            if (_pageControl.currentPage == 0) {
                //don't load the opposition layout
                [pan setEnabled:YES];
            }
            else {
                [self oppositionLayout:_pageControl.currentPage complete:^(bool complete) {
                    if (complete) {
                        [pan setEnabled:YES];
                    }
                }];
            }
        }
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    /*NSLog(@"the page is: %ld", (long)page);
    if (page != _pageControl.currentPage) {
        [_pageControl setCurrentPage:page];
        if (_pageControl.currentPage != 0) {
            [self oppositionLayout:_pageControl.currentPage complete:^(bool complete) {
                //up up
            }];
        }
    }
     */
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    //NSInteger yOffset = _scrollView.contentOffset.y;
    //NSLog(@"offset: %lu", yOffset);
    //if (yOffset >= ) {
    //    <#statements#>
    //}
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger xOffset = _scrollView.contentOffset.x;
    
    if (xOffset != (_pageControl.currentPage * [UIScreen mainScreen].bounds.size.width)) {
        xOffset = _pageControl.currentPage * [UIScreen mainScreen].bounds.size.width;
        CGPoint offset = scrollView.contentOffset;
        offset.x = xOffset;
        [scrollView setContentOffset:offset animated:NO];
    }
}

/*
-(void)addDownArrow {
    _downButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - 40, 30, 30) buttonType:buttonDownBasicType buttonStyle:buttonPlainStyle animateToInitialState:YES];
    _downButton.tintColor = [UIColor asbestosColor];
    [_downButton addTarget:self action:@selector(switchViews) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_downButton];
}
*/

-(void)addPlayerGamesGraph {
    
    TOMSMorphingLabel *label = [[TOMSMorphingLabel alloc]initWithFrame:CGRectMake(60, /*self.navigationController.navigationBar.frame.size.height +*/ 375, self.view.frame.size.width - 60 - 120, 45)];
    [_scrollView addSubview:label];
    label.font = [UIFont boldFlatFontOfSize:20.0f];
    label.textColor = [UIColor asbestosColor];
    label.text = @"Game Stats: ";
    
    TOMSMorphingLabel *playedLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(70, /*self.navigationController.navigationBar.frame.size.height +*/ 420, self.view.frame.size.width - 70 - 120, 25)];
    [_scrollView addSubview:playedLabel];
    playedLabel.textColor = [UIColor asbestosColor];
    NSString *playedLabelString = @"Played: ";
    playedLabelString = [playedLabelString stringByAppendingString:[[[_detailPlayer playerStats] playerGamesPlayed] stringValue]];
    playedLabel.text = playedLabelString;
    //playedLabel.text = [playedLabel.text stringByAppendingString:[[_detailPlayer playerSetsPlayed] stringValue]];
    
    TOMSMorphingLabel *wonLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(70, /*self.navigationController.navigationBar.frame.size.height +*/ 455, self.view.frame.size.width - 70 - 120, 25)];
    [_scrollView addSubview:wonLabel];
    wonLabel.textColor = [UIColor asbestosColor];
    NSString *wonLabelString = @"Won: ";
    wonLabelString = [wonLabelString stringByAppendingString:[[[_detailPlayer playerStats] playerGamesWon] stringValue]];
    wonLabel.text = wonLabelString;
    
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 120, /*self.navigationController.navigationBar.frame.size.height +*/ 375, 100, 100) items:@[[PNPieChartDataItem dataItemWithValue:[[[_detailPlayer playerStats] playerGamesWon] floatValue] color:[UIColor greenSeaColor] description:@"Games Won"], [PNPieChartDataItem dataItemWithValue:([[[_detailPlayer playerStats] playerGamesPlayed] floatValue] - [[[_detailPlayer playerStats] playerGamesWon] floatValue]) color:[UIColor alizarinColor] description:@"Games Lost"]]];
    pieChart.descriptionTextColor = [UIColor cloudsColor];
    pieChart.descriptionTextFont = [UIFont boldFlatFontOfSize:12.0f];
    [pieChart strokeChart];
    [_scrollView addSubview:pieChart];
    
}

-(void)addPlayerSetsGraph {
    
    TOMSMorphingLabel *label = [[TOMSMorphingLabel alloc]initWithFrame:CGRectMake(60, /*self.navigationController.navigationBar.frame.size.height +*/ 260, self.view.frame.size.width - 60 - 120, 45)];
    [_scrollView addSubview:label];
    label.font = [UIFont boldFlatFontOfSize:20.0f];
    label.textColor = [UIColor asbestosColor];
    label.text = @"Set Stats: ";
    
    TOMSMorphingLabel *playedLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(70, /*self.navigationController.navigationBar.frame.size.height +*/ 305, self.view.frame.size.width - 70 - 120, 25)];
    [_scrollView addSubview:playedLabel];
    playedLabel.textColor = [UIColor asbestosColor];
    NSString *playedLabelString = @"Played: ";
    playedLabelString = [playedLabelString stringByAppendingString:[[[_detailPlayer playerStats] playerSetsPlayed] stringValue]];
    playedLabel.text = playedLabelString;
    //playedLabel.text = [playedLabel.text stringByAppendingString:[[_detailPlayer playerSetsPlayed] stringValue]];
    
    TOMSMorphingLabel *wonLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(70, /*self.navigationController.navigationBar.frame.size.height +*/ 330, self.view.frame.size.width - 70 - 120, 25)];
    [_scrollView addSubview:wonLabel];
    wonLabel.textColor = [UIColor asbestosColor];
    NSString *wonLabelString = @"Won: ";
    wonLabelString = [wonLabelString stringByAppendingString:[[[_detailPlayer playerStats] playerSetsWon] stringValue]];
    wonLabel.text = wonLabelString;
    
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 120, /*self.navigationController.navigationBar.frame.size.height +*/ 260, 100, 100) items:@[[PNPieChartDataItem dataItemWithValue:[[[_detailPlayer playerStats] playerSetsWon] floatValue] color:[UIColor greenSeaColor] description:@"Sets Won"], [PNPieChartDataItem dataItemWithValue:([[[_detailPlayer playerStats] playerSetsPlayed] floatValue] - [[[_detailPlayer playerStats] playerSetsWon] floatValue]) color:[UIColor alizarinColor] description:@"Sets Lost"]]];
    pieChart.descriptionTextColor = [UIColor cloudsColor];
    pieChart.descriptionTextFont = [UIFont boldFlatFontOfSize:12.0f];
    [pieChart strokeChart];
    [_scrollView addSubview:pieChart];
    
}

-(void)addPlayerMatchesGraph {
    
    TOMSMorphingLabel *label = [[TOMSMorphingLabel alloc]initWithFrame:CGRectMake(60, /*self.navigationController.navigationBar.frame.size.height +*/ 145, self.view.frame.size.width - 60 - 120, 45)];
    [_scrollView addSubview:label];
    label.font = [UIFont boldFlatFontOfSize:20.0f];
    label.textColor = [UIColor asbestosColor];
    label.text = @"Match Stats: ";
    
    TOMSMorphingLabel *playedLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(70, /*self.navigationController.navigationBar.frame.size.height +*/ 190, self.view.frame.size.width - 70 - 120, 25)];
    [_scrollView addSubview:playedLabel];
    playedLabel.textColor = [UIColor asbestosColor];
    NSString *playedLabelString = @"Played: ";
    playedLabelString = [playedLabelString stringByAppendingString:[[[_detailPlayer playerStats] playerMatchesPlayed] stringValue]];
    playedLabel.text = playedLabelString;
    //playedLabel.text = [playedLabel.text stringByAppendingString:[[_detailPlayer playerSetsPlayed] stringValue]];
    
    TOMSMorphingLabel *wonLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(70, /*self.navigationController.navigationBar.frame.size.height +*/ 215, self.view.frame.size.width - 70 - 120, 25)];
    [_scrollView addSubview:wonLabel];
    wonLabel.textColor = [UIColor asbestosColor];
    NSString *wonLabelString = @"Won: ";
    wonLabelString = [wonLabelString stringByAppendingString:[[[_detailPlayer playerStats] playerMatchesWon] stringValue]];
    wonLabel.text = wonLabelString;
    
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 120, /*self.navigationController.navigationBar.frame.size.height +*/ 145, 100, 100) items:@[[PNPieChartDataItem dataItemWithValue:[[[_detailPlayer playerStats] playerMatchesWon] floatValue] color:[UIColor greenSeaColor] description:@"Mathes Won"], [PNPieChartDataItem dataItemWithValue:([[[_detailPlayer playerStats] playerMatchesPlayed] floatValue] - [[[_detailPlayer playerStats] playerMatchesWon] floatValue]) color:[UIColor alizarinColor] description:@"Matches Lost"]]];
    pieChart.descriptionTextColor = [UIColor cloudsColor];
    pieChart.descriptionTextFont = [UIFont boldFlatFontOfSize:12.0f];
    [pieChart strokeChart];
    [_scrollView addSubview:pieChart];
    
}

-(void)addServingStatistics {
    
    TOMSMorphingLabel *servingStatsLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(70, /*self.navigationController.navigationBar.frame.size.height +*/ 500, self.view.frame.size.width - 70 - 120, 45)];
    [_scrollView addSubview:servingStatsLabel];
    servingStatsLabel.font = [UIFont boldFlatFontOfSize:20.0f];
    servingStatsLabel.textColor = [UIColor asbestosColor];
    servingStatsLabel.text = @"Serving Stats: ";
    
    TOMSMorphingLabel *acesLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100, 545, 200, 25)];
    [_scrollView addSubview:acesLabel];
    acesLabel.textAlignment = NSTextAlignmentCenter;
    acesLabel.textColor = [UIColor asbestosColor];
    acesLabel.text = @"Aces:";
    
    TOMSMorphingLabel *acesWon = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100, 575, 200, 25)];
    [_scrollView addSubview:acesWon];
    acesWon.textAlignment = NSTextAlignmentCenter;
    acesWon.textColor = [UIColor asbestosColor];
    acesWon.text = [[[_detailPlayer playerStats] aces] stringValue];
    
    TOMSMorphingLabel *faultsLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100, 605, 200, 25)];
    [_scrollView addSubview:faultsLabel];
    faultsLabel.textAlignment = NSTextAlignmentCenter;
    faultsLabel.textColor = [UIColor asbestosColor];
    faultsLabel.text = @"Faults:";
    
    TOMSMorphingLabel *faults = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100, 635, 200, 25)];
    [_scrollView addSubview:faults];
    faults.textAlignment = NSTextAlignmentCenter;
    faults.textColor = [UIColor asbestosColor];
    faults.text = [[[_detailPlayer playerStats] faults] stringValue];
    
    TOMSMorphingLabel *doubleFaultsLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100, 665, 200, 25)];
    [_scrollView addSubview:doubleFaultsLabel];
    doubleFaultsLabel.textAlignment = NSTextAlignmentCenter;
    doubleFaultsLabel.textColor = [UIColor asbestosColor];
    doubleFaultsLabel.text = @"Double Faults:";
    
    TOMSMorphingLabel *doubleFaults = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100, 695, 200, 25)];
    [_scrollView addSubview:doubleFaults];
    doubleFaults.textAlignment = NSTextAlignmentCenter;
    doubleFaults.textColor = [UIColor asbestosColor];
    doubleFaults.text = [[[_detailPlayer playerStats] doubleFaults] stringValue];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
    
    TOMSMorphingLabel *firstServeLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100, 725, 200, 25)];
    [_scrollView addSubview:firstServeLabel];
    firstServeLabel.textAlignment = NSTextAlignmentCenter;
    firstServeLabel.textColor = [UIColor asbestosColor];
    firstServeLabel.text = @"First Serves Won:";
    
    TOMSMorphingLabel *firstServes = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100, 755, 200, 25)];
    [_scrollView addSubview:firstServes];
    firstServes.textAlignment = NSTextAlignmentCenter;
    firstServes.textColor = [UIColor asbestosColor];
    if ([[[_detailPlayer playerStats] servesMade] intValue] == 0) {
        firstServes.text = @"0%(0)";
    }
    else {
        float firstServePercentage = ([[[_detailPlayer playerStats] firstServesWon] floatValue] / [[[_detailPlayer playerStats] servesMade] floatValue]);// * 100;
        NSNumber *firstServePercentageNumber = [NSNumber numberWithFloat:firstServePercentage];
        NSString *firstServeString = [formatter stringFromNumber:firstServePercentageNumber];
        firstServeString = [firstServeString stringByAppendingString:@"("];
        firstServeString = [firstServeString stringByAppendingString:[[[_detailPlayer playerStats] firstServesWon] stringValue]];
        firstServeString = [firstServeString stringByAppendingString:@")"];
        firstServes.text = firstServeString;
    }
    
    TOMSMorphingLabel *secondServesLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100, 785, 200, 25)];
    [_scrollView addSubview:secondServesLabel];
    secondServesLabel.textAlignment = NSTextAlignmentCenter;
    secondServesLabel.textColor = [UIColor asbestosColor];
    secondServesLabel.text = @"Second Serves Won:";
    
    TOMSMorphingLabel *secondServes = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100, 815, 200, 25)];
    [_scrollView addSubview:secondServes];
    secondServes.textAlignment = NSTextAlignmentCenter;
    secondServes.textColor = [UIColor asbestosColor];
    if ([[[_detailPlayer playerStats] servesMade] intValue] == 0) {
        secondServes.text = @"0%(0)";
    }
    else {
        float secondServePercentage = ([[[_detailPlayer playerStats] secondServesWon] floatValue] / [[[_detailPlayer playerStats] servesMade] floatValue]);// * 100;
        NSNumber *secondServePercentageNumber = [NSNumber numberWithFloat:secondServePercentage];
        NSString *secondServeString = [formatter stringFromNumber:secondServePercentageNumber];
        secondServeString = [secondServeString stringByAppendingString:@"("];
        secondServeString = [secondServeString stringByAppendingString:[[[_detailPlayer playerStats] secondServesWon] stringValue]];
        secondServeString = [secondServeString stringByAppendingString:@")"];
        secondServes.text = secondServeString;
    }
    
    TOMSMorphingLabel *servesMadeLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100, 845, 200, 25)];
    [_scrollView addSubview:servesMadeLabel];
    servesMadeLabel.textAlignment = NSTextAlignmentCenter;
    servesMadeLabel.textColor = [UIColor asbestosColor];
    servesMadeLabel.text = @"Service Games Played";
    
    TOMSMorphingLabel *servesMade = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100, 875, 200, 25)];
    [_scrollView addSubview:servesMade];
    servesMade.textAlignment = NSTextAlignmentCenter;
    servesMade.textColor = [UIColor asbestosColor];
    servesMade.text = [[[_detailPlayer playerStats] servesMade] stringValue];
    
}

-(void)addOppositionGamesGraph:(Opponent*)opponent {
    
    float xOffset = _pageControl.currentPage * [UIScreen mainScreen].bounds.size.width;
    
    Stats *myStats = [opponent myTeamStats];
    Stats *theirStats = [opponent opposingTeamStats];
    
    TOMSMorphingLabel *label = [[TOMSMorphingLabel alloc]initWithFrame:CGRectMake(xOffset + 30, /*self.navigationController.navigationBar.frame.size.height +*/ 375, self.view.frame.size.width - 30 - 120, 45)];
    [_scrollView addSubview:label];
    label.font = [UIFont boldFlatFontOfSize:20.0f];
    label.textColor = [UIColor asbestosColor];
    label.text = @"Game Stats: ";
    
    TOMSMorphingLabel *playedLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + 45, /*self.navigationController.navigationBar.frame.size.height +*/ 420, self.view.frame.size.width - 45 - 120, 25)];
    [_scrollView addSubview:playedLabel];
    playedLabel.textAlignment = NSTextAlignmentLeft;
    playedLabel.textColor = [UIColor asbestosColor];
    //NSString *playedLabelString = @"Played: ";
    //playedLabelString = [playedLabelString stringByAppendingString:[[[_detailPlayer playerStats] playerGamesPlayed] stringValue]];
    //playedLabel.text = playedLabelString;
    playedLabel.text = [[myStats playerGamesWon] stringValue];
    
    TOMSMorphingLabel *wonLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width/2, /*self.navigationController.navigationBar.frame.size.height +*/ 420, self.view.frame.size.width/2 - 45, 25)];
    [_scrollView addSubview:wonLabel];
    wonLabel.textAlignment = NSTextAlignmentRight;
    wonLabel.textColor = [UIColor asbestosColor];
    wonLabel.text = [[theirStats playerGamesWon] stringValue];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(xOffset + 45, 465, [UIScreen mainScreen].bounds.size.width - 90, 30)];
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
    
    float xOffset = _pageControl.currentPage * [UIScreen mainScreen].bounds.size.width;
    
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
    
    float xOffset = _pageControl.currentPage * [UIScreen mainScreen].bounds.size.width;
    
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
    
    float xOffset = _pageControl.currentPage * [UIScreen mainScreen].bounds.size.width;
    
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
    acesWon.text = [[myTeamStats aces] stringValue];
    
    TOMSMorphingLabel *acesLost = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width - 45 - 120, 575, 120, 25)];
    [_scrollView addSubview:acesLost];
    acesLost.textAlignment = NSTextAlignmentRight;
    acesLost.textColor = [UIColor asbestosColor];
    acesLost.text = [[oppTeamStats aces] stringValue];
    
    TOMSMorphingLabel *faultsLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width / 2 - 100, 605, 200, 25)];
    [_scrollView addSubview:faultsLabel];
    faultsLabel.textAlignment = NSTextAlignmentCenter;
    faultsLabel.textColor = [UIColor asbestosColor];
    faultsLabel.text = @"Faults:";
    
    TOMSMorphingLabel *faults = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + 45, 635, 120, 25)];
    [_scrollView addSubview:faults];
    faults.textAlignment = NSTextAlignmentLeft;
    faults.textColor = [UIColor asbestosColor];
    faults.text = [[myTeamStats faults] stringValue];
    
    TOMSMorphingLabel *faultsLost = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width - 45 - 120, 635, 120, 25)];
    [_scrollView addSubview:faultsLost];
    faultsLost.textAlignment = NSTextAlignmentRight;
    faultsLost.textColor = [UIColor asbestosColor];
    faultsLost.text = [[oppTeamStats faults] stringValue];
    
    TOMSMorphingLabel *doubleFaultsLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width / 2 - 100, 665, 200, 25)];
    [_scrollView addSubview:doubleFaultsLabel];
    doubleFaultsLabel.textAlignment = NSTextAlignmentCenter;
    doubleFaultsLabel.textColor = [UIColor asbestosColor];
    doubleFaultsLabel.text = @"Double Faults:";
    
    TOMSMorphingLabel *doubleFaults = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + 45, 695, 120, 25)];
    [_scrollView addSubview:doubleFaults];
    doubleFaults.textAlignment = NSTextAlignmentLeft;
    doubleFaults.textColor = [UIColor asbestosColor];
    doubleFaults.text = [[myTeamStats doubleFaults] stringValue];
    
    TOMSMorphingLabel *doubleFaultsLost = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width - 45 - 120, 695, 120, 25)];
    [_scrollView addSubview:doubleFaultsLost];
    doubleFaultsLost.textAlignment = NSTextAlignmentRight;
    doubleFaultsLost.textColor = [UIColor asbestosColor];
    doubleFaultsLost.text = [[oppTeamStats doubleFaults] stringValue];
    
    TOMSMorphingLabel *firstServeLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width / 2 - 100, 725, 200, 25)];
    [_scrollView addSubview:firstServeLabel];
    firstServeLabel.textAlignment = NSTextAlignmentCenter;
    firstServeLabel.textColor = [UIColor asbestosColor];
    firstServeLabel.text = @"First Serves Won:";
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
    
    TOMSMorphingLabel *firstServes = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + 45, 755, 120, 25)];
    [_scrollView addSubview:firstServes];
    firstServes.textAlignment = NSTextAlignmentLeft;
    firstServes.textColor = [UIColor asbestosColor];
    float firstServePercentage = ([[myTeamStats firstServesWon] floatValue] / [[myTeamStats servesMade] floatValue]);// * 100;
    NSNumber *firstServePercentageNumber = [NSNumber numberWithFloat:firstServePercentage];
    NSString *firstStingValue = [formatter stringFromNumber:firstServePercentageNumber];//[firstServePercentageNumber stringValue];
    firstServes.text = firstStingValue;
    
    TOMSMorphingLabel *firstServesLost = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width - 45 - 120, 755, 120, 25)];
    [_scrollView addSubview:firstServesLost];
    firstServesLost.textAlignment = NSTextAlignmentRight;
    firstServesLost.textColor = [UIColor asbestosColor];
    float firstServePercentageLost = ([[oppTeamStats firstServesWon] floatValue] / [[oppTeamStats servesMade] floatValue]);// * 100;
    NSNumber *firstServePercentageNumberLost = [NSNumber numberWithFloat:firstServePercentageLost];
    NSString *firstLostStingValue = [formatter stringFromNumber:firstServePercentageNumberLost];//[firstServePercentageNumberLost stringValue];
    firstServesLost.text = firstLostStingValue;
    
    TOMSMorphingLabel *secondServesLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width / 2 - 100, 785, 200, 25)];
    [_scrollView addSubview:secondServesLabel];
    secondServesLabel.textAlignment = NSTextAlignmentCenter;
    secondServesLabel.textColor = [UIColor asbestosColor];
    secondServesLabel.text = @"Second Serves Won:";
    
    TOMSMorphingLabel *secondServes = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + 45, 815, 120, 25)];
    [_scrollView addSubview:secondServes];
    secondServes.textAlignment = NSTextAlignmentLeft;
    secondServes.textColor = [UIColor asbestosColor];
    float secondServePercentage = ([[myTeamStats secondServesWon] floatValue] / [[myTeamStats servesMade] floatValue]);// * 100;
    NSNumber *secondServePercentageNumber = [NSNumber numberWithFloat:secondServePercentage];
    NSString *secondStringValue = [formatter stringFromNumber:secondServePercentageNumber];//[secondServePercentageNumber stringValue];
    secondServes.text = secondStringValue;
    
    TOMSMorphingLabel *secondServesLost = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width - 45 - 120, 815, 120, 25)];
    [_scrollView addSubview:secondServesLost];
    secondServesLost.textAlignment = NSTextAlignmentRight;
    secondServesLost.textColor = [UIColor asbestosColor];
    float secondServePercentageLost = ([[oppTeamStats secondServesWon] floatValue] / [[oppTeamStats servesMade] floatValue]);// * 100;
    NSNumber *secondServePercentageNumberLost = [NSNumber numberWithFloat:secondServePercentageLost];
    NSString *secondLostStringValue = [formatter stringFromNumber:secondServePercentageNumberLost];//[secondServePercentageNumberLost stringValue];
    //secondLostStringValue = [secondLostStringValue stringByAppendingString:@"%"];
    secondServesLost.text = secondLostStringValue;
    
    completionhandler(true);
    
}

-(void)oppositionLayout:(NSInteger)page complete:(void (^)(bool complete))completionHandler {
    
    if ([_boolArray objectAtIndex:page-1] == nil) {
        [_boolArray insertObject:[NSNumber numberWithBool:true] atIndex:page-1];
    }
    else if ([[_boolArray objectAtIndex:page-1] boolValue]) {
        //page has already been loaded
        completionHandler(true);
        return;
    }
    
    float xOffset = page*[UIScreen mainScreen].bounds.size.width;
    
    Opponent *opponent = [[_detailPlayer opponents] objectAtIndex:page-1];
    
    UIView *myLineView = [[UIView alloc] initWithFrame:CGRectMake(xOffset + 20, 0, 5, _scrollView.contentSize.height)];
    myLineView.backgroundColor = [UIColor asbestosColor];
    [_scrollView addSubview:myLineView];
    
    UIView *oppLineView = [[UIView alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width - 25, 0, 5, _scrollView.contentSize.height)];
    oppLineView.backgroundColor = [UIColor asbestosColor];
    [_scrollView addSubview:oppLineView];
    
    Team *teamOne = [opponent myTeam];
    Team *teamTwo = [opponent opposingTeam];
    
    [teamOne setTeams];
    [teamTwo setTeams];
    
    int SCORESIZE = 60;
    
    float firstTeamPixelStart = self.navigationController.navigationBar.frame.size.height + 45;
    
    /* setup the first team */
    UIImageView *imageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset + 10, firstTeamPixelStart, 3*SCORESIZE/4, 3*SCORESIZE/4)];;
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
    
    UILabel *teamOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOffset + 3*SCORESIZE/4 + 25, firstTeamPixelStart, self.view.frame.size.width / 2 - 15 - SCORESIZE, SCORESIZE)];
    teamOneLabel.font = [UIFont boldFlatFontOfSize:20.0f];
    teamOneLabel.textAlignment = NSTextAlignmentLeft;
    teamOneLabel.lineBreakMode = NSLineBreakByWordWrapping;
    teamOneLabel.numberOfLines = 0;
    teamOneLabel.text = [[teamOne playerOne] playerName];
    if ([teamOne doubles]) {
        UIImageView *imageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset + SCORESIZE/2, firstTeamPixelStart + SCORESIZE/3, 3*SCORESIZE/4, 3*SCORESIZE/4)];
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
    UIImageView *imageViewThree = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width - 10 - 3*SCORESIZE/4, firstTeamPixelStart, 3*SCORESIZE/4, 3*SCORESIZE/4)];
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
    
    UILabel *teamTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width/2, firstTeamPixelStart, self.view.frame.size.width / 2 - 10  - SCORESIZE, SCORESIZE)];
    teamTwoLabel.font = [UIFont boldFlatFontOfSize:20.0f];
    teamTwoLabel.textAlignment = NSTextAlignmentRight;
    teamTwoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    teamTwoLabel.numberOfLines = 0;
    teamTwoLabel.text = [[teamTwo playerOne] playerName];
    if ([teamTwo doubles]) {
        UIImageView *imageViewFour = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset + [UIScreen mainScreen].bounds.size.width - 10 - 3*SCORESIZE/4 - SCORESIZE/2, SCORESIZE/3 + firstTeamPixelStart, 3*SCORESIZE/4, 3*SCORESIZE/4)];
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
    
    [self performSelector:@selector(addOppositionMatchesGraph:) withObject:opponent afterDelay:0.5];
    [self performSelector:@selector(addOppositionSetsGraph:) withObject:opponent afterDelay:1.0];
    [self performSelector:@selector(addOppositionGamesGraph:) withObject:opponent afterDelay:1.5];
    //[self performSelector:@selector(addOppositionStatistics:) withObject:opponent afterDelay:2.0];
    
    __weak typeof(self) weakSelf = self;
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        [self addOppositionStatistics:opponent complete:^(bool complete) {
            [weakSelf.boolArray insertObject:[NSNumber numberWithBool:true] atIndex:page-1];
            completionHandler(true);
        }];
    });
    
    //completionHandler(true);
    
}

-(void)savedPlayer {
    _nameLabel.text = [_detailPlayer playerName];
    _lastNameLabel.text = [_detailPlayer playerLastName];
    if ([_detailPlayer playerImage]) {
        _imageView.image = [UIImage imageWithData:[_detailPlayer playerImage]];
    }
}

-(void)editPlayer {
    NewPlayerViewController *newPlayer = [[NewPlayerViewController alloc] init];
    newPlayer.thisParentViewController = self;
    newPlayer.editPlayer = _detailPlayer;
    
    [self mz_presentFormSheetWithViewController:newPlayer animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        //up up
    }];
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
