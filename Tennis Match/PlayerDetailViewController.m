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

@interface PlayerDetailViewController ()

@property(nonatomic,retain) UIScrollView *scrollView;

@end

@implementation PlayerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cloudsColor];
    self.title = [_detailPlayer playerName];
    [self.navigationController setTitle:@"Player"];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 5, self.view.frame.size.height)];
    lineView.backgroundColor = [UIColor asbestosColor];
    [self.view addSubview:lineView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.navigationController.navigationBar.frame.size.height + 45, 90, 90)];
    imageView.backgroundColor = [UIColor cloudsColor];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 45;
    imageView.layer.borderWidth = 5;
    imageView.layer.borderColor = [[UIColor asbestosColor] CGColor];
    if ([_detailPlayer playerImage]) {
        imageView.image = [UIImage imageWithData:[_detailPlayer playerImage]];
    }
    else {
        imageView.image = [UIImage imageNamed:@"no-player-image.png"];
        imageView.userInteractionEnabled = YES;
        UIButton *newPhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
        [newPhotoButton addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:newPhotoButton];
    }
    [self.view addSubview:imageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, self.navigationController.navigationBar.frame.size.height + 45, self.view.frame.size.width - 110, 45)];
    nameLabel.text = [_detailPlayer playerName];
    nameLabel.font = [UIFont boldFlatFontOfSize:22.0f];
    [self.view addSubview:nameLabel];
    
    UILabel *lastNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, self.navigationController.navigationBar.frame.size.height + 90, self.view.frame.size.width - 110, 45)];
    lastNameLabel.text = [_detailPlayer playerLastName];
    lastNameLabel.font = [UIFont boldFlatFontOfSize:22.0f];
    [self.view addSubview:lastNameLabel];
    
    [self performSelector:@selector(addPlayerMatchesGraph) withObject:nil afterDelay:0.5];
    [self performSelector:@selector(addPlayerSetsGraph) withObject:nil afterDelay:1.0];
    [self performSelector:@selector(addPlayerGamesGraph) withObject:nil afterDelay:1.5];
}

-(void)addPlayerGamesGraph {
    
    TOMSMorphingLabel *label = [[TOMSMorphingLabel alloc]initWithFrame:CGRectMake(60, self.navigationController.navigationBar.frame.size.height + 375, self.view.frame.size.width - 60 - 120, 45)];
    [self.view addSubview:label];
    label.font = [UIFont boldFlatFontOfSize:20.0f];
    label.textColor = [UIColor asbestosColor];
    label.text = @"Game Statistics: ";
    
    TOMSMorphingLabel *playedLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(70, self.navigationController.navigationBar.frame.size.height + 420, self.view.frame.size.width - 70 - 120, 25)];
    [self.view addSubview:playedLabel];
    playedLabel.textColor = [UIColor asbestosColor];
    NSString *playedLabelString = @"Played: ";
    playedLabelString = [playedLabelString stringByAppendingString:[[_detailPlayer playerGamesPlayed] stringValue]];
    playedLabel.text = playedLabelString;
    //playedLabel.text = [playedLabel.text stringByAppendingString:[[_detailPlayer playerSetsPlayed] stringValue]];
    
    TOMSMorphingLabel *wonLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(70, self.navigationController.navigationBar.frame.size.height + 455, self.view.frame.size.width - 70 - 120, 25)];
    [self.view addSubview:wonLabel];
    wonLabel.textColor = [UIColor asbestosColor];
    NSString *wonLabelString = @"Won: ";
    wonLabelString = [wonLabelString stringByAppendingString:[[_detailPlayer playerGamesWon] stringValue]];
    wonLabel.text = wonLabelString;
    
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 120, self.navigationController.navigationBar.frame.size.height + 375, 100, 100) items:@[[PNPieChartDataItem dataItemWithValue:[[_detailPlayer playerGamesWon] floatValue] color:[UIColor greenSeaColor] description:@"Games Won"], [PNPieChartDataItem dataItemWithValue:([[_detailPlayer playerGamesPlayed] floatValue] - [[_detailPlayer playerGamesWon] floatValue]) color:[UIColor alizarinColor] description:@"Games Lost"]]];
    pieChart.descriptionTextColor = [UIColor cloudsColor];
    pieChart.descriptionTextFont = [UIFont boldFlatFontOfSize:12.0f];
    [pieChart strokeChart];
    [self.view addSubview:pieChart];
    
}

