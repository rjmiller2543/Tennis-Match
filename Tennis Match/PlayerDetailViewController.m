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

@interface PlayerDetailViewController ()

@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,retain) UIImageView *imageView;
@property(nonatomic,retain) UILabel *nameLabel;
@property(nonatomic,retain) UILabel *lastNameLabel;

@end

@implementation PlayerDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cloudsColor];
    [self configureView];
    
    [self performSelector:@selector(addPlayerMatchesGraph) withObject:nil afterDelay:0.5];
    [self performSelector:@selector(addPlayerSetsGraph) withObject:nil afterDelay:1.0];
    [self performSelector:@selector(addPlayerGamesGraph) withObject:nil afterDelay:1.5];
    
}

-(void)configureView {
    
    self.title = [_detailPlayer playerName];
    //[self.navigationController setTitle:@"Player"];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPlayer)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_scrollView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 5, self.view.frame.size.height)];
    lineView.backgroundColor = [UIColor asbestosColor];
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
    playedLabelString = [playedLabelString stringByAppendingString:[[_detailPlayer playerGamesPlayed] stringValue]];
    playedLabel.text = playedLabelString;
    //playedLabel.text = [playedLabel.text stringByAppendingString:[[_detailPlayer playerSetsPlayed] stringValue]];
    
    TOMSMorphingLabel *wonLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(70, /*self.navigationController.navigationBar.frame.size.height +*/ 455, self.view.frame.size.width - 70 - 120, 25)];
    [_scrollView addSubview:wonLabel];
    wonLabel.textColor = [UIColor asbestosColor];
    NSString *wonLabelString = @"Won: ";
    wonLabelString = [wonLabelString stringByAppendingString:[[_detailPlayer playerGamesWon] stringValue]];
    wonLabel.text = wonLabelString;
    
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 120, /*self.navigationController.navigationBar.frame.size.height +*/ 375, 100, 100) items:@[[PNPieChartDataItem dataItemWithValue:[[_detailPlayer playerGamesWon] floatValue] color:[UIColor greenSeaColor] description:@"Games Won"], [PNPieChartDataItem dataItemWithValue:([[_detailPlayer playerGamesPlayed] floatValue] - [[_detailPlayer playerGamesWon] floatValue]) color:[UIColor alizarinColor] description:@"Games Lost"]]];
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
    playedLabelString = [playedLabelString stringByAppendingString:[[_detailPlayer playerSetsPlayed] stringValue]];
    playedLabel.text = playedLabelString;
    //playedLabel.text = [playedLabel.text stringByAppendingString:[[_detailPlayer playerSetsPlayed] stringValue]];
    
    TOMSMorphingLabel *wonLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(70, /*self.navigationController.navigationBar.frame.size.height +*/ 330, self.view.frame.size.width - 70 - 120, 25)];
    [_scrollView addSubview:wonLabel];
    wonLabel.textColor = [UIColor asbestosColor];
    NSString *wonLabelString = @"Won: ";
    wonLabelString = [wonLabelString stringByAppendingString:[[_detailPlayer playerSetsWon] stringValue]];
    wonLabel.text = wonLabelString;
    
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 120, /*self.navigationController.navigationBar.frame.size.height +*/ 260, 100, 100) items:@[[PNPieChartDataItem dataItemWithValue:[[_detailPlayer playerSetsWon] floatValue] color:[UIColor greenSeaColor] description:@"Sets Won"], [PNPieChartDataItem dataItemWithValue:([[_detailPlayer playerSetsPlayed] floatValue] - [[_detailPlayer playerSetsWon] floatValue]) color:[UIColor alizarinColor] description:@"Sets Lost"]]];
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
    playedLabelString = [playedLabelString stringByAppendingString:[[_detailPlayer playerMatchesPlayed] stringValue]];
    playedLabel.text = playedLabelString;
    //playedLabel.text = [playedLabel.text stringByAppendingString:[[_detailPlayer playerSetsPlayed] stringValue]];
    
    TOMSMorphingLabel *wonLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(70, /*self.navigationController.navigationBar.frame.size.height +*/ 215, self.view.frame.size.width - 70 - 120, 25)];
    [_scrollView addSubview:wonLabel];
    wonLabel.textColor = [UIColor asbestosColor];
    NSString *wonLabelString = @"Won: ";
    wonLabelString = [wonLabelString stringByAppendingString:[[_detailPlayer playerMatchesWon] stringValue]];
    wonLabel.text = wonLabelString;
    
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 120, /*self.navigationController.navigationBar.frame.size.height +*/ 145, 100, 100) items:@[[PNPieChartDataItem dataItemWithValue:[[_detailPlayer playerMatchesWon] floatValue] color:[UIColor greenSeaColor] description:@"Mathes Won"], [PNPieChartDataItem dataItemWithValue:([[_detailPlayer playerMatchesPlayed] floatValue] - [[_detailPlayer playerMatchesWon] floatValue]) color:[UIColor alizarinColor] description:@"Matches Lost"]]];
    pieChart.descriptionTextColor = [UIColor cloudsColor];
    pieChart.descriptionTextFont = [UIFont boldFlatFontOfSize:12.0f];
    [pieChart strokeChart];
    [_scrollView addSubview:pieChart];
    
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
