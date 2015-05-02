//
//  MasterViewController.m
//  Tennis Match
//
//  Created by Robert Miller on 4/3/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "TennisMatchHelper.h"
#import "NewMatchViewController.h"
#import <REMenu/REMenu.h>
#import "AppDelegate.h"
#import "MatchCell.h"
#import "PlayerCell.h"
#import <PNChart/PNChart.h>
#import "MatchDetailViewController.h"
#import "PlayerDetailViewController.h"
#import "NewPlayerViewController.h"
#import <MZFormSheetController/MZFormSheetController.h>
#import "InfoPageViewController.h"
#import "Opponent.h"

@interface MasterViewController () <FUIAlertViewDelegate>

@property(nonatomic,retain) NSString *tableViewSource;
@property(nonatomic,retain) REMenu *menu;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setNavigationBarHidden:NO];
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self.tableView reloadData];
    
}


-(void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.tableView registerClass:[MatchCell class] forCellReuseIdentifier:@"MatchCell"];
    [self.tableView registerClass:[PlayerCell class] forCellReuseIdentifier:@"PlayerCell"];
    
    self.title = @"Matches";
    
    self.navigationController.navigationBar.tintColor = [UIColor asbestosColor];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-25.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    CAGradientLayer * tableViewLayer = [CAGradientLayer layer];
    //_tableViewLayer.frame = self.tableView.frame;
    tableViewLayer.frame = [UIScreen mainScreen].bounds;
    NSArray *locations = @[[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0.3], [NSNumber numberWithFloat:0.8], [NSNumber numberWithFloat:0.9], [NSNumber numberWithFloat:1.0]];
    tableViewLayer.locations = locations;
    tableViewLayer.colors = @[(id)[[UIColor whiteColor] CGColor], (id)[[UIColor cloudsColor] CGColor], (id)[[UIColor lightGrayColor] CGColor]];
    [backgroundView.layer insertSublayer:tableViewLayer atIndex:0];
    
    [CATransaction commit];
    
    self.tableView.backgroundView = backgroundView;
    //tableViewLayer.startPoint = CGPointMake(0, 0);
    //tableViewLayer.endPoint = CGPointMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    //tableViewLayer.bounds = [UIScreen mainScreen].bounds;
    //tableViewLayer.anchorPoint = CGPointZero;
    
    
    REMenuItem *home = [[REMenuItem alloc] initWithTitle:@"Matches" image:[UIImage imageNamed:@"tennis-court-50.png"] highlightedImage:[UIImage imageNamed:@"stadium-50.png"] action:^(REMenuItem *item) {
        _tableViewSource = MATCHSOURCE;
        self.title = @"Matches";
        
        //set the predicate and reload the data
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Match"];
        
        [fetchRequest setFetchBatchSize:10];
        
        NSPredicate *predicate = [NSPredicate predicateWithValue:true];
        
        [fetchRequest setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
        NSArray *sortDescriptors = @[sortDescriptor];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self;
        
        NSError *error = nil;
        if (![self.fetchedResultsController performFetch:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        [self.tableView reloadData];
    }];
    REMenuItem *players = [[REMenuItem alloc] initWithTitle:@"Players" image:[UIImage imageNamed:@"group-50.png"] highlightedImage:[UIImage imageNamed:@"group-50.png"] action:^(REMenuItem *item) {
        _tableViewSource = PLAYERSOURCE;
        self.title = @"Players";
        
        //set the predicate and reload the data
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Player"];
        
        [fetchRequest setFetchBatchSize:10];
        
        NSPredicate *predicate = [NSPredicate predicateWithValue:true];
        
        [fetchRequest setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
        NSArray *sortDescriptors = @[sortDescriptor];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self;
        
        NSError *error = nil;
        if (![self.fetchedResultsController performFetch:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        [self.tableView reloadData];
    }];
    REMenuItem *info = [[REMenuItem alloc] initWithTitle:@"About" image:[UIImage imageNamed:@"info-50.png"] highlightedImage:[UIImage imageNamed:@"info-50.png"] action:^(REMenuItem *item) {
        //show info page
        InfoPageViewController *infoPage = [[InfoPageViewController alloc] init];
        
        [self mz_presentFormSheetWithViewController:infoPage animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
            formSheetController.shouldDismissOnBackgroundViewTap = YES;
            [infoPage.view setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - formSheetController.presentedFormSheetSize.width)/2, formSheetController.portraitTopInset, formSheetController.presentedFormSheetSize.width, formSheetController.presentedFormSheetSize.height)];
            [infoPage configureView];
        }];
    }];
    
    _menu = [[REMenu alloc] initWithItems:@[home, players, info]];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.navigationController.navigationBar.bounds;
    //gradient.startPoint = CGPointMake(0, 0);
    //gradient.endPoint = CGPointMake(self.view.bounds.size.width, self.view.bounds.size.height/2);
    NSArray *gradientLocations = @[[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.5]];
    gradient.locations = gradientLocations;
    gradient.colors = @[(id)[TENNISBALLCOLOR CGColor], (id)[[UIColor emerlandColor] CGColor]];
    [self.navigationController.navigationBar.layer insertSublayer:gradient atIndex:0];
    
    [self.navigationController.navigationBar.layer insertSublayer:gradient atIndex:0];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewSource = MATCHSOURCE;
    
    //set the predicate and reload the data
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Match"];
    
    [fetchRequest setFetchBatchSize:10];
    
    NSPredicate *predicate = [NSPredicate predicateWithValue:true];
    
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showMenu {
    if ([_menu isOpen]) {
        [_menu close];
    }
    else {
        [_menu showFromNavigationController:self.navigationController];
    }
}

- (void)insertNewObject:(id)sender {
    
    if ([_tableViewSource isEqualToString:PLAYERSOURCE]) {
        /*
        UIAlertController *newPlayer = [UIAlertController alertControllerWithTitle:@"Add a new player" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [newPlayer addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            [textField setPlaceholder:@"Player Name"];
        }];
        
        [newPlayer addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            //Do Nothing
        }]];
        
        [newPlayer addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
            NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
            NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
            
            // If appropriate, configure the new managed object.
            // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
            [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
            UITextField *textField = [[newPlayer textFields] objectAtIndex:0];
            [newManagedObject setValue:[textField text] forKey:@"playerName"];
            
            // Save the context.
            NSError *error = nil;
            if (![context save:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }]];
        
        [self presentViewController:newPlayer animated:YES completion:^{
            //UP up
        }];
         */
        
        NewPlayerViewController *newPlayer = [[NewPlayerViewController alloc] init];
        
        [self mz_presentFormSheetWithViewController:newPlayer animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
            //up up
        }];
    }
    
    else if ([_tableViewSource isEqualToString:MATCHSOURCE]) {
        NewMatchViewController *newMatch = [[NewMatchViewController alloc] init];
        [self presentViewController:newMatch animated:YES completion:^{
            //up up
        }];
    }
}

-(void)dismissNewPlayer {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        //up up
    }];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        //[[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Removal Helpers

-(void)removeMatchFromOpposition:(NSIndexPath*)indexPath {
    
    Match *thisMatch = (Match*)[_fetchedResultsController objectAtIndexPath:indexPath];
    
    Team *_teamOne = [thisMatch teamOne];
    Team *_teamTwo = [thisMatch teamTwo];
    [_teamOne setTeams];
    [_teamTwo setTeams];
    
    Stats *teamOneMatchStats = (Stats*)[thisMatch teamOneMatchStats];
    Stats *teamTwoMatchStats = (Stats*)[thisMatch teamTwoMatchStats];
    
    Player *teamOnePlayerOne = [_teamOne playerOne];
    Player *teamTwoPlayerOne = [_teamTwo playerOne];
    
    [[teamOnePlayerOne playerStats] setPlayerMatchesPlayed:[NSNumber numberWithInt:[[[teamOnePlayerOne playerStats] playerMatchesPlayed] intValue] - 1]];
    [[teamTwoPlayerOne playerStats] setPlayerMatchesPlayed:[NSNumber numberWithInt:[[[teamTwoPlayerOne playerStats] playerMatchesPlayed] intValue] - 1]];
    
    Stats *up = [teamOnePlayerOne playerStats];
    
    switch ([thisMatch matchWinner]) {
        case 1:
            [[teamOnePlayerOne playerStats] setPlayerMatchesWon:[NSNumber numberWithInt:[[[teamOnePlayerOne playerStats] playerMatchesWon] intValue] - 1]];
            break;
        case 2:
            [[teamTwoPlayerOne playerStats] setPlayerMatchesWon:[NSNumber numberWithInt:[[[teamTwoPlayerOne playerStats] playerMatchesWon] intValue] - 1]];
            break;
            
        default:
            break;
    }
    
    [[teamOnePlayerOne playerStats] setPlayerSetsPlayed:[NSNumber numberWithInt:([[[teamOnePlayerOne playerStats] playerSetsPlayed] intValue] - [[teamOneMatchStats playerSetsPlayed] intValue])]];
    [[teamTwoPlayerOne playerStats] setPlayerSetsPlayed:[NSNumber numberWithInt:([[[teamTwoPlayerOne playerStats] playerSetsPlayed] intValue] - [[teamTwoMatchStats playerSetsPlayed] intValue])]];
    
    [[teamOnePlayerOne playerStats] setPlayerSetsWon:[NSNumber numberWithInt:([[[teamOnePlayerOne playerStats] playerSetsWon] intValue] - [[teamOneMatchStats playerSetsWon] intValue])]];
    [[teamTwoPlayerOne playerStats] setPlayerSetsWon:[NSNumber numberWithInt:([[[teamTwoPlayerOne playerStats] playerSetsWon] intValue] - [[teamTwoMatchStats playerSetsWon] intValue])]];
    
    [[teamOnePlayerOne playerStats] setPlayerGamesPlayed:[NSNumber numberWithInt:([[[teamOnePlayerOne playerStats] playerGamesPlayed] intValue] - [[teamOneMatchStats playerGamesPlayed] intValue])]];
    [[teamTwoPlayerOne playerStats] setPlayerGamesPlayed:[NSNumber numberWithInt:([[[teamTwoPlayerOne playerStats] playerGamesPlayed] intValue] - [[teamTwoMatchStats playerGamesPlayed] intValue])]];
    
    [[teamOnePlayerOne playerStats] setPlayerGamesWon:[NSNumber numberWithInt:([[[teamOnePlayerOne playerStats] playerGamesWon] intValue] - [[teamOneMatchStats playerGamesWon] intValue])]];
    [[teamTwoPlayerOne playerStats] setPlayerGamesWon:[NSNumber numberWithInt:([[[teamTwoPlayerOne playerStats] playerGamesWon] intValue] - [[teamTwoMatchStats playerGamesWon] intValue])]];
    
    if ([thisMatch doubles]) {
        Player *teamOnePlayerTwo = [_teamOne playerTwo];
        Player *teamTwoPlayerTwo = [_teamTwo playerTwo];
        
        [[teamOnePlayerTwo playerStats] setPlayerMatchesPlayed:[NSNumber numberWithInt:[[[teamOnePlayerTwo playerStats] playerMatchesPlayed] intValue] - 1]];
        [[teamTwoPlayerTwo playerStats] setPlayerMatchesPlayed:[NSNumber numberWithInt:[[[teamTwoPlayerTwo playerStats] playerMatchesPlayed] intValue] - 1]];
        
        switch ([thisMatch matchWinner]) {
            case 1:
                [[teamOnePlayerTwo playerStats] setPlayerMatchesWon:[NSNumber numberWithInt:[[[teamOnePlayerTwo playerStats] playerMatchesWon] intValue] - 1]];
                break;
            case 2:
                [[teamTwoPlayerTwo playerStats] setPlayerMatchesWon:[NSNumber numberWithInt:[[[teamTwoPlayerTwo playerStats] playerMatchesWon] intValue] - 1]];
                break;
                
            default:
                break;
        }
        
        [[teamOnePlayerTwo playerStats] setPlayerSetsPlayed:[NSNumber numberWithInt:([[[teamOnePlayerTwo playerStats] playerSetsPlayed] intValue] - [[teamOneMatchStats playerSetsPlayed] intValue])]];
        [[teamTwoPlayerTwo playerStats] setPlayerSetsPlayed:[NSNumber numberWithInt:([[[teamTwoPlayerTwo playerStats] playerSetsPlayed] intValue] - [[teamTwoMatchStats playerSetsPlayed] intValue])]];
        
        [[teamOnePlayerTwo playerStats] setPlayerSetsWon:[NSNumber numberWithInt:([[[teamOnePlayerTwo playerStats] playerSetsWon] intValue] - [[teamOneMatchStats playerSetsWon] intValue])]];
        [[teamTwoPlayerTwo playerStats] setPlayerSetsWon:[NSNumber numberWithInt:([[[teamTwoPlayerTwo playerStats] playerSetsWon] intValue] - [[teamTwoMatchStats playerSetsWon] intValue])]];
        
        [[teamOnePlayerTwo playerStats] setPlayerGamesPlayed:[NSNumber numberWithInt:([[[teamOnePlayerOne playerStats] playerGamesPlayed] intValue] - [[teamOneMatchStats playerGamesPlayed] intValue])]];
        [[teamTwoPlayerTwo playerStats] setPlayerGamesPlayed:[NSNumber numberWithInt:([[[teamTwoPlayerTwo playerStats] playerGamesPlayed] intValue] - [[teamTwoMatchStats playerGamesPlayed] intValue])]];
        
        [[teamOnePlayerTwo playerStats] setPlayerGamesWon:[NSNumber numberWithInt:([[[teamOnePlayerTwo playerStats] playerGamesWon] intValue] - [[teamOneMatchStats playerGamesWon] intValue])]];
        [[teamTwoPlayerTwo playerStats] setPlayerGamesWon:[NSNumber numberWithInt:([[[teamTwoPlayerTwo playerStats] playerGamesWon] intValue] - [[teamTwoMatchStats playerGamesWon] intValue])]];
    }
    
    NSArray *playerOneOpponents = [[_teamOne playerOne] opponents];
    Opponent *matchOpponent = nil;
    NSInteger index = 0;
    for (Opponent *tmp in playerOneOpponents) {
        if (![_teamOne doubles]) {
            if ([[[[tmp opposingTeam] teamPlayerOne] name] isEqualToString:[[_teamTwo playerOne] playerName]]) {
                if ([[[[tmp opposingTeam] teamPlayerOne] timeStamp] isEqualToDate:[[_teamTwo playerOne] timeStamp]]) {
                    matchOpponent = tmp;
                    break;
                }
            }
            else {
                index++;
            }
        }
        else {
            if ([[[[tmp opposingTeam] teamPlayerOne] name] isEqualToString:[[_teamTwo playerOne] playerName]]) {
                if ([[[[tmp opposingTeam] teamPlayerOne] timeStamp] isEqualToDate:[[_teamTwo playerOne] timeStamp]]) {
                    if ([[[[tmp opposingTeam] teamPlayerTwo] name] isEqualToString:[[_teamTwo playerTwo] playerName]]) {
                        if ([[[[tmp opposingTeam] teamPlayerTwo] timeStamp] isEqualToDate:[[_teamTwo playerTwo] timeStamp]]) {
                            matchOpponent = tmp;
                            break;
                        }
                    }
                }
            }
            else {
                index++;
            }
        }
    }
    if (matchOpponent != nil) {
        Stats *oldStat = [matchOpponent opposingTeamStats];
        
        int oldMatches = [[oldStat playerMatchesPlayed] intValue];
        [oldStat setPlayerMatchesPlayed:[NSNumber numberWithInt:oldMatches-1]];
        int oldMatchesWon = [[oldStat playerMatchesWon] intValue];
        oldMatchesWon = oldMatchesWon - [[thisMatch.teamTwoMatchStats playerMatchesWon] intValue];
        [oldStat setPlayerMatchesWon:[NSNumber numberWithInt:oldMatchesWon]];
        
        int oldSets = [[oldStat playerSetsPlayed] intValue];
        [oldStat setPlayerSetsPlayed:[NSNumber numberWithInt:oldSets-[teamTwoMatchStats.playerSetsPlayed intValue]]];
        int oldSetsWon = [[oldStat playerSetsWon] intValue];
        [oldStat setPlayerSetsWon:[NSNumber numberWithInt:oldSetsWon-[teamTwoMatchStats.playerSetsWon intValue]]];
        
        int oldGames = [[oldStat playerGamesPlayed] intValue];
        [oldStat setPlayerGamesPlayed:[NSNumber numberWithInt:oldGames-[teamTwoMatchStats.playerGamesPlayed intValue]]];
        int oldGamesWon = [[oldStat playerGamesWon] intValue];
        [oldStat setPlayerGamesWon:[NSNumber numberWithInt:oldGamesWon-[teamTwoMatchStats.playerGamesWon intValue]]];
        
        int oldAces = [[oldStat aces] intValue];
        [oldStat setAces:[NSNumber numberWithInt:oldAces-[teamTwoMatchStats.aces intValue]]];
        
        int oldFaults = [[oldStat faults] intValue];
        [oldStat setFaults:[NSNumber numberWithInt:oldFaults-[teamTwoMatchStats.faults intValue]]];
        
        int oldDoubleFaults = [[oldStat doubleFaults] intValue];
        [oldStat setDoubleFaults:[NSNumber numberWithInt:oldDoubleFaults-[teamTwoMatchStats.doubleFaults intValue]]];
        
        int oldFirstServesWon = [[oldStat firstServesWon] intValue];
        [oldStat setFirstServesWon:[NSNumber numberWithInt:oldFirstServesWon-[teamTwoMatchStats.firstServesWon intValue]]];
        
        int oldSecondServesWon = [[oldStat secondServesWon] intValue];
        [oldStat setSecondServesWon:[NSNumber numberWithInt:oldSecondServesWon-[teamTwoMatchStats.secondServesWon intValue]]];
        
        int oldServes = [[oldStat servesMade] intValue];
        [oldStat setServesMade:[NSNumber numberWithInt:oldServes-[teamTwoMatchStats.servesMade intValue]]];
        
        [matchOpponent setOpposingTeamStats:oldStat];
        
        Stats *myStats = [matchOpponent myTeamStats];
        
        int myMatches = [[myStats playerMatchesPlayed] intValue];
        [oldStat setPlayerMatchesPlayed:[NSNumber numberWithInt:myMatches-1]];
        int myMatchesWon = [[myStats playerMatchesWon] intValue];
        myMatchesWon = myMatchesWon + [[teamOneMatchStats playerMatchesWon] intValue];
        [myStats setPlayerMatchesWon:[NSNumber numberWithInt:myMatchesWon]];
        
        int mySets = [[myStats playerSetsPlayed] intValue];
        [myStats setPlayerSetsPlayed:[NSNumber numberWithInt:mySets-[teamOneMatchStats.playerSetsPlayed intValue]]];
        int mySetsWon = [[myStats playerSetsWon] intValue];
        [myStats setPlayerSetsWon:[NSNumber numberWithInt:mySetsWon-[teamOneMatchStats.playerSetsWon intValue]]];
        
        int myGames = [[myStats playerGamesPlayed] intValue];
        [myStats setPlayerGamesPlayed:[NSNumber numberWithInt:myGames-[teamOneMatchStats.playerGamesPlayed intValue]]];
        int myGamesWon = [[myStats playerGamesWon] intValue];
        [myStats setPlayerGamesWon:[NSNumber numberWithInt:myGamesWon-[teamOneMatchStats.playerGamesWon intValue]]];
        
        int myAces = [[myStats aces] intValue];
        [myStats setAces:[NSNumber numberWithInt:myAces-[teamOneMatchStats.aces intValue]]];
        
        int myFaults = [[myStats faults] intValue];
        [myStats setFaults:[NSNumber numberWithInt:myFaults-[teamOneMatchStats.faults intValue]]];
        
        int myDoubleFaults = [[myStats doubleFaults] intValue];
        [myStats setDoubleFaults:[NSNumber numberWithInt:myDoubleFaults-[teamOneMatchStats.doubleFaults intValue]]];
        
        int myFirstServesWon = [[myStats firstServesWon] intValue];
        [myStats setFirstServesWon:[NSNumber numberWithInt:myFirstServesWon-[teamOneMatchStats.firstServesWon intValue]]];
        
        int mySecondServesWon = [[myStats secondServesWon] intValue];
        [myStats setSecondServesWon:[NSNumber numberWithInt:mySecondServesWon-[teamOneMatchStats.secondServesWon intValue]]];
        
        int myServes = [[myStats servesMade] intValue];
        [myStats setServesMade:[NSNumber numberWithInt:myServes-[teamOneMatchStats.servesMade intValue]]];
        
        [matchOpponent setMyTeamStats:myStats];
        
        NSMutableArray *oppArray = [[NSMutableArray alloc] initWithArray:[[_teamOne playerOne] opponents]];
        [oppArray replaceObjectAtIndex:index withObject:matchOpponent];
        //[oppArray addObject:matchOpponent];
        [[_teamOne playerOne] setOpponents:oppArray];
    }
    
    NSError *error = nil;
    if ([[[AppDelegate sharedInstance] managedObjectContext] save:&error]) {
        NSLog(@"error saving match with error: %@", error);
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_tableViewSource isEqualToString:MATCHSOURCE]) {
        MatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MatchCell"];
        [self configureMatchCell:cell atIndexPath:indexPath];
        
        return cell;
    }
    else if ([_tableViewSource isEqualToString:PLAYERSOURCE]) {
        PlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerCell"];
        [self configurePlayerCell:cell atIndexPath:indexPath];
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        if ([_tableViewSource isEqualToString:MATCHSOURCE]) {
            [self removeMatchFromOpposition:indexPath];
        }
        else if ([_tableViewSource isEqualToString:PLAYERSOURCE]) {
            
        }
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    //Match *object = (Match*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    //Player *player = [[object teamOne] playerOneFromTeam];
    //NSLog(@"player name: %@", [player playerName]);
    //cell.textLabel.text = [[object valueForKey:@"timeStamp"] description];
    if ([_tableViewSource isEqualToString:MATCHSOURCE]) {
        [self configureMatchCell:cell atIndexPath:indexPath];
    }
    else if ([_tableViewSource isEqualToString:PLAYERSOURCE]) {
        [self configurePlayerCell:cell atIndexPath:indexPath];
    }
}

//#define SCORESIZE   45

-(void)configureMatchCell:(MatchCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Match *match = (Match*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.cellMatch = match;
    [cell configureCell];
    
}
         
-(void)configurePlayerCell:(PlayerCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Player *player = (Player*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.cellPlayer = player;
    [cell configureCell];
     
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_tableViewSource isEqualToString:MATCHSOURCE]) {
        Match *match = [self.fetchedResultsController objectAtIndexPath:indexPath];
        MatchDetailViewController *vc = [[MatchDetailViewController alloc] init];
        vc.detailMatch = match;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([_tableViewSource isEqualToString:PLAYERSOURCE]) {
        Player *player = [self.fetchedResultsController objectAtIndexPath:indexPath];
        PlayerDetailViewController *vc = [[PlayerDetailViewController alloc] init];
        vc.detailPlayer = player;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 25;
    
    if ([_tableViewSource isEqualToString:MATCHSOURCE]) {
        height = 190;
    }
    else if ([_tableViewSource isEqualToString:PLAYERSOURCE]) {
        height = 90;
    }
    
    return height;
    
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:_tableViewSource inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

@end
