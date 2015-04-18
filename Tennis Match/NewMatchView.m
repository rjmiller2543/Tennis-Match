//
//  NewMatchView.m
//  Tennis Match
//
//  Created by Robert Miller on 4/7/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "NewMatchView.h"
#import <VBFPopFlatButton/VBFPopFlatButton.h>
#import <FlatUIKit/FlatUIKit.h>
#import "Game.h"
#import <IQDropDownTextField/IQDropDownTextField.h>

@interface NewMatchView () <UITextFieldDelegate, IQDropDownTextFieldDelegate>

@property(nonatomic,retain) VBFPopFlatButton *addMatchButton;
@property(nonatomic,retain) UIScrollView *setsScrollView;
@property(nonatomic,retain) NSMutableArray *setTextViews;
@property(nonatomic,retain) NSMutableArray *setGamesTextViews;

@property(nonatomic) int numSets;
@property(nonatomic) int numPlayerOneSets;
@property(nonatomic) int numPlayerTwoSets;

@end

#define PLAYERONE 0x10
#define PLAYERTWO 0x20

#define SCORESIZE   60

@implementation NewMatchView

-(instancetype)init {
    self = [super init];
    if (self) {
        //Configure the view
        self.backgroundColor = [UIColor colorWithRed:0xad/0xff green:0xff/0xff blue:0x2f/0xff alpha:1.0];
        //[self setFrame:[UIScreen mainScreen].bounds];
        _setsArray = [[NSMutableArray alloc] init];
        _setGamesTextViews = [[NSMutableArray alloc] init];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 220, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 170)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor alizarinColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        _setsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2, 90, [UIScreen mainScreen].bounds.size.width / 2, 120)];
        _setsScrollView.directionalLockEnabled = YES;
        _setsScrollView.scrollEnabled = NO;
        [self addSubview:_setsScrollView];
        
        _isDoubles = false;
        _numSets = 0;
        
        _addMatchButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(SCORESIZE*_numSets + 15, _setsScrollView.frame.size.height / 2 - 5, 20, 20) buttonType:buttonAddType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
        [_addMatchButton addTarget:self action:@selector(addNewSet) forControlEvents:UIControlEventTouchUpInside];
        _addMatchButton.roundBackgroundColor = [UIColor asbestosColor];
        _addMatchButton.tintColor = [UIColor turquoiseColor];
        [_setsScrollView addSubview:_addMatchButton];
    
        _setTextViews = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)setIsDoubles:(BOOL)isDoubles {
    _isDoubles = isDoubles;
}

-(void)setTeamOne:(Team *)teamOne {
    _teamOne = teamOne;
    UILabel *teamOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 90, self.frame.size.width / 2 - 20, SCORESIZE)];
    teamOneLabel.font = [UIFont boldFlatFontOfSize:20.0f];
    teamOneLabel.textAlignment = NSTextAlignmentRight;
    teamOneLabel.lineBreakMode = NSLineBreakByWordWrapping;
    teamOneLabel.numberOfLines = 0;
    teamOneLabel.text = [[teamOne playerOne] playerName];
    if (_isDoubles) {
        teamOneLabel.text = [teamOneLabel.text stringByAppendingString:@" & "];
        teamOneLabel.text = [teamOneLabel.text stringByAppendingString:[[teamOne playerTwo] playerName]];
    }
    [self addSubview:teamOneLabel];
}

-(void)setTeamTwo:(Team *)teamTwo {
    _teamTwo = teamTwo;
    UILabel *teamTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 150, self.frame.size.width / 2 - 20, SCORESIZE)];
    teamTwoLabel.font = [UIFont boldFlatFontOfSize:20.0f];
    teamTwoLabel.textAlignment = NSTextAlignmentRight;
    teamTwoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    teamTwoLabel.numberOfLines = 0;
    teamTwoLabel.text = [[teamTwo playerOne] playerName];
    if (_isDoubles) {
        teamTwoLabel.text = [teamTwoLabel.text stringByAppendingString:@" & "];
        teamTwoLabel.text = [teamTwoLabel.text stringByAppendingString:[[teamTwo playerTwo] playerName]];
    }
    [self addSubview:teamTwoLabel];
}

