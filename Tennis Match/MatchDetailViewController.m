//
//  MatchDetailViewController.m
//  Tennis Match
//
//  Created by Robert Miller on 4/19/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "MatchDetailViewController.h"
#import <FlatUIKit.h>
#import "Set.h"
#import "Game.h"

@interface MatchDetailViewController ()

@property(nonatomic,retain) NSArray *setsArray;

@end

@implementation MatchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cloudsColor];
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(5, self.navigationController.navigationBar.bounds.size.height + 22, [UIScreen mainScreen].bounds.size.width - 10, 130)];
    containerView.backgroundColor = [UIColor cloudsColor];
    containerView.layer.cornerRadius = 10;
    [self.view addSubview:containerView];
    
    float SCORESIZE = 58;
    float secondTeamPixelStart = 63;
    float firstTeamPixelStart = 5;
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        SCORESIZE = 48;
        secondTeamPixelStart = 63;
        firstTeamPixelStart = 17;
    }
    
    Team *teamOne = [_detailMatch teamOne];
    Team *teamTwo = [_detailMatch teamTwo];
    
    [teamOne setTeams];
    [teamTwo setTeams];
    
    /* setup the first team */
    UIImageView *imageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(5, firstTeamPixelStart, 3*SCORESIZE/4, 3*SCORESIZE/4)];;
    imageViewOne.contentMode = UIViewContentModeScaleAspectFit;
    imageViewOne.layer.cornerRadius = 3*SCORESIZE/8;
    imageViewOne.layer.borderColor = [[UIColor grayColor] CGColor];
    imageViewOne.layer.borderWidth = 2.0;
    imageViewOne.layer.masksToBounds = YES;
    imageViewOne.image = [UIImage imageNamed:@"no-player-image.png"];
    if ([[teamOne playerOne] playerImage]) {
        imageViewOne.image = [UIImage imageWithData:[[teamOne playerOne] playerImage]];
    }
    [containerView addSubview:imageViewOne];
    
    UILabel *teamOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(3*SCORESIZE/4 + 25, firstTeamPixelStart, self.view.frame.size.width / 2 - 15 - SCORESIZE, SCORESIZE)];
    teamOneLabel.font = [UIFont boldFlatFontOfSize:20.0f];
    teamOneLabel.textAlignment = NSTextAlignmentRight;
    teamOneLabel.lineBreakMode = NSLineBreakByWordWrapping;
    teamOneLabel.numberOfLines = 0;
    teamOneLabel.text = [[teamOne playerOne] playerName];
    if ([[_detailMatch doubles] boolValue]) {
        UIImageView *imageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(SCORESIZE/2, firstTeamPixelStart + SCORESIZE/3, 3*SCORESIZE/4, 3*SCORESIZE/4)];
        imageViewTwo.contentMode = UIViewContentModeScaleAspectFit;
        imageViewTwo.layer.cornerRadius = (3*SCORESIZE/4)/2;
        imageViewTwo.layer.borderWidth = 2.0;
        imageViewTwo.layer.borderColor = [[UIColor grayColor] CGColor];
        imageViewTwo.layer.masksToBounds = YES;
        imageViewTwo.image = [UIImage imageNamed:@"no-player-image.png"];
        if ([[teamOne playerTwo] playerImage]) {
            imageViewTwo.image = [UIImage imageWithData:[[teamOne playerTwo] playerImage]];
        }
        [containerView addSubview:imageViewTwo];
        
        teamOneLabel.text = [teamOneLabel.text stringByAppendingString:@" & "];
        teamOneLabel.text = [teamOneLabel.text stringByAppendingString:[[teamOne playerTwo] playerName]];
    }
    [containerView addSubview:teamOneLabel];
    
    /* setup team two stuff */
    UIImageView *imageViewThree = [[UIImageView alloc] initWithFrame:CGRectMake(5, secondTeamPixelStart, 3*SCORESIZE/4, 3*SCORESIZE/4)];
    imageViewThree.contentMode = UIViewContentModeScaleAspectFit;
    imageViewThree.layer.cornerRadius = 3*SCORESIZE/8;
    imageViewThree.layer.borderColor = [[UIColor grayColor] CGColor];
    imageViewThree.layer.borderWidth = 2.0;
    imageViewThree.layer.masksToBounds = YES;
    imageViewThree.image = [UIImage imageNamed:@"no-player-image.png"];
    if ([[teamTwo playerOne] playerImage]) {
        imageViewThree.image = [UIImage imageWithData:[[teamTwo playerOne] playerImage]];
    }
    [containerView addSubview:imageViewThree];
    
    UILabel *teamTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(3*SCORESIZE/4 + 25, secondTeamPixelStart, self.view.frame.size.width / 2 - 15  - SCORESIZE, SCORESIZE)];
    teamTwoLabel.font = [UIFont boldFlatFontOfSize:20.0f];
    teamTwoLabel.textAlignment = NSTextAlignmentRight;
    teamTwoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    teamTwoLabel.numberOfLines = 0;
    teamTwoLabel.text = [[teamTwo playerOne] playerName];
    if ([[_detailMatch doubles] boolValue]) {
        UIImageView *imageViewFour = [[UIImageView alloc] initWithFrame:CGRectMake(SCORESIZE/2, SCORESIZE/3 + secondTeamPixelStart, 3*SCORESIZE/4, 3*SCORESIZE/4)];
        imageViewFour.contentMode = UIViewContentModeScaleAspectFit;
        imageViewFour.layer.cornerRadius = 3*SCORESIZE/8;
        imageViewFour.layer.borderWidth = 2.0;
        imageViewFour.layer.borderColor = [[UIColor grayColor] CGColor];
        imageViewFour.layer.masksToBounds = YES;
        imageViewFour.image = [UIImage imageNamed:@"no-player-image.png"];
        if ([[teamTwo playerTwo] playerImage]) {
            imageViewFour.image = [UIImage imageWithData:[[teamTwo playerTwo] playerImage]];
        }
        [containerView addSubview:imageViewFour];
        
        teamTwoLabel.text = [teamTwoLabel.text stringByAppendingString:@" & "];
        teamTwoLabel.text = [teamTwoLabel.text stringByAppendingString:[[teamTwo playerTwo] playerName]];
    }
    [containerView addSubview:teamTwoLabel];
    
    _setsArray = [_detailMatch sets];
    for (int i = 0; i < [_setsArray count]; i++) {
        
        UITextField *textFieldOne = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + SCORESIZE*i, firstTeamPixelStart, SCORESIZE, SCORESIZE)];
        textFieldOne.borderStyle = UITextBorderStyleLine;
        textFieldOne.textAlignment = NSTextAlignmentCenter;
        textFieldOne.text = [[[_setsArray objectAtIndex:i] teamOneScore] stringValue];
        [containerView addSubview:textFieldOne];
        
        UITextField *textFieldTwo = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + SCORESIZE*i, SCORESIZE + firstTeamPixelStart, SCORESIZE, SCORESIZE)];
        textFieldTwo.borderStyle = UITextBorderStyleLine;
        textFieldTwo.textAlignment = NSTextAlignmentCenter;
        textFieldTwo.text = [[[_setsArray objectAtIndex:i] teamTwoScore] stringValue];
        [containerView addSubview:textFieldTwo];
        
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 220, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 220)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_tableView.backgroundColor = [UIColor alizarinColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    CAGradientLayer *tableViewLayer = [CAGradientLayer layer];
    tableViewLayer.frame = _tableView.frame;
    NSArray *locations = @[[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0.25], [NSNumber numberWithFloat:0.6], [NSNumber numberWithFloat:0.75], [NSNumber numberWithFloat:1.0]];
    tableViewLayer.locations = locations;
    tableViewLayer.colors = @[(id)[[UIColor whiteColor] CGColor], (id)[[UIColor cloudsColor] CGColor], (id)[[UIColor alizarinColor] CGColor]];
    [_tableView.layer insertSublayer:tableViewLayer atIndex:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    [self configureCell:cell withIndex:indexPath];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_setsArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"will display cell");
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)configureCell:(UITableViewCell *)cell withIndex:(NSIndexPath *)indexPath {
    //Add team one label to the cell
    cell.backgroundColor = [UIColor cloudsColor];
    
    int CELLHEIGHT = 120;
    int GAMESIZE = 30;
    
    //draw a vertical line bc it looks pretty
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(GAMESIZE/2 + 5, 0, 2, CELLHEIGHT)];
    line.backgroundColor = [UIColor grayColor];
    [cell addSubview:line];
    
    UILabel *setLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, cell.frame.size.width / 2, GAMESIZE)];
    setLabel.text = @"Set ";
    setLabel.text = [setLabel.text stringByAppendingString:[[NSNumber numberWithInteger:(indexPath.row + 1)] stringValue]];
    setLabel.font = [UIFont boldFlatFontOfSize:22.0f];
    setLabel.backgroundColor = [UIColor cloudsColor];
    [cell addSubview:setLabel];
    
    /*    UIImageView *playerOneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, SCORESIZE, 2*SCORESIZE/3, 2*SCORESIZE/3)];
     playerOneImageView.image = [UIImage imageNamed:@"no-player-image.png"];
     playerOneImageView.layer.cornerRadius = (2*SCORESIZE/3)/2;
     playerOneImageView.layer.masksToBounds = YES;
     playerOneImageView.layer.borderWidth = 1.0;
     playerOneImageView.layer.borderColor = [[UIColor grayColor] CGColor];
     playerOneImageView.backgroundColor = [UIColor lightGrayColor];
     [cell addSubview:playerOneImageView];
     */
    
    UILabel *teamOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(GAMESIZE, GAMESIZE, cell.frame.size.width / 2 - 10 - GAMESIZE, GAMESIZE)];
    teamOneLabel.font = [UIFont boldFlatFontOfSize:16.0f];
    teamOneLabel.textAlignment = NSTextAlignmentRight;
    teamOneLabel.lineBreakMode = NSLineBreakByWordWrapping;
    teamOneLabel.numberOfLines = 0;
    teamOneLabel.text = [[[_detailMatch teamOne] playerOne] playerName];
    if ([[_detailMatch doubles] boolValue]) {
        teamOneLabel.text = [teamOneLabel.text stringByAppendingString:@" & "];
        teamOneLabel.text = [teamOneLabel.text stringByAppendingString:[[[_detailMatch teamOne] playerTwo] playerName]];
    }
    [cell addSubview:teamOneLabel];
    
    /*    UIImageView *playerTwoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, SCORESIZE*2, 2*SCORESIZE/3, 2*SCORESIZE/3)];
     playerTwoImageView.image = [UIImage imageNamed:@"no-player-image.png"];
     playerTwoImageView.layer.cornerRadius = (2*SCORESIZE/3)/2;
     playerTwoImageView.layer.masksToBounds = YES;
     playerTwoImageView.layer.borderWidth = 1.0;
     playerTwoImageView.layer.borderColor = [[UIColor grayColor] CGColor];
     playerTwoImageView.backgroundColor = [UIColor lightGrayColor];
     [cell addSubview:playerTwoImageView];
     */
    
    //Add team two label to the cell
    UILabel *teamTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(GAMESIZE, GAMESIZE*2, cell.frame.size.width / 2 - 10 - GAMESIZE, GAMESIZE)];
    teamTwoLabel.font = [UIFont boldFlatFontOfSize:16.0f];
    teamTwoLabel.textAlignment = NSTextAlignmentRight;
    teamTwoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    teamTwoLabel.numberOfLines = 0;
    teamTwoLabel.text = [[[_detailMatch teamTwo] playerOne] playerName];
    if ([[_detailMatch doubles] boolValue]) {
        teamTwoLabel.text = [teamTwoLabel.text stringByAppendingString:@" & "];
        teamTwoLabel.text = [teamTwoLabel.text stringByAppendingString:[[[_detailMatch teamTwo] playerTwo] playerName]];
    }
    [cell addSubview:teamTwoLabel];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, 0, cell.frame.size.width / 2, GAMESIZE*3)];
    [cell addSubview:scrollView];
    
    Set *tmp = [_setsArray objectAtIndex:indexPath.row];
    
    if ([[tmp games] count] != 0) {
        for (int i = 0; i < [[tmp games] count]; i++) {
            Game *game = [[tmp games] objectAtIndex:i];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(GAMESIZE*i, 0, GAMESIZE, GAMESIZE)];
            label.text = [[NSNumber numberWithInt:(i+1)] stringValue];
            label.textAlignment = NSTextAlignmentCenter;
            [scrollView addSubview:label];
            
            UITextField *textFieldOne = [[UITextField alloc] initWithFrame:CGRectMake(GAMESIZE*i, GAMESIZE, GAMESIZE, GAMESIZE)];
            textFieldOne.borderStyle = UITextBorderStyleLine;
            textFieldOne.textAlignment = NSTextAlignmentCenter;
            [textFieldOne setEnabled:NO];
            if ([[game teamOneScore] intValue] > 40) {
                textFieldOne.text = @"Ad.";
            }
            else {
                textFieldOne.text = [[game teamOneScore] stringValue];
            }
            UITextField *textFieldTwo = [[UITextField alloc] initWithFrame:CGRectMake(GAMESIZE*i, GAMESIZE*2, GAMESIZE, GAMESIZE)];
            textFieldTwo.borderStyle = UITextBorderStyleLine;
            textFieldTwo.textAlignment = NSTextAlignmentCenter;
            [textFieldTwo setEnabled:NO];
            if ([[game teamTwoScore] intValue] > 40) {
                textFieldTwo.text = @"Ad.";
            }
            else {
                textFieldTwo.text = [[game teamTwoScore] stringValue];
            }
            
            [scrollView addSubview:textFieldOne];
            [scrollView addSubview:textFieldTwo];
            
            if (![tmp hasWinner]) {
                //add a button
                Game *newGame = [[Game alloc] init];
                
                [[tmp games] addObject:newGame];
                
                if (textFieldOne.center.x + 30 > self.view.frame.size.width/2) {
                    [scrollView setContentSize:CGSizeMake(([[tmp games] count])*GAMESIZE, 90)];
                    [scrollView setContentOffset:CGPointMake(([[tmp games] count]-5)*GAMESIZE, 0)];
                }
            }
            
            if (textFieldOne.center.x + 30 > self.view.frame.size.width/2) {
                [scrollView setContentSize:CGSizeMake(([[tmp games] count])*GAMESIZE, 90)];
                [scrollView setContentOffset:CGPointMake(([[tmp games] count]-5)*GAMESIZE, 0)];
            }
        }
    }
    else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, GAMESIZE, GAMESIZE)];
        label.text = [[NSNumber numberWithInt:1] stringValue];
        label.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:label];
        
        UITextField *textFieldOne = [[UITextField alloc] initWithFrame:CGRectMake(0, GAMESIZE, GAMESIZE, GAMESIZE)];
        textFieldOne.borderStyle = UITextBorderStyleLine;
        textFieldOne.textAlignment = NSTextAlignmentCenter;
        textFieldOne.text = @"0";
        //textFieldOne.delegate = self;
        
        UITextField *textFieldTwo = [[UITextField alloc] initWithFrame:CGRectMake(0, GAMESIZE*2, GAMESIZE, GAMESIZE)];
        textFieldTwo.borderStyle = UITextBorderStyleLine;
        textFieldTwo.textAlignment = NSTextAlignmentCenter;
        //textFieldTwo.delegate = self;
        textFieldTwo.text = @"0";
        
        Game *newGame = [[Game alloc] init];
        
        [[tmp games] addObject:newGame];
        
    }
    
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
