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
#import <GraphKit.h>

@interface PlayerDetailViewController () <GKBarGraphDataSource>

@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,retain) UIImageView *imageView;
@property(nonatomic,retain) UILabel *nameLabel;
@property(nonatomic,retain) UILabel *lastNameLabel;

@property(nonatomic,retain) UIView *bottomView;
@property(nonatomic,retain) VBFPopFlatButton *downButton;

@property(nonatomic,retain) GRKBarGraphView *aces;

@property(nonatomic) BOOL isUp;

@end

@implementation PlayerDetailViewController

@synthesize aces;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cloudsColor];
    
    [self configureView];
    
    _isUp = true;
    
    [self performSelector:@selector(addPlayerMatchesGraph) withObject:nil afterDelay:0.5];
    [self performSelector:@selector(addPlayerSetsGraph) withObject:nil afterDelay:1.0];
    [self performSelector:@selector(addPlayerGamesGraph) withObject:nil afterDelay:1.5];
    [self performSelector:@selector(addDownArrow) withObject:nil afterDelay:2.0];
    
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
    [self.view addSubview:_scrollView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 5, self.view.frame.size.height)];
    lineView.backgroundColor = [UIColor asbestosColor];
    //[_scrollView addSubview:lineView];
    [self.view addSubview:lineView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.navigationController.navigationBar.frame.size.height + 45, 90, 90)];
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
    [self.view addSubview:_imageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, self.navigationController.navigationBar.frame.size.height + 45, self.view.frame.size.width - 110, 45)];
    _nameLabel.text = [_detailPlayer playerName];
    _nameLabel.font = [UIFont boldFlatFontOfSize:22.0f];
    [self.view addSubview:_nameLabel];
    
    _lastNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, self.navigationController.navigationBar.frame.size.height + 90, self.view.frame.size.width - 110, 45)];
    _lastNameLabel.text = [_detailPlayer playerLastName];
    _lastNameLabel.font = [UIFont boldFlatFontOfSize:22.0f];
    [self.view addSubview:_lastNameLabel];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    _bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bottomView];
    
}

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

-(void)addDownArrow {
    _downButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - 40, 30, 30) buttonType:buttonDownBasicType buttonStyle:buttonPlainStyle animateToInitialState:YES];
    _downButton.tintColor = [UIColor asbestosColor];
    [_downButton addTarget:self action:@selector(switchViews) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_downButton];
}

-(void)addPlayerGamesGraph {
    
    TOMSMorphingLabel *label = [[TOMSMorphingLabel alloc]initWithFrame:CGRectMake(60, /*self.navigationController.navigationBar.frame.size.height +*/ 375, self.view.frame.size.width - 60 - 120, 45)];
    [_scrollView addSubview:label];
    label.font = [UIFont boldFlatFontOfSize:20.0f];
    label.textColor = [UIColor asbestosColor];
    label.text = @"Game Statistics: ";
    
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
    label.text = @"Set Statistics: ";
    
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
    label.text = @"Match Statistics: ";
    
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

-(void)bottomLayout {
    
    UIScrollView *statsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height + 145, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height)];
    [statsScrollView setContentSize:CGSizeMake(([[_detailPlayer opponents] count]+1)*self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height)];
    [_bottomView addSubview:statsScrollView];
    
    TOMSMorphingLabel *acesWon = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
    [acesWon setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.navigationController.navigationBar.frame.size.height + 145)];
    acesWon.textAlignment = NSTextAlignmentCenter;
    //[statsScrollView addSubview:acesWon];
    acesWon.textColor = [UIColor asbestosColor];
    NSString *acesWonString = @"Ace %";
    acesWon.text = acesWonString;
    
    UIView *view = [[UIView alloc] init];
    view.transform = CGAffineTransformMakeRotation(90 * M_PI / 180);
    view.backgroundColor = [UIColor greenColor];
    //view.backgroundColor = [UIColor blackColor];
    [statsScrollView addSubview:view];
    
    /*
    GKBarGraph *barGraph = [[GKBarGraph alloc] init];
    //barGraph.transform = CGAffineTransformMakeRotation(90 * M_PI / 180);
    [barGraph setFrame:CGRectMake(0, 0, self.view.frame.size.width - 160, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 145)];
    barGraph.barHeight = self.view.frame.size.width - 105;
    barGraph.barWidth = 30;
    barGraph.marginBar = 45;
    barGraph.transform = CGAffineTransformMakeRotation(90 * M_PI / 180);
    barGraph.dataSource = self;
    [view addSubview:barGraph];
    
    [barGraph draw];
     */
    aces = [[GRKBarGraphView alloc] init];
    [statsScrollView addSubview:aces];
    [aces setFrame:CGRectMake(100, 200, 200, 30)];
    aces.percent = 0.5;
}

-(NSInteger)numberOfBars {
    return 5;
}

-(NSNumber *)valueForBarAtIndex:(NSInteger)index {
    float up = 0;
    if ([[[_detailPlayer playerStats] servesMade] intValue] == 0) {
        return 0;
    }
    else {
        switch (index) {
            case 0:
                up = 100 * [[[_detailPlayer playerStats] aces] floatValue] / [[[_detailPlayer playerStats] servesMade] floatValue];
                break;
            case 1:
                up = 100 * [[[_detailPlayer playerStats] faults] floatValue] / [[[_detailPlayer playerStats] servesMade] floatValue];
                break;
            case 2:
                up = 100 * [[[_detailPlayer playerStats] doubleFaults] floatValue] / [[[_detailPlayer playerStats] servesMade] floatValue];
                break;
            case 3:
                up = 100 * [[[_detailPlayer playerStats] firstServesWon] floatValue] / [[[_detailPlayer playerStats] servesMade] floatValue];
                break;
            case 4:
                up = 100 * [[[_detailPlayer playerStats] secondServesWon] floatValue] / [[[_detailPlayer playerStats] servesMade] floatValue];
                break;
            
            default:
                break;
        }
    }
    
    return [NSNumber numberWithFloat:up];
}

-(NSString *)titleForBarAtIndex:(NSInteger)index {
    return @"";
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