-(void)addNewSetColumn {
    IQDropDownTextField *textFieldOne = [[IQDropDownTextField alloc] initWithFrame:CGRectMake(SCORESIZE*_numSets, 0, SCORESIZE, SCORESIZE)];
    textFieldOne.isOptionalDropDown = NO;
    [textFieldOne setItemList:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
    textFieldOne.borderStyle = UITextBorderStyleLine;
    textFieldOne.textAlignment = NSTextAlignmentCenter;
    textFieldOne.text = @"0";
    textFieldOne.tag = PLAYERONE + _numSets;
    textFieldOne.delegate = self;
    IQDropDownTextField *textFieldTwo = [[IQDropDownTextField alloc] initWithFrame:CGRectMake(SCORESIZE*_numSets, SCORESIZE, SCORESIZE, SCORESIZE)];
    textFieldTwo.isOptionalDropDown = NO;
    [textFieldTwo setItemList:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
    textFieldTwo.borderStyle = UITextBorderStyleLine;
    textFieldTwo.textAlignment = NSTextAlignmentCenter;
    textFieldTwo.text = @"0";
    textFieldTwo.tag = PLAYERTWO + _numSets;
    textFieldTwo.delegate = self;
    
    NSDictionary *setTextView = @{ @"TextFieldOne" : textFieldOne, @"TextFieldTwo" : textFieldTwo, };
    [_setTextViews addObject:setTextView];
    
    [_setsScrollView addSubview:textFieldOne];
    [_setsScrollView addSubview:textFieldTwo];
    
    _numSets += 1;
    
    [_addMatchButton setCenter:CGPointMake(SCORESIZE*_numSets + 20, _setsScrollView.frame.size.height / 2 )];
    
    if (_addMatchButton.center.x + 15 > self.frame.size.width) {
        [_setsScrollView setContentSize:CGSizeMake((_numSets+1)*SCORESIZE, _setsScrollView.frame.size.height)];
        [_setsScrollView setContentOffset:CGPointMake((_numSets-4)*SCORESIZE, 0)];
    }
}

-(void)addNewSet {
    /*add new set to the top*/
    if ([_setsArray count] == 0) {
        [self addNewSetColumn];
        
        Set *newSet = [[Set alloc] init];
        [_setsArray addObject:newSet];
        [_tableView reloadData];
        
        return;
    }
    
    Set *tmp = [_setsArray objectAtIndex:(_numSets-1)];
    NSDictionary *dict = [_setTextViews objectAtIndex:_numSets - 1];
    IQDropDownTextField *tmp1 = (IQDropDownTextField *)dict[@"TextFieldOne"];
    IQDropDownTextField *tmp2 = (IQDropDownTextField *)dict[@"TextFieldTwo"];
    [tmp setTeamOneScore:[NSNumber numberWithInt:[[tmp1 text] intValue]]];
    [tmp setTeamTwoScore:[NSNumber numberWithInt:[[tmp2 text] intValue]]];
    
    switch ([tmp hasWinner]) {
        case 1:
            tmp1.layer.borderWidth = 2.0;
            tmp1.font = [UIFont boldSystemFontOfSize:18.0f];
            break;
        case 2:
            tmp2.layer.borderWidth = 2.0;
            tmp2.font = [UIFont boldSystemFontOfSize:18.0f];
            break;
            
        default:
            break;
    }
    
    if ([_setsArray objectAtIndex:(_numSets-1)] == nil) {
        [self addNewSetColumn];
        
        Set *newSet = [[Set alloc] init];
        [_setsArray addObject:newSet];
        [_tableView reloadData];
    }
    else if (![[_setsArray objectAtIndex:(_numSets-1)] hasWinner]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"What was the score?" message:@"It seems there's no winner.." preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Team One Score";
        }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Team Two Score";
        }];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                handler:^(UIAlertAction *action) {
                                                    //Do nothing and return without adding a new set
                                                }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            Set *tmp = [_setsArray objectAtIndex:(_numSets-1)];
            UITextField *tmpScoreOne = [[alert textFields] objectAtIndex:0];
            [tmp setTeamOneScore:[NSNumber numberWithInteger:[tmpScoreOne.text integerValue]]];
            UITextField *tmpScoreTwo = [[alert textFields] objectAtIndex:1];
            [tmp setTeamTwoScore:[NSNumber numberWithInteger:[tmpScoreTwo.text integerValue]]];
            
            if ([tmp hasWinner]) {
                NSDictionary *dict = [_setTextViews objectAtIndex:_numSets - 1];
                IQDropDownTextField *tmp1 = (IQDropDownTextField *)dict[@"TextFieldOne"];
                IQDropDownTextField *tmp2 = (IQDropDownTextField *)dict[@"TextFieldTwo"];
                [tmp1 setText:[[tmp teamOneScore] stringValue]];
                [tmp2 setText:[[tmp teamTwoScore] stringValue]];
                
                switch ([tmp hasWinner]) {
                    case 1:
                        tmp1.layer.borderWidth = 2.0;
                        tmp1.font = [UIFont boldSystemFontOfSize:18.0f];
                        break;
                    case 2:
                        tmp2.layer.borderWidth = 2.0;
                        tmp2.font = [UIFont boldSystemFontOfSize:18.0f];
                        break;
                        
                    default:
                        break;
                }
                
                [self addNewSetColumn];
                
                Set *newSet = [[Set alloc] init];
                [_setsArray addObject:newSet];
                [_tableView reloadData];
            }
            else {
                // Do nothing and close
            }
        }]];
        
        [_parentViewContoller presentViewController:alert animated:YES completion:^{
            //up up
        }];
    }
    else {
        [self addNewSetColumn];
        
        Set *newSet = [[Set alloc] init];
        [_setsArray addObject:newSet];
        [_tableView reloadData];
    }
    
    if (_numSets >= 5) {
        [_addMatchButton animateToType:buttonSquareType];
        [_addMatchButton addTarget:self action:@selector(matchCancelButton) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)matchCancelButton {
    //maybe something to do later.. atm can't think of anything..
}

-(void)addNewGame:(id)sender {
    VBFPopFlatButton *button = (VBFPopFlatButton*)sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag+1 inSection:0];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    
    NSMutableArray *gamesArray = [_setGamesTextViews objectAtIndex:button.tag];
    NSDictionary *dict = [gamesArray lastObject];
    UITextField *oldFieldOne = (UITextField*)dict[@"TextFieldOne"];
    UITextField *oldFieldTwo = (UITextField*)dict[@"TextFieldTwo"];
    
    Set *tmp = [_setsArray objectAtIndex:button.tag];
    Game *game = (Game*)[[tmp games] lastObject];
    
    if ([[oldFieldOne text] isEqualToString:@"Ad."]) {
        [game setTeamOneScore:[NSNumber numberWithInt:50]];
    }
    else {
        [game setTeamOneScore:[NSNumber numberWithInt:[[oldFieldOne text] intValue]]];
    }
    if ([[oldFieldTwo text] isEqualToString:@"Ad."]) {
        [game setTeamTwoScore:[NSNumber numberWithInt:50]];
    }
    else {
        [game setTeamTwoScore:[NSNumber numberWithInt:[[oldFieldTwo text] intValue]]];
    }
    [oldFieldOne setEnabled:NO];
    [oldFieldTwo setEnabled:NO];
    
    dict = [_setTextViews lastObject];
    IQDropDownTextField *setOneField = (IQDropDownTextField*)dict[@"TextFieldOne"];
    IQDropDownTextField *setTwoField = (IQDropDownTextField*)dict[@"TextFieldTwo"];
    
    switch ([game gameWinner]) {
        case 1:{
            int lastScore = [[setOneField text] intValue];
            lastScore += 1;
            [setOneField setText:[[NSNumber numberWithInt:lastScore] stringValue]];
            [tmp setTeamOneScore:[NSNumber numberWithInt:lastScore]];
            break;
        }
        case 2:{
            int lastScore = [[setTwoField text] intValue];
            lastScore += 1;
            [setTwoField setText:[[NSNumber numberWithInt:lastScore] stringValue]];
            [tmp setTeamTwoScore:[NSNumber numberWithInt:lastScore]];
            break;
        }
        case 0:{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Who won?" message:@"There doesn't appear to be a clear winner.." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Team One" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                int lastScore = [[setOneField text] intValue];
                lastScore += 1;
                [setOneField setText:[[NSNumber numberWithInt:lastScore] stringValue]];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"Team Two" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                int lastScore = [[setTwoField text] intValue];
                lastScore += 1;
                [setTwoField setText:[[NSNumber numberWithInt:lastScore] stringValue]];
            }]];
            [_parentViewContoller presentViewController:alert animated:YES completion:^{
                //up up
            }];
            break;
        }
            
        default:
            break;
    }
    
    if ([tmp hasWinner]) {
        //if this set has a winner, don't add more games..
        [self addNewSet];
    }
    else {
        
        UIScrollView *scrollView = nil;
        for (id tmp in [cell subviews]) {
            if ([tmp class] == [UIScrollView class]) {
                scrollView = (UIScrollView*)tmp;
            }
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCORESIZE*[[tmp games] count], 0, SCORESIZE, SCORESIZE)];
        label.text = [[NSNumber numberWithInteger:([[tmp games] count]+1)] stringValue];
        label.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:label];
        
        IQDropDownTextField *textFieldOne = [[IQDropDownTextField alloc] initWithFrame:CGRectMake(SCORESIZE*[[tmp games] count], SCORESIZE, SCORESIZE, SCORESIZE)];
        textFieldOne.isOptionalDropDown = NO;
        [textFieldOne setItemList:@[@"0", @"15", @"30", @"40", @"Ad."]];
        textFieldOne.borderStyle = UITextBorderStyleLine;
        textFieldOne.textAlignment = NSTextAlignmentCenter;
        textFieldOne.text = @"0";
        IQDropDownTextField *textFieldTwo = [[IQDropDownTextField alloc] initWithFrame:CGRectMake(SCORESIZE*[[tmp games] count], SCORESIZE*2, SCORESIZE, SCORESIZE)];
        textFieldTwo.isOptionalDropDown = NO;
        [textFieldTwo setItemList:@[@"0", @"15", @"30", @"40", @"Ad."]];
        textFieldTwo.borderStyle = UITextBorderStyleLine;
        textFieldTwo.textAlignment = NSTextAlignmentCenter;
        textFieldTwo.text = @"0";
        
        [scrollView addSubview:textFieldOne];
        [scrollView addSubview:textFieldTwo];
        
        NSDictionary *dict = @{ @"TextFieldOne" : textFieldOne, @"TextFieldTwo" : textFieldTwo, };
        [gamesArray addObject:dict];
        
        Game *newGame = [[Game alloc] init];
        
        [[tmp games] addObject:newGame];
        
        VBFPopFlatButton *tmpButton = nil;
        for (id tmp in [scrollView subviews]) {
            if ([tmp class] == [VBFPopFlatButton class]) {
                tmpButton = (VBFPopFlatButton*)tmp;
            }
        }
        //VBFPopFlatButton *addGameButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(([[tmp games] count])*30, cell.frame.size.height / 2 - 10, 15, 15) buttonType:buttonAddType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
        //addGameButton.tag = indexPath.row;
        [tmpButton setCenter:CGPointMake(SCORESIZE*[[tmp games] count] + 20, cell.frame.size.height / 2 )];
        //[scrollView addSubview:addGameButton];
        
        if (tmpButton.center.x + SCORESIZE > (self.frame.size.width / 2)) {
            [scrollView setContentSize:CGSizeMake(([[tmp games] count]+1)*SCORESIZE, _setsScrollView.frame.size.height)];
            [scrollView setContentOffset:CGPointMake(([[tmp games] count]-4)*SCORESIZE, 0) animated:YES];
        }
    }
}