-(void)addPlayerSetsGraph {
    
    TOMSMorphingLabel *label = [[TOMSMorphingLabel alloc]initWithFrame:CGRectMake(60, self.navigationController.navigationBar.frame.size.height + 260, self.view.frame.size.width - 60 - 120, 45)];
    [self.view addSubview:label];
    label.font = [UIFont boldFlatFontOfSize:20.0f];
    label.textColor = [UIColor asbestosColor];
    label.text = @"Set Statistics: ";
    
    TOMSMorphingLabel *playedLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(70, self.navigationController.navigationBar.frame.size.height + 305, self.view.frame.size.width - 70 - 120, 25)];
    [self.view addSubview:playedLabel];
    playedLabel.textColor = [UIColor asbestosColor];
    NSString *playedLabelString = @"Played: ";
    playedLabelString = [playedLabelString stringByAppendingString:[[_detailPlayer playerSetsPlayed] stringValue]];
    playedLabel.text = playedLabelString;
    //playedLabel.text = [playedLabel.text stringByAppendingString:[[_detailPlayer playerSetsPlayed] stringValue]];
    
    TOMSMorphingLabel *wonLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(70, self.navigationController.navigationBar.frame.size.height + 330, self.view.frame.size.width - 70 - 120, 25)];
    [self.view addSubview:wonLabel];
    wonLabel.textColor = [UIColor asbestosColor];
    NSString *wonLabelString = @"Won: ";
    wonLabelString = [wonLabelString stringByAppendingString:[[_detailPlayer playerSetsWon] stringValue]];
    wonLabel.text = wonLabelString;
    
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 120, self.navigationController.navigationBar.frame.size.height + 260, 100, 100) items:@[[PNPieChartDataItem dataItemWithValue:[[_detailPlayer playerSetsWon] floatValue] color:[UIColor greenSeaColor] description:@"Sets Won"], [PNPieChartDataItem dataItemWithValue:([[_detailPlayer playerSetsPlayed] floatValue] - [[_detailPlayer playerSetsWon] floatValue]) color:[UIColor alizarinColor] description:@"Sets Lost"]]];
    pieChart.descriptionTextColor = [UIColor cloudsColor];
    pieChart.descriptionTextFont = [UIFont boldFlatFontOfSize:12.0f];
    [pieChart strokeChart];
    [self.view addSubview:pieChart];
    
}

-(void)addPlayerMatchesGraph {
    
    TOMSMorphingLabel *label = [[TOMSMorphingLabel alloc]initWithFrame:CGRectMake(60, self.navigationController.navigationBar.frame.size.height + 145, self.view.frame.size.width - 60 - 120, 45)];
    [self.view addSubview:label];
    label.font = [UIFont boldFlatFontOfSize:20.0f];
    label.textColor = [UIColor asbestosColor];
    label.text = @"Match Statistics: ";
    
    TOMSMorphingLabel *playedLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(70, self.navigationController.navigationBar.frame.size.height + 190, self.view.frame.size.width - 70 - 120, 25)];
    [self.view addSubview:playedLabel];
    playedLabel.textColor = [UIColor asbestosColor];
    NSString *playedLabelString = @"Played: ";
    playedLabelString = [playedLabelString stringByAppendingString:[[_detailPlayer playerMatchesPlayed] stringValue]];
    playedLabel.text = playedLabelString;
    //playedLabel.text = [playedLabel.text stringByAppendingString:[[_detailPlayer playerSetsPlayed] stringValue]];
    
    TOMSMorphingLabel *wonLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(70, self.navigationController.navigationBar.frame.size.height + 215, self.view.frame.size.width - 70 - 120, 25)];
    [self.view addSubview:wonLabel];
    wonLabel.textColor = [UIColor asbestosColor];
    NSString *wonLabelString = @"Won: ";
    wonLabelString = [wonLabelString stringByAppendingString:[[_detailPlayer playerMatchesWon] stringValue]];
    wonLabel.text = wonLabelString;
    
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 120, self.navigationController.navigationBar.frame.size.height + 145, 100, 100) items:@[[PNPieChartDataItem dataItemWithValue:[[_detailPlayer playerMatchesWon] floatValue] color:[UIColor greenSeaColor] description:@"Mathes Won"], [PNPieChartDataItem dataItemWithValue:([[_detailPlayer playerMatchesPlayed] floatValue] - [[_detailPlayer playerMatchesWon] floatValue]) color:[UIColor alizarinColor] description:@"Matches Lost"]]];
    pieChart.descriptionTextColor = [UIColor cloudsColor];
    pieChart.descriptionTextFont = [UIFont boldFlatFontOfSize:12.0f];
    [pieChart strokeChart];
    [self.view addSubview:pieChart];
    
}

-(void)addPhoto:(id)sender {
    
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