-(void)textField:(IQDropDownTextField *)textField didSelectItem:(NSString *)item {
    [textField resignFirstResponder];
    NSLog(@"text field did select item");
}

-(void)configureCell:(UITableViewCell *)cell withIndex:(NSIndexPath *)indexPath {
    //Add team one label to the cell
    //if (cell.frame.origin.y >= (self.frame.size.height + 110)) {
    //    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    //}
    cell.backgroundColor = [UIColor emerlandColor];
    if (indexPath.row == ([_setsArray count]-1)) {
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    UILabel *setLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, cell.frame.size.width / 2, SCORESIZE)];
    setLabel.text = @"Set ";
    setLabel.text = [setLabel.text stringByAppendingString:[[NSNumber numberWithInteger:(indexPath.row + 1)] stringValue]];
    setLabel.font = [UIFont boldFlatFontOfSize:22.0f];
    [cell addSubview:setLabel];
    
    UILabel *teamOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, cell.frame.size.width / 2 - 10, SCORESIZE)];
    teamOneLabel.font = [UIFont boldFlatFontOfSize:16.0f];
    teamOneLabel.textAlignment = NSTextAlignmentRight;
    teamOneLabel.lineBreakMode = NSLineBreakByWordWrapping;
    teamOneLabel.numberOfLines = 0;
    teamOneLabel.text = [[_teamOne playerOne] playerName];
    if (_isDoubles) {
        teamOneLabel.text = [teamOneLabel.text stringByAppendingString:@" & "];
        teamOneLabel.text = [teamOneLabel.text stringByAppendingString:[[_teamOne playerTwo] playerName]];
    }
    [cell addSubview:teamOneLabel];
    
    //Add team two label to the cell
    UILabel *teamTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 90, cell.frame.size.width / 2 - 10, SCORESIZE)];
    teamTwoLabel.font = [UIFont boldFlatFontOfSize:16.0f];
    teamTwoLabel.textAlignment = NSTextAlignmentRight;
    teamTwoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    teamTwoLabel.numberOfLines = 0;
    teamTwoLabel.text = [[_teamTwo playerOne] playerName];
    if (_isDoubles) {
        teamTwoLabel.text = [teamTwoLabel.text stringByAppendingString:@" & "];
        teamTwoLabel.text = [teamTwoLabel.text stringByAppendingString:[[_teamTwo playerTwo] playerName]];
    }
    [cell addSubview:teamTwoLabel];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2, 0, cell.frame.size.width / 2, 90)];
    [cell addSubview:scrollView];
    
    Set *tmp = [_setsArray objectAtIndex:indexPath.row];
    NSMutableArray *gamesTextViews = [[NSMutableArray alloc] init];
    if ([[tmp games] count] != 0) {
        for (int i = 0; i < [[tmp games] count]; i++) {
            Game *game = [[tmp games] objectAtIndex:i];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCORESIZE*i, 0, SCORESIZE, SCORESIZE)];
            label.text = [[NSNumber numberWithInt:(i+1)] stringValue];
            label.textAlignment = NSTextAlignmentCenter;
            [scrollView addSubview:label];
            
            UITextField *textFieldOne = [[UITextField alloc] initWithFrame:CGRectMake(SCORESIZE*i, SCORESIZE, SCORESIZE, SCORESIZE)];
            textFieldOne.borderStyle = UITextBorderStyleLine;
            textFieldOne.textAlignment = NSTextAlignmentCenter;
            [textFieldOne setEnabled:NO];
            if ([[game teamOneScore] intValue] > 40) {
                textFieldOne.text = @"Ad.";
            }
            else {
                textFieldOne.text = [[game teamOneScore] stringValue];
            }
            UITextField *textFieldTwo = [[UITextField alloc] initWithFrame:CGRectMake(SCORESIZE*i, 60, SCORESIZE, SCORESIZE)];
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
            
            NSDictionary *dict = @{ @"TextFieldOne" : textFieldOne, @"TextFieldTwo" : textFieldTwo, };
            [gamesTextViews addObject:dict];
            
            if (![tmp hasWinner]) {
                //add a button
                Game *newGame = [[Game alloc] init];
                
                [[tmp games] addObject:newGame];
                
                VBFPopFlatButton *addGameButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(([[tmp games] count])*SCORESIZE, scrollView.frame.size.height / 2 - 10, 15, 15) buttonType:buttonAddType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
                [addGameButton addTarget:self action:@selector(addNewGame:) forControlEvents:UIControlEventTouchUpInside];
                addGameButton.roundBackgroundColor = [UIColor asbestosColor];
                addGameButton.tintColor = [UIColor turquoiseColor];
                addGameButton.tag = indexPath.row;
                [addGameButton setCenter:CGPointMake(SCORESIZE*[[tmp games] count] + 20, 60/*scrollView.frame.size.height / 2*/ )];
                [scrollView addSubview:addGameButton];
                
                if (addGameButton.center.x + 15 > self.frame.size.width) {
                    [scrollView setContentSize:CGSizeMake(([[tmp games] count]+1)*SCORESIZE, 90)];
                    [scrollView setContentOffset:CGPointMake(([[tmp games] count]-4)*SCORESIZE, 0)];
                }
            }
        }
    }
    else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCORESIZE, SCORESIZE)];
        label.text = [[NSNumber numberWithInt:1] stringValue];
        label.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:label];
        
        IQDropDownTextField *textFieldOne = [[IQDropDownTextField alloc] initWithFrame:CGRectMake(0, SCORESIZE, SCORESIZE, SCORESIZE)];
        textFieldOne.isOptionalDropDown = NO;
        [textFieldOne setItemList:@[@"0", @"15", @"30", @"40", @"Ad."]];
        textFieldOne.borderStyle = UITextBorderStyleLine;
        textFieldOne.textAlignment = NSTextAlignmentCenter;
        textFieldOne.text = @"0";
        textFieldOne.delegate = self;
        IQDropDownTextField *textFieldTwo = [[IQDropDownTextField alloc] initWithFrame:CGRectMake(0, 60, SCORESIZE, SCORESIZE)];
        textFieldTwo.isOptionalDropDown = NO;
        [textFieldTwo setItemList:@[@"0", @"15", @"30", @"40", @"Ad."]];
        textFieldTwo.borderStyle = UITextBorderStyleLine;
        textFieldTwo.textAlignment = NSTextAlignmentCenter;
        textFieldTwo.delegate = self;
        textFieldTwo.text = @"0";
        
        [scrollView addSubview:textFieldOne];
        [scrollView addSubview:textFieldTwo];
        NSDictionary *dict = @{ @"TextFieldOne" : textFieldOne, @"TextFieldTwo" : textFieldTwo, };
        
        [gamesTextViews addObject:dict];
        
        Game *newGame = [[Game alloc] init];
        
        [[tmp games] addObject:newGame];
        
        VBFPopFlatButton *addGameButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(([[tmp games] count])*SCORESIZE, scrollView.frame.size.height / 2 - 10, 15, 15) buttonType:buttonAddType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
        [addGameButton addTarget:self action:@selector(addNewGame:) forControlEvents:UIControlEventTouchUpInside];
        addGameButton.roundBackgroundColor = [UIColor asbestosColor];
        addGameButton.tintColor = [UIColor turquoiseColor];
        addGameButton.tag = indexPath.row;
        [addGameButton setCenter:CGPointMake(SCORESIZE*[[tmp games] count] + 20, 60 )];
        [scrollView addSubview:addGameButton];
        
        if (addGameButton.center.x + 15 > self.frame.size.width) {
            [scrollView setContentSize:CGSizeMake((_numSets+1)*SCORESIZE, _setsScrollView.frame.size.height)];
            [scrollView setContentOffset:CGPointMake((_numSets-4)*SCORESIZE, 0)];
        }
    }
    
    [_setGamesTextViews addObject:gamesTextViews];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    //if (indexPath.row == 0) {
    //    VBFPopFlatButton *newButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(cell.frame.size.width / 2 - 10, cell.frame.size.height / 2 - 10, 20, 20) buttonType:buttonAddType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
    //    [newButton setCenter:CGPointMake(cell.frame.size.width / 2, cell.frame.size.height / 2)];
    //    newButton.roundBackgroundColor = [UIColor asbestosColor];
    //    newButton.tintColor = [UIColor turquoiseColor];
    //    [newButton addTarget:self action:@selector(addNewSet) forControlEvents:UIControlEventTouchUpInside];
    //    [cell addSubview:newButton];
    //}
    //else {
        NSIndexPath *updatedPath = [NSIndexPath indexPathForItem:(_numSets - indexPath.row - 1) inSection:0];
        [self configureCell:cell withIndex:updatedPath];
    //}
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_setsArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"will display cell");
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
