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
#import "AppDelegate.h"
#import "NewMatchViewController.h"

@interface NewMatchView () <UITextFieldDelegate, IQDropDownTextFieldDelegate, FUIAlertViewDelegate>

@property(nonatomic,retain) VBFPopFlatButton *addMatchButton;
@property(nonatomic,retain) UIScrollView *setsScrollView;
@property(nonatomic,retain) NSMutableArray *setTextViews;
@property(nonatomic,retain) NSMutableArray *setGamesTextViews;

@property(nonatomic,retain) UIScrollView *bottomScrollView;

@property(nonatomic,retain) VBFPopFlatButton *teamOnePointUp;
@property(nonatomic,retain) VBFPopFlatButton *teamOnePointDown;
@property(nonatomic,retain) VBFPopFlatButton *teamTwoPointUp;
@property(nonatomic,retain) VBFPopFlatButton *teamTwoPointDown;

@property(nonatomic,retain) FUIButton *aceButton;
@property(nonatomic,retain) FUIButton *faultButton;
@property(nonatomic,retain) FUIButton *doubleFaultButton;

@property(nonatomic,retain) UIImageView *ballImage;

@property(nonatomic) int numSets;
@property(nonatomic) int numPlayerOneSets;
@property(nonatomic) int numPlayerTwoSets;
@property(nonatomic) int servingPlayer;

@end

#define PLAYERONE 0x10
#define PLAYERTWO 0x20

#define SCORESIZE   60
#define GAMESIZE    30
#define CELLHEIGHT  120

@implementation NewMatchView

-(instancetype)init {
    self = [super init];
    if (self) {
        //Configure the view
        //self.backgroundColor = [UIColor colorWithRed:0xad/0xff green:0xff/0xff blue:0x2f/0xff alpha:1.0];
        //[self setFrame:[UIScreen mainScreen].bounds];
        _match = [NSEntityDescription insertNewObjectForEntityForName:@"Match" inManagedObjectContext:[[AppDelegate sharedInstance] managedObjectContext]];
        
        _setsArray = [[NSMutableArray alloc] init];
        _setGamesTextViews = [[NSMutableArray alloc] init];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 220);
        gradient.locations = @[[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:1.0]];
        gradient.colors = @[(id)[[UIColor colorWithRed:0xad/0xff green:0xff/0xff blue:0x2f/0xff alpha:1.0] CGColor], (id)[[UIColor cloudsColor] CGColor]];
        [self.layer addSublayer:gradient];
        
        //_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 220, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 220)];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 220, [UIScreen mainScreen].bounds.size.width, 125)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        //_tableView.backgroundColor = [UIColor alizarinColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        _tableView.backgroundColor = [UIColor cloudsColor];
        
        
        CAGradientLayer *tableViewLayer = [CAGradientLayer layer];
        tableViewLayer.frame = CGRectMake(0, 340, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 100);
        NSArray *locations = @[[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0.25], [NSNumber numberWithFloat:0.6], [NSNumber numberWithFloat:0.75], [NSNumber numberWithFloat:1.0]];
        tableViewLayer.locations = locations;
        tableViewLayer.colors = @[(id)[[UIColor whiteColor] CGColor], (id)[[UIColor cloudsColor] CGColor], (id)[[UIColor alizarinColor] CGColor]];
        [self.layer insertSublayer:tableViewLayer atIndex:0];
         
        
        _setsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2, 90, [UIScreen mainScreen].bounds.size.width / 2, 120)];
        _setsScrollView.directionalLockEnabled = YES;
        //_setsScrollView.scrollEnabled = NO;
        [self addSubview:_setsScrollView];
        
        _isDoubles = false;
        _numSets = 0;
        
        _addMatchButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(SCORESIZE*_numSets + 25, _setsScrollView.frame.size.height / 2 - 5, 25, 25) buttonType:buttonAddType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
        [_addMatchButton addTarget:self action:@selector(addNewSet) forControlEvents:UIControlEventTouchUpInside];
        _addMatchButton.roundBackgroundColor = [UIColor asbestosColor];
        _addMatchButton.tintColor = [UIColor turquoiseColor];
        [_setsScrollView addSubview:_addMatchButton];
    
        _setTextViews = [[NSMutableArray alloc] init];
        
        if ([UIScreen mainScreen].bounds.size.height == 480) {
            [self setupSmallScreen];
        }
        
        else {
            [self setupScreen];
        }
        
        _ballImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 355, 20, 20)];
        _ballImage.backgroundColor = [UIColor yellowColor];
        _ballImage.layer.cornerRadius = 10;
        [self addSubview:_ballImage];
    }
    return self;
}

-(void)setupScreen {
    _teamOnePointUp = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30) buttonType:buttonUpBasicType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
    [_teamOnePointUp addTarget:self action:@selector(addPointToTeamOne) forControlEvents:UIControlEventTouchUpInside];
    [_teamOnePointUp setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/4, 430)];
    _teamOnePointUp.roundBackgroundColor = [UIColor asbestosColor];
    _teamOnePointUp.tintColor = [UIColor turquoiseColor];
    [self addSubview:_teamOnePointUp];
    
    _teamOnePointDown = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30) buttonType:buttonDownBasicType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
    [_teamOnePointDown addTarget:self action:@selector(subtractPointFromTeamOne) forControlEvents:UIControlEventTouchUpInside];
    [_teamOnePointDown setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/4, 520)];
    _teamOnePointDown.roundBackgroundColor = [UIColor asbestosColor];
    _teamOnePointDown.tintColor = [UIColor turquoiseColor];
    [self addSubview:_teamOnePointDown];
    
    _teamTwoPointUp = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30) buttonType:buttonUpBasicType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
    [_teamTwoPointUp addTarget:self action:@selector(addPointToTeamTwo) forControlEvents:UIControlEventTouchUpInside];
    [_teamTwoPointUp setCenter:CGPointMake(3*[UIScreen mainScreen].bounds.size.width/4, 430)];
    _teamTwoPointUp.roundBackgroundColor = [UIColor asbestosColor];
    _teamTwoPointUp.tintColor = [UIColor turquoiseColor];
    [self addSubview:_teamTwoPointUp];
    
    _teamTwoPointDown = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30) buttonType:buttonDownBasicType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
    [_teamTwoPointDown addTarget:self action:@selector(subtractPointFromTeamTwo) forControlEvents:UIControlEventTouchUpInside];
    [_teamTwoPointDown setCenter:CGPointMake(3*[UIScreen mainScreen].bounds.size.width/4, 520)];
    _teamTwoPointDown.roundBackgroundColor = [UIColor asbestosColor];
    _teamTwoPointDown.tintColor = [UIColor turquoiseColor];
    [self addSubview:_teamTwoPointDown];
    
    _aceButton = [[FUIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_aceButton setTitle:@"Ace" forState:UIControlStateNormal];
    _aceButton.titleLabel.font = [UIFont flatFontOfSize:14.0f];
    _aceButton.cornerRadius = 20;
    _aceButton.buttonColor = [UIColor asbestosColor];
    [_aceButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateNormal];
    [_aceButton addTarget:self action:@selector(addAceStat) forControlEvents:UIControlEventTouchUpInside];
    [_aceButton setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, 400)];
    [self addSubview:_aceButton];
    
    _faultButton = [[FUIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_faultButton setTitle:@"Fault" forState:UIControlStateNormal];
    _faultButton.titleLabel.font = [UIFont flatFontOfSize:12.0f];
    _faultButton.cornerRadius = 20;
    _faultButton.buttonColor = [UIColor asbestosColor];
    [_faultButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateNormal];
    [_faultButton addTarget:self action:@selector(addFaultStat) forControlEvents:UIControlEventTouchUpInside];
    [_faultButton setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, 475)];
    [self addSubview:_faultButton];
    
    _doubleFaultButton = [[FUIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_doubleFaultButton setTitle:@"DF" forState:UIControlStateNormal];
    _doubleFaultButton.titleLabel.font = [UIFont flatFontOfSize:12.0f];
    _doubleFaultButton.cornerRadius = 20;
    _doubleFaultButton.buttonColor = [UIColor asbestosColor];
    [_doubleFaultButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateNormal];
    [_doubleFaultButton addTarget:self action:@selector(addDoubleFaultStat) forControlEvents:UIControlEventTouchUpInside];
    [_doubleFaultButton setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, 550)];
    [self addSubview:_doubleFaultButton];
}

-(void)setupSmallScreen {
    _teamOnePointUp = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20) buttonType:buttonUpBasicType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
    [_teamOnePointUp addTarget:self action:@selector(addPointToTeamOne) forControlEvents:UIControlEventTouchUpInside];
    [_teamOnePointUp setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/4, 410)];
    _teamOnePointUp.roundBackgroundColor = [UIColor asbestosColor];
    _teamOnePointUp.tintColor = [UIColor turquoiseColor];
    [self addSubview:_teamOnePointUp];
    
    _teamOnePointDown = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20) buttonType:buttonDownBasicType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
    [_teamOnePointDown addTarget:self action:@selector(subtractPointFromTeamOne) forControlEvents:UIControlEventTouchUpInside];
    [_teamOnePointDown setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/4, 460)];
    _teamOnePointDown.roundBackgroundColor = [UIColor asbestosColor];
    _teamOnePointDown.tintColor = [UIColor turquoiseColor];
    [self addSubview:_teamOnePointDown];
    
    _teamTwoPointUp = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20) buttonType:buttonUpBasicType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
    [_teamTwoPointUp addTarget:self action:@selector(addPointToTeamTwo) forControlEvents:UIControlEventTouchUpInside];
    [_teamTwoPointUp setCenter:CGPointMake(3*[UIScreen mainScreen].bounds.size.width/4, 410)];
    _teamTwoPointUp.roundBackgroundColor = [UIColor asbestosColor];
    _teamTwoPointUp.tintColor = [UIColor turquoiseColor];
    [self addSubview:_teamTwoPointUp];
    
    _teamTwoPointDown = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20) buttonType:buttonDownBasicType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
    [_teamTwoPointDown addTarget:self action:@selector(subtractPointFromTeamTwo) forControlEvents:UIControlEventTouchUpInside];
    [_teamTwoPointDown setCenter:CGPointMake(3*[UIScreen mainScreen].bounds.size.width/4, 460)];
    _teamTwoPointDown.roundBackgroundColor = [UIColor asbestosColor];
    _teamTwoPointDown.tintColor = [UIColor turquoiseColor];
    [self addSubview:_teamTwoPointDown];
    
    _aceButton = [[FUIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_aceButton setTitle:@"Ace" forState:UIControlStateNormal];
    _aceButton.titleLabel.font = [UIFont flatFontOfSize:12.0f];
    _aceButton.cornerRadius = 15;
    _aceButton.buttonColor = [UIColor asbestosColor];
    [_aceButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateNormal];
    [_aceButton addTarget:self action:@selector(addAceStat) forControlEvents:UIControlEventTouchUpInside];
    [_aceButton setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, 390)];
    [self addSubview:_aceButton];
    
    _faultButton = [[FUIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_faultButton setTitle:@"Fault" forState:UIControlStateNormal];
    _faultButton.titleLabel.font = [UIFont flatFontOfSize:12.0f];
    _faultButton.cornerRadius = 15;
    _faultButton.buttonColor = [UIColor asbestosColor];
    [_faultButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateNormal];
    [_faultButton addTarget:self action:@selector(addFaultStat) forControlEvents:UIControlEventTouchUpInside];
    [_faultButton setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, 430)];
    [self addSubview:_faultButton];
    
    _doubleFaultButton = [[FUIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_doubleFaultButton setTitle:@"DF" forState:UIControlStateNormal];
    _doubleFaultButton.titleLabel.font = [UIFont flatFontOfSize:12.0f];
    _doubleFaultButton.cornerRadius = 15;
    _doubleFaultButton.buttonColor = [UIColor asbestosColor];
    [_doubleFaultButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateNormal];
    [_doubleFaultButton addTarget:self action:@selector(addDoubleFaultStat) forControlEvents:UIControlEventTouchUpInside];
    [_doubleFaultButton setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, 470)];
    [self addSubview:_doubleFaultButton];
}

-(void)addAceStat {
    
}

-(void)addFaultStat {
    
}

-(void)addDoubleFaultStat {
    
}

-(void)addPointToTeamOne {
    NSMutableArray *gamesArray = [_setGamesTextViews lastObject];
    NSDictionary *dict = [gamesArray lastObject];
    UITextField *oldFieldOne = (UITextField*)dict[@"TextFieldOne"];
    
    int score = 0;
    if ([oldFieldOne.text isEqualToString:@"Ad."]) {
        score = 50;
    }
    else {
        score = [oldFieldOne.text intValue];
    }
    
    switch (score) {
        case 0:
            oldFieldOne.text = @"15";
            break;
        case 15:
            oldFieldOne.text = @"30";
            break;
        case 30:
            oldFieldOne.text = @"40";
            break;
        case 40:
            oldFieldOne.text = @"\u2713";
            [self addNewGame:nil];
            break;
        case 50:
            oldFieldOne.text = @"\u2714";
            [self addNewGame:nil];
            break;
        default:
            break;
    }
}

-(void)subtractPointFromTeamOne {
    NSMutableArray *gamesArray = [_setGamesTextViews lastObject];
    NSDictionary *dict = [gamesArray lastObject];
    UITextField *oldFieldOne = (UITextField*)dict[@"TextFieldOne"];
}

-(void)addPointToTeamTwo {
    NSMutableArray *gamesArray = [_setGamesTextViews lastObject];
    NSDictionary *dict = [gamesArray lastObject];
    UITextField *oldFieldTwo = (UITextField*)dict[@"TextFieldTwo"];
    
    int score = 0;
    if ([oldFieldTwo.text isEqualToString:@"Ad."]) {
        score = 50;
    }
    else {
        score = [oldFieldTwo.text intValue];
    }
    
    switch (score) {
        case 0:
            oldFieldTwo.text = @"15";
            break;
        case 15:
            oldFieldTwo.text = @"30";
            break;
        case 30:
            oldFieldTwo.text = @"40";
            break;
        case 40:
            oldFieldTwo.text = @"\u2713";
            [self addNewGame:nil];
            break;
        case 50:
            oldFieldTwo.text = @"\u2714";
            [self addNewGame:nil];
            break;
        default:
            break;
    }
}

-(void)subtractPointFromTeamTwo {
    NSMutableArray *gamesArray = [_setGamesTextViews lastObject];
    NSDictionary *dict = [gamesArray lastObject];
    UITextField *oldFieldTwo = (UITextField*)dict[@"TextFieldTwo"];
}

-(void)setIsDoubles:(BOOL)isDoubles {
    _isDoubles = isDoubles;
}

-(void)setTeamOne:(Team *)teamOne {
    _teamOne = teamOne;
    [_teamOne setScore:[NSNumber numberWithInt:0]];
    [_match setTeamOne:_teamOne];
    
    UIImageView *imageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(5, 90, 3*SCORESIZE/4, 3*SCORESIZE/4)];
    imageViewOne.contentMode = UIViewContentModeScaleAspectFit;
    imageViewOne.layer.cornerRadius = 3*SCORESIZE/8;
    imageViewOne.layer.borderColor = [[UIColor grayColor] CGColor];
    imageViewOne.layer.borderWidth = 2.0;
    imageViewOne.layer.masksToBounds = YES;
    imageViewOne.image = [UIImage imageNamed:@"no-player-image.png"];
    if ([[teamOne playerOne] playerImage]) {
        imageViewOne.image = [UIImage imageWithData:[[teamOne playerOne] playerImage]];
    }
    [self addSubview:imageViewOne];
    
    UILabel *teamOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(3*SCORESIZE/4 + 25, 90, self.frame.size.width / 2 - 15 - SCORESIZE, SCORESIZE)];
    teamOneLabel.font = [UIFont boldFlatFontOfSize:20.0f];
    teamOneLabel.textAlignment = NSTextAlignmentRight;
    teamOneLabel.lineBreakMode = NSLineBreakByWordWrapping;
    teamOneLabel.numberOfLines = 0;
    teamOneLabel.text = [[teamOne playerOne] playerName];
    if (_isDoubles) {
        UIImageView *imageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(SCORESIZE/2, 90 + SCORESIZE/3, 3*SCORESIZE/4, 3*SCORESIZE/4)];
        imageViewTwo.contentMode = UIViewContentModeScaleAspectFit;
        imageViewTwo.layer.cornerRadius = (3*SCORESIZE/4)/2;
        imageViewTwo.layer.borderWidth = 2.0;
        imageViewTwo.layer.borderColor = [[UIColor grayColor] CGColor];
        imageViewTwo.layer.masksToBounds = YES;
        imageViewTwo.image = [UIImage imageNamed:@"no-player-image.png"];
        if ([[teamOne playerTwo] playerImage]) {
            imageViewTwo.image = [UIImage imageWithData:[[teamOne playerTwo] playerImage]];
        }
        [self addSubview:imageViewTwo];
        
        teamOneLabel.text = [teamOneLabel.text stringByAppendingString:@" & "];
        teamOneLabel.text = [teamOneLabel.text stringByAppendingString:[[teamOne playerTwo] playerName]];
    }
    [self addSubview:teamOneLabel];
    
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        UILabel *teamOneBottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 340, [UIScreen mainScreen].bounds.size.width/2, 60)];
        teamOneBottomLabel.backgroundColor = [UIColor clearColor];
        teamOneBottomLabel.textAlignment = NSTextAlignmentCenter;
        teamOneBottomLabel.font = [UIFont flatFontOfSize:14.0f];
        teamOneBottomLabel.lineBreakMode = NSLineBreakByWordWrapping;
        teamOneBottomLabel.numberOfLines = 0;
        teamOneBottomLabel.text = [[teamOne playerOne] playerName];
        if (_isDoubles) {
            teamOneBottomLabel.text = [teamOneBottomLabel.text stringByAppendingString:@" &\n"];
            teamOneBottomLabel.text = [teamOneBottomLabel.text stringByAppendingString:[[teamOne playerTwo] playerName]];
        }
        [self addSubview:teamOneBottomLabel];
    }
    else {
        UILabel *teamOneBottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 340, [UIScreen mainScreen].bounds.size.width/2, 60)];
        teamOneBottomLabel.backgroundColor = [UIColor clearColor];
        teamOneBottomLabel.textAlignment = NSTextAlignmentCenter;
        teamOneBottomLabel.font = [UIFont flatFontOfSize:16.0f];
        teamOneBottomLabel.lineBreakMode = NSLineBreakByWordWrapping;
        teamOneBottomLabel.numberOfLines = 0;
        teamOneBottomLabel.text = [[teamOne playerOne] playerName];
        if (_isDoubles) {
            teamOneBottomLabel.text = [teamOneBottomLabel.text stringByAppendingString:@" &\n"];
            teamOneBottomLabel.text = [teamOneBottomLabel.text stringByAppendingString:[[teamOne playerTwo] playerName]];
        }
        [self addSubview:teamOneBottomLabel];
    }
    
}

-(void)setTeamTwo:(Team *)teamTwo {
    _teamTwo = teamTwo;
    [_teamTwo setScore:[NSNumber numberWithInt:0]];
    [_match setTeamTwo:_teamTwo];
    
    UIImageView *imageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(5, 150, 3*SCORESIZE/4, 3*SCORESIZE/4)];
    imageViewOne.contentMode = UIViewContentModeScaleAspectFit;
    imageViewOne.layer.cornerRadius = 3*SCORESIZE/8;
    imageViewOne.layer.borderColor = [[UIColor grayColor] CGColor];
    imageViewOne.layer.borderWidth = 2.0;
    imageViewOne.layer.masksToBounds = YES;
    imageViewOne.image = [UIImage imageNamed:@"no-player-image.png"];
    if ([[teamTwo playerOne] playerImage]) {
        imageViewOne.image = [UIImage imageWithData:[[teamTwo playerOne] playerImage]];
    }
    [self addSubview:imageViewOne];
    
    UILabel *teamTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(3*SCORESIZE/4 + 25, 150, self.frame.size.width / 2 - 15  - SCORESIZE, SCORESIZE)];
    teamTwoLabel.font = [UIFont boldFlatFontOfSize:20.0f];
    teamTwoLabel.textAlignment = NSTextAlignmentRight;
    teamTwoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    teamTwoLabel.numberOfLines = 0;
    teamTwoLabel.text = [[teamTwo playerOne] playerName];
    if (_isDoubles) {
        UIImageView *imageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(SCORESIZE/2, SCORESIZE/3 + 150, 3*SCORESIZE/4, 3*SCORESIZE/4)];
        imageViewTwo.contentMode = UIViewContentModeScaleAspectFit;
        imageViewTwo.layer.cornerRadius = 3*SCORESIZE/8;
        imageViewTwo.layer.borderWidth = 2.0;
        imageViewTwo.layer.borderColor = [[UIColor grayColor] CGColor];
        imageViewOne.layer.masksToBounds = YES;
        imageViewTwo.image = [UIImage imageNamed:@"no-player-image.png"];
        if ([[teamTwo playerTwo] playerImage]) {
            imageViewTwo.image = [UIImage imageWithData:[[teamTwo playerTwo] playerImage]];
        }
        [self addSubview:imageViewTwo];
        
        teamTwoLabel.text = [teamTwoLabel.text stringByAppendingString:@" & "];
        teamTwoLabel.text = [teamTwoLabel.text stringByAppendingString:[[teamTwo playerTwo] playerName]];
    }
    [self addSubview:teamTwoLabel];
    
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        UILabel *teamTwoBottomLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 340, [UIScreen mainScreen].bounds.size.width/2, 60)];
        teamTwoBottomLabel.backgroundColor = [UIColor clearColor];
        teamTwoBottomLabel.textAlignment = NSTextAlignmentCenter;
        teamTwoBottomLabel.font = [UIFont flatFontOfSize:14.0f];
        teamTwoBottomLabel.lineBreakMode = NSLineBreakByWordWrapping;
        teamTwoBottomLabel.numberOfLines = 0;
        teamTwoBottomLabel.text = [[teamTwo playerOne] playerName];
        if (_isDoubles) {
            teamTwoBottomLabel.text = [teamTwoBottomLabel.text stringByAppendingString:@" &\n"];
            teamTwoBottomLabel.text = [teamTwoBottomLabel.text stringByAppendingString:[[teamTwo playerTwo] playerName]];
        }
        [self addSubview:teamTwoBottomLabel];
    }
    else {
        UILabel *teamTwoBottomLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 340, [UIScreen mainScreen].bounds.size.width/2, 60)];
        teamTwoBottomLabel.backgroundColor = [UIColor clearColor];
        teamTwoBottomLabel.textAlignment = NSTextAlignmentCenter;
        teamTwoBottomLabel.font = [UIFont flatFontOfSize:16.0f];
        teamTwoBottomLabel.lineBreakMode = NSLineBreakByWordWrapping;
        teamTwoBottomLabel.numberOfLines = 0;
        teamTwoBottomLabel.text = [[teamTwo playerOne] playerName];
        if (_isDoubles) {
            teamTwoBottomLabel.text = [teamTwoBottomLabel.text stringByAppendingString:@" &\n"];
            teamTwoBottomLabel.text = [teamTwoBottomLabel.text stringByAppendingString:[[teamTwo playerTwo] playerName]];
        }
        [self addSubview:teamTwoBottomLabel];
    }
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
    
    [_addMatchButton setCenter:CGPointMake(SCORESIZE*_numSets + 25, _setsScrollView.frame.size.height / 2 )];
    
    if (_addMatchButton.center.x + 15 > self.frame.size.width/2) {
        [_setsScrollView setContentSize:CGSizeMake((_numSets+1)*SCORESIZE, _setsScrollView.frame.size.height)];
        [_setsScrollView setContentOffset:CGPointMake((_numSets-2)*SCORESIZE, 0)];
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
    
    /*
    switch ([tmp hasWinner]) {
        case 1: {
            tmp1.layer.borderWidth = 2.0;
            tmp1.font = [UIFont boldSystemFontOfSize:18.0f];
            int oldScore = [[_teamOne score] intValue];
            [_teamOne setScore:[NSNumber numberWithInt:oldScore+1]];
            break;
        }
        case 2: {
            tmp2.layer.borderWidth = 2.0;
            tmp2.font = [UIFont boldSystemFontOfSize:18.0f];
            int oldScore = [[_teamTwo score] intValue];
            [_teamTwo setScore:[NSNumber numberWithInt:oldScore+1]];
            break;
        }
            
        default:
            break;
    }
     */
    
    if ([_setsArray objectAtIndex:(_numSets-1)] == nil) {
        [self addNewSetColumn];
        
        Set *newSet = [[Set alloc] init];
        [_setsArray addObject:newSet];
        [_tableView reloadData];
    }
    else if (![[_setsArray objectAtIndex:(_numSets-1)] hasWinner]) {
        /*
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
                
                int oldGamesPlayed = [[[_teamOne playerOne] playerSetsPlayed] intValue];
                oldGamesPlayed += 1;
                [[_teamOne playerOne] setPlayerSetsPlayed:[NSNumber numberWithInt:oldGamesPlayed]];
                oldGamesPlayed = [[[_teamTwo playerOne] playerSetsPlayed] intValue];
                oldGamesPlayed += 1;
                [[_teamTwo playerOne] setPlayerSetsPlayed:[NSNumber numberWithInt:oldGamesPlayed]];
                
                if (_isDoubles) {
                    oldGamesPlayed = [[[_teamOne playerTwo] playerSetsPlayed] intValue];
                    oldGamesPlayed += 1;
                    [[_teamOne playerTwo] setPlayerSetsPlayed:[NSNumber numberWithInt:oldGamesPlayed]];
                    
                    oldGamesPlayed = [[[_teamTwo playerTwo] playerSetsPlayed] intValue];
                    oldGamesPlayed += 1;
                    [[_teamTwo playerTwo] setPlayerSetsPlayed:[NSNumber numberWithInt:oldGamesPlayed]];
                }
                
                switch ([tmp hasWinner]) {
                    case 1: {
                        tmp1.layer.borderWidth = 2.0;
                        tmp1.font = [UIFont boldSystemFontOfSize:18.0f];
                        int oldScore = [[_teamOne score] intValue];
                        [_teamOne setScore:[NSNumber numberWithInt:oldScore+1]];
                        
                        oldScore = [[[_teamOne playerOne] playerSetsWon] intValue];
                        oldScore += 1;
                        [[_teamOne playerOne] setPlayerSetsWon:[NSNumber numberWithInt:oldScore]];
                        if (_isDoubles) {
                            oldScore = [[[_teamOne playerTwo] playerSetsWon] intValue];
                            oldScore += 1;
                            [[_teamOne playerTwo] setPlayerSetsWon:[NSNumber numberWithInt:oldScore]];
                        }
                        break;
                    }
                    case 2: {
                        tmp2.layer.borderWidth = 2.0;
                        tmp2.font = [UIFont boldSystemFontOfSize:18.0f];
                        int oldScore = [[_teamTwo score] intValue];
                        [_teamTwo setScore:[NSNumber numberWithInt:oldScore+1]];
                        
                        oldScore = [[[_teamTwo playerOne] playerSetsWon] intValue];
                        oldScore += 1;
                        [[_teamTwo playerOne] setPlayerSetsWon:[NSNumber numberWithInt:oldScore]];
                        if (_isDoubles) {
                            oldScore = [[[_teamTwo playerTwo] playerSetsWon] intValue];
                            oldScore += 1;
                            [[_teamTwo playerTwo] setPlayerSetsWon:[NSNumber numberWithInt:oldScore]];
                        }
                        break;
                    }
                        
                    default:
                        break;
                }
                
                if ([_match matchWinner]) {
                    FUIAlertView *winnerAlert = [[FUIAlertView alloc] initWithTitle:@"We Have a Winner!" message:@"Save data so we you can check out your matches later.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    winnerAlert.titleLabel.textColor = [UIColor alizarinColor];
                    winnerAlert.titleLabel.font = [UIFont boldFlatFontOfSize:16.0f];
                    winnerAlert.messageLabel.textColor = [UIColor alizarinColor];
                    winnerAlert.messageLabel.font = [UIFont flatFontOfSize:14.0f];
                    winnerAlert.alertContainer.backgroundColor = [UIColor midnightBlueColor];
                    winnerAlert.defaultButtonColor = [UIColor asbestosColor];
                    winnerAlert.defaultButtonTitleColor = [UIColor turquoiseColor];
                    winnerAlert.defaultButtonFont = [UIFont boldFlatFontOfSize:16.0f];
                    winnerAlert.defaultButtonShadowColor = [UIColor grayColor];
                    winnerAlert.backgroundOverlay.backgroundColor = [UIColor clearColor];
                    [winnerAlert show];
                    
                    NewMatchViewController *vc = (NewMatchViewController*)_parentViewContoller;
                    [vc canSave];
                    [_addMatchButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
                    
                    int oldGamesPlayed = [[[_teamOne playerOne] playerMatchesPlayed] intValue];
                    oldGamesPlayed += 1;
                    [[_teamOne playerOne] setPlayerMatchesPlayed:[NSNumber numberWithInt:oldGamesPlayed]];
                    oldGamesPlayed = [[[_teamTwo playerOne] playerMatchesPlayed] intValue];
                    oldGamesPlayed += 1;
                    [[_teamTwo playerOne] setPlayerMatchesPlayed:[NSNumber numberWithInt:oldGamesPlayed]];
                    
                    if (_isDoubles) {
                        oldGamesPlayed = [[[_teamOne playerTwo] playerMatchesPlayed] intValue];
                        oldGamesPlayed += 1;
                        [[_teamOne playerTwo] setPlayerMatchesPlayed:[NSNumber numberWithInt:oldGamesPlayed]];
                        
                        oldGamesPlayed = [[[_teamTwo playerTwo] playerMatchesPlayed] intValue];
                        oldGamesPlayed += 1;
                        [[_teamTwo playerTwo] setPlayerMatchesPlayed:[NSNumber numberWithInt:oldGamesPlayed]];
                    }
                    
                    switch ([_match matchWinner]) {
                        case 1:{
                            int oldScore = [[[_teamOne playerOne] playerMatchesWon] intValue];
                            oldScore += 1;
                            [[_teamOne playerOne] setPlayerMatchesWon:[NSNumber numberWithInt:oldScore]];
                            if (_isDoubles) {
                                oldScore = [[[_teamOne playerTwo] playerMatchesWon] intValue];
                                oldScore += 1;
                                [[_teamOne playerTwo] setPlayerMatchesWon:[NSNumber numberWithInt:oldScore]];
                            }
                            break;
                        }
                        case 2:{
                            int oldScore = [[[_teamTwo playerOne] playerMatchesWon] intValue];
                            oldScore += 1;
                            [[_teamTwo playerOne] setPlayerMatchesWon:[NSNumber numberWithInt:oldScore]];
                            if (_isDoubles) {
                                oldScore = [[[_teamTwo playerTwo] playerMatchesWon] intValue];
                                oldScore += 1;
                                [[_teamTwo playerTwo] setPlayerMatchesWon:[NSNumber numberWithInt:oldScore]];
                            }
                            break;
                        }
                            
                        default:
                            break;
                    }
                }
                else {
                    [self addNewSetColumn];
                }
                
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
        */
        
        FUIAlertView *winnerAlert = [[FUIAlertView alloc] initWithTitle:@"What was the score??" message:@"It appears we don't have a clear winner.. Enter the score in the score board and try to add a set again.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        winnerAlert.titleLabel.textColor = [UIColor alizarinColor];
        winnerAlert.titleLabel.font = [UIFont boldFlatFontOfSize:16.0f];
        winnerAlert.messageLabel.textColor = [UIColor alizarinColor];
        winnerAlert.messageLabel.font = [UIFont flatFontOfSize:14.0f];
        winnerAlert.alertContainer.backgroundColor = [UIColor midnightBlueColor];
        winnerAlert.defaultButtonColor = [UIColor asbestosColor];
        winnerAlert.defaultButtonTitleColor = [UIColor turquoiseColor];
        winnerAlert.defaultButtonFont = [UIFont boldFlatFontOfSize:16.0f];
        winnerAlert.defaultButtonShadowColor = [UIColor grayColor];
        winnerAlert.backgroundOverlay.backgroundColor = [UIColor clearColor];
        [winnerAlert show];
        
    }
    else {
        
        int gamesPlayed = [[tmp1 text] intValue] + [[tmp2 text] intValue];
        int gamesTeamOneWon = [[tmp1 text] intValue];
        int gamesTeamTwoWon = [[tmp2 text] intValue];
        
        int gamesTeamOnePlayerOnePlayed = [[[_teamOne playerOne] playerGamesPlayed] intValue];
        int gamesTeamOnePlayerOneWon = [[[_teamOne playerOne] playerGamesWon] intValue];
        [[_teamOne playerOne] setPlayerGamesPlayed:[NSNumber numberWithInt:(gamesPlayed + gamesTeamOnePlayerOnePlayed)]];
        [[_teamOne playerOne] setPlayerGamesWon:[NSNumber numberWithInt:(gamesTeamOneWon + gamesTeamOnePlayerOneWon)]];
        if (_isDoubles) {
            int gamesTeamOnePlayerTwoPlayed = [[[_teamOne playerTwo] playerGamesPlayed] intValue];
            int gamesTeamOnePlayerTwoWon = [[[_teamOne playerTwo] playerGamesWon] intValue];
            [[_teamOne playerTwo] setPlayerGamesPlayed:[NSNumber numberWithInt:(gamesPlayed + gamesTeamOnePlayerTwoPlayed)]];
            [[_teamOne playerTwo] setPlayerGamesWon:[NSNumber numberWithInt:(gamesTeamOneWon + gamesTeamOnePlayerTwoWon)]];
        }
        
        int gamesTeamTwoPlayerOnePlayed = [[[_teamTwo playerOne] playerGamesPlayed] intValue];
        int gamesTeamTwoPlayerOneWon = [[[_teamTwo playerOne] playerGamesWon] intValue];
        [[_teamTwo playerOne] setPlayerGamesPlayed:[NSNumber numberWithInt:(gamesPlayed + gamesTeamTwoPlayerOnePlayed)]];
        [[_teamTwo playerOne] setPlayerGamesWon:[NSNumber numberWithInt:(gamesTeamTwoWon + gamesTeamTwoPlayerOneWon)]];
        if (_isDoubles) {
            int gamesTeamTwoPlayerTwoPlayed = [[[_teamTwo playerTwo] playerGamesPlayed] intValue];
            int gamesTeamTwoPlayerTwoWon = [[[_teamTwo playerTwo] playerGamesWon] intValue];
            [[_teamTwo playerTwo] setPlayerGamesPlayed:[NSNumber numberWithInt:(gamesPlayed + gamesTeamTwoPlayerTwoPlayed)]];
            [[_teamTwo playerTwo] setPlayerGamesWon:[NSNumber numberWithInt:(gamesTeamTwoWon + gamesTeamTwoPlayerTwoWon)]];
        }
        
        int oldSetsPlayed = [[[_teamOne playerOne] playerSetsPlayed] intValue];
        oldSetsPlayed += 1;
        [[_teamOne playerOne] setPlayerSetsPlayed:[NSNumber numberWithInt:oldSetsPlayed]];
        oldSetsPlayed = [[[_teamTwo playerOne] playerSetsPlayed] intValue];
        oldSetsPlayed += 1;
        [[_teamTwo playerOne] setPlayerSetsPlayed:[NSNumber numberWithInt:oldSetsPlayed]];
        
        if (_isDoubles) {
            oldSetsPlayed = [[[_teamOne playerTwo] playerSetsPlayed] intValue];
            oldSetsPlayed += 1;
            [[_teamOne playerTwo] setPlayerSetsPlayed:[NSNumber numberWithInt:oldSetsPlayed]];
            
            oldSetsPlayed = [[[_teamTwo playerTwo] playerSetsPlayed] intValue];
            oldSetsPlayed += 1;
            [[_teamTwo playerTwo] setPlayerSetsPlayed:[NSNumber numberWithInt:oldSetsPlayed]];
        }
        
        switch ([tmp hasWinner]) {
            case 1: {
                tmp1.layer.borderWidth = 2.0;
                tmp1.font = [UIFont boldSystemFontOfSize:18.0f];
                int oldScore = [[_teamOne score] intValue];
                [_teamOne setScore:[NSNumber numberWithInt:oldScore+1]];
                
                oldScore = [[[_teamOne playerOne] playerSetsWon] intValue];
                oldScore += 1;
                [[_teamOne playerOne] setPlayerSetsWon:[NSNumber numberWithInt:oldScore]];
                if (_isDoubles) {
                    oldScore = [[[_teamOne playerTwo] playerSetsWon] intValue];
                    oldScore += 1;
                    [[_teamOne playerTwo] setPlayerSetsWon:[NSNumber numberWithInt:oldScore]];
                }
                break;
            }
            case 2: {
                tmp2.layer.borderWidth = 2.0;
                tmp2.font = [UIFont boldSystemFontOfSize:18.0f];
                int oldScore = [[_teamTwo score] intValue];
                [_teamTwo setScore:[NSNumber numberWithInt:oldScore+1]];
                
                oldScore = [[[_teamTwo playerOne] playerSetsWon] intValue];
                oldScore += 1;
                [[_teamTwo playerOne] setPlayerSetsWon:[NSNumber numberWithInt:oldScore]];
                if (_isDoubles) {
                    oldScore = [[[_teamTwo playerTwo] playerSetsWon] intValue];
                    oldScore += 1;
                    [[_teamTwo playerTwo] setPlayerSetsWon:[NSNumber numberWithInt:oldScore]];
                }
                break;
            }
                
            default:
                break;
        }
        
        if ([_match matchWinner]) {
            FUIAlertView *winnerAlert = [[FUIAlertView alloc] initWithTitle:@"We Have a Winner!" message:@"Save data so we you can check out your matches later.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            winnerAlert.titleLabel.textColor = [UIColor alizarinColor];
            winnerAlert.titleLabel.font = [UIFont boldFlatFontOfSize:16.0f];
            winnerAlert.messageLabel.textColor = [UIColor alizarinColor];
            winnerAlert.messageLabel.font = [UIFont flatFontOfSize:14.0f];
            winnerAlert.alertContainer.backgroundColor = [UIColor midnightBlueColor];
            winnerAlert.defaultButtonColor = [UIColor asbestosColor];
            winnerAlert.defaultButtonTitleColor = [UIColor turquoiseColor];
            winnerAlert.defaultButtonFont = [UIFont boldFlatFontOfSize:16.0f];
            winnerAlert.defaultButtonShadowColor = [UIColor grayColor];
            winnerAlert.backgroundOverlay.backgroundColor = [UIColor clearColor];
            [winnerAlert show];
            
            NewMatchViewController *vc = (NewMatchViewController*)_parentViewContoller;
            [vc canSave];
            [_addMatchButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
            
            int oldGamesPlayed = [[[_teamOne playerOne] playerMatchesPlayed] intValue];
            oldGamesPlayed += 1;
            [[_teamOne playerOne] setPlayerMatchesPlayed:[NSNumber numberWithInt:oldGamesPlayed]];
            oldGamesPlayed = [[[_teamTwo playerOne] playerMatchesPlayed] intValue];
            oldGamesPlayed += 1;
            [[_teamTwo playerOne] setPlayerMatchesPlayed:[NSNumber numberWithInt:oldGamesPlayed]];
            
            if (_isDoubles) {
                oldGamesPlayed = [[[_teamOne playerTwo] playerMatchesPlayed] intValue];
                oldGamesPlayed += 1;
                [[_teamOne playerTwo] setPlayerMatchesPlayed:[NSNumber numberWithInt:oldGamesPlayed]];
                
                oldGamesPlayed = [[[_teamTwo playerTwo] playerMatchesPlayed] intValue];
                oldGamesPlayed += 1;
                [[_teamTwo playerTwo] setPlayerMatchesPlayed:[NSNumber numberWithInt:oldGamesPlayed]];
            }
            
            switch ([_match matchWinner]) {
                case 1:{
                    int oldScore = [[[_teamOne playerOne] playerMatchesWon] intValue];
                    oldScore += 1;
                    [[_teamOne playerOne] setPlayerMatchesWon:[NSNumber numberWithInt:oldScore]];
                    if (_isDoubles) {
                        oldScore = [[[_teamOne playerTwo] playerMatchesWon] intValue];
                        oldScore += 1;
                        [[_teamOne playerTwo] setPlayerMatchesWon:[NSNumber numberWithInt:oldScore]];
                    }
                    break;
                }
                case 2:{
                    int oldScore = [[[_teamTwo playerOne] playerMatchesWon] intValue];
                    oldScore += 1;
                    [[_teamTwo playerOne] setPlayerMatchesWon:[NSNumber numberWithInt:oldScore]];
                    if (_isDoubles) {
                        oldScore = [[[_teamTwo playerTwo] playerMatchesWon] intValue];
                        oldScore += 1;
                        [[_teamTwo playerTwo] setPlayerMatchesWon:[NSNumber numberWithInt:oldScore]];
                    }
                    break;
                }
                    
                default:
                    break;
            }
        }
        else {
            [self addNewSetColumn];
            
            Set *newSet = [[Set alloc] init];
            [_setsArray addObject:newSet];
            [_tableView reloadData];
        }
        //[self addNewSetColumn];
        
        //Set *newSet = [[Set alloc] init];
        //[_setsArray addObject:newSet];
        //[_tableView reloadData];
    }
    
    if (_numSets >= 3) {
        [_addMatchButton animateToType:buttonOkType];
        //[_addMatchButton addTarget:self action:@selector(matchCancelButton) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)matchCancelButton {
    //maybe something to do later.. atm can't think of anything..
}

-(void)addNewGame:(id)sender {
    
    //VBFPopFlatButton *button = (VBFPopFlatButton*)sender;
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_numSets - button.tag - 1) inSection:0];
    NSInteger totalRow = [_tableView numberOfRowsInSection:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:totalRow - 1 inSection:0];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    
    //NSMutableArray *gamesArray = [_setGamesTextViews objectAtIndex:button.tag];
    NSMutableArray *gamesArray = [_setGamesTextViews lastObject];
    NSDictionary *dict = [gamesArray lastObject];
    UITextField *oldFieldOne = (UITextField*)dict[@"TextFieldOne"];
    UITextField *oldFieldTwo = (UITextField*)dict[@"TextFieldTwo"];
    
    //Set *tmp = [_setsArray objectAtIndex:button.tag];
    Set *tmp = [_setsArray lastObject];
    Game *game = (Game*)[[tmp games] lastObject];
    
    if ([[oldFieldOne text] isEqualToString:@"Ad."] || [[oldFieldOne text] isEqualToString:@"\u2713"]) {
        [game setTeamOneScore:[NSNumber numberWithInt:50]];
    }
    else if ([[oldFieldOne text] isEqualToString:@"\u2714"]) {
        [game setTeamOneScore:[NSNumber numberWithInt:60]];
    }
    else {
        [game setTeamOneScore:[NSNumber numberWithInt:[[oldFieldOne text] intValue]]];
    }
    if ([[oldFieldTwo text] isEqualToString:@"Ad."] || [[oldFieldTwo text] isEqualToString:@"\u2713"]) {
        [game setTeamTwoScore:[NSNumber numberWithInt:50]];
    }
    else if ([[oldFieldTwo text] isEqualToString:@"\u2714"]) {
        [game setTeamOneScore:[NSNumber numberWithInt:60]];
    }
    else {
        [game setTeamTwoScore:[NSNumber numberWithInt:[[oldFieldTwo text] intValue]]];
    }
    
    dict = [_setTextViews lastObject];
    IQDropDownTextField *setOneField = (IQDropDownTextField*)dict[@"TextFieldOne"];
    IQDropDownTextField *setTwoField = (IQDropDownTextField*)dict[@"TextFieldTwo"];
    
    switch ([game gameWinner]) {
        case 1:{
            int lastScore = [[setOneField text] intValue];
            lastScore += 1;
            [setOneField setText:[[NSNumber numberWithInt:lastScore] stringValue]];
            [tmp setTeamOneScore:[NSNumber numberWithInt:lastScore]];
            [oldFieldOne setEnabled:NO];
            [oldFieldTwo setEnabled:NO];
            break;
        }
        case 2:{
            int lastScore = [[setTwoField text] intValue];
            lastScore += 1;
            [setTwoField setText:[[NSNumber numberWithInt:lastScore] stringValue]];
            [tmp setTeamTwoScore:[NSNumber numberWithInt:lastScore]];
            [oldFieldOne setEnabled:NO];
            [oldFieldTwo setEnabled:NO];
            break;
        }
        case 0:{
            if (([[game teamOneScore] intValue] == 50) && ([[game teamTwoScore] intValue] == 50)) {
                oldFieldOne.text = @"40";
                oldFieldTwo.text = @"40";
            }
            else if ([[game teamOneScore] intValue] == 50) {
                oldFieldOne.text = @"Ad.";
            }
            else if ([[game teamTwoScore] intValue] == 50) {
                oldFieldTwo.text = @"Ad.";
            }
            else {
                FUIAlertView *winnerAlert = [[FUIAlertView alloc] initWithTitle:@"What was the score??" message:@"It appears we don't have a clear winner.. Enter the score in the score board and try to add a game again.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                winnerAlert.titleLabel.textColor = [UIColor alizarinColor];
                winnerAlert.titleLabel.font = [UIFont boldFlatFontOfSize:16.0f];
                winnerAlert.messageLabel.textColor = [UIColor alizarinColor];
                winnerAlert.messageLabel.font = [UIFont flatFontOfSize:14.0f];
                winnerAlert.alertContainer.backgroundColor = [UIColor midnightBlueColor];
                winnerAlert.defaultButtonColor = [UIColor asbestosColor];
                winnerAlert.defaultButtonTitleColor = [UIColor turquoiseColor];
                winnerAlert.defaultButtonFont = [UIFont boldFlatFontOfSize:16.0f];
                winnerAlert.defaultButtonShadowColor = [UIColor grayColor];
                winnerAlert.backgroundOverlay.backgroundColor = [UIColor clearColor];
                [winnerAlert show];
            }
            
            break;
        }
            
        default:
            break;
    }
    
    if (![game gameWinner]) {
        //Do nothing and wait for a valid score
        if ([[tmp teamOneScore] intValue] == 50) {
            [tmp setTeamOneScore:[NSNumber numberWithInt:40]];
            oldFieldOne.text = @"Ad.";
        }
        else if ([[tmp teamTwoScore] intValue] == 50) {
            [tmp setTeamTwoScore:[NSNumber numberWithInt:40]];
            oldFieldTwo.text = @"Ad.";
        }
    }
    else if ([tmp hasWinner]) {
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
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(GAMESIZE*[[tmp games] count], 0, GAMESIZE, GAMESIZE)];
        label.text = [[NSNumber numberWithInteger:([[tmp games] count]+1)] stringValue];
        label.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:label];
        
        IQDropDownTextField *textFieldOne = [[IQDropDownTextField alloc] initWithFrame:CGRectMake(GAMESIZE*[[tmp games] count], GAMESIZE, GAMESIZE, GAMESIZE)];
        textFieldOne.adjustsFontSizeToFitWidth = YES;
        textFieldOne.isOptionalDropDown = NO;
        [textFieldOne setItemList:@[@"0", @"15", @"30", @"40", @"Ad."]];
        textFieldOne.delegate = self;
        textFieldOne.borderStyle = UITextBorderStyleLine;
        textFieldOne.textAlignment = NSTextAlignmentCenter;
        textFieldOne.text = @"0";
        IQDropDownTextField *textFieldTwo = [[IQDropDownTextField alloc] initWithFrame:CGRectMake(GAMESIZE*[[tmp games] count], GAMESIZE*2, GAMESIZE, GAMESIZE)];
        textFieldTwo.adjustsFontSizeToFitWidth = YES;
        textFieldTwo.isOptionalDropDown = NO;
        [textFieldTwo setItemList:@[@"0", @"15", @"30", @"40", @"Ad."]];
        textFieldTwo.delegate = self;
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
        [tmpButton setCenter:CGPointMake(GAMESIZE*[[tmp games] count] + 20, cell.frame.size.height / 2 )];
        //[scrollView addSubview:addGameButton];
        
        if (tmpButton.center.x + GAMESIZE > (self.frame.size.width / 2)) {
            [scrollView setContentSize:CGSizeMake(([[tmp games] count]+1)*GAMESIZE, _setsScrollView.frame.size.height)];
            [scrollView setContentOffset:CGPointMake(([[tmp games] count]-4)*GAMESIZE, 0) animated:YES];
        }
    }
}

-(void)textField:(IQDropDownTextField *)textField didSelectItem:(NSString *)item {
    [textField resignFirstResponder];
    NSLog(@"text field did select item");
}

-(void)configureCell:(UITableViewCell *)cell withIndex:(NSIndexPath *)indexPath {
    //Add team one label to the cell
    cell.backgroundColor = [UIColor cloudsColor];
    
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
    teamOneLabel.text = [[_teamOne playerOne] playerName];
    if (_isDoubles) {
        teamOneLabel.text = [teamOneLabel.text stringByAppendingString:@" & "];
        teamOneLabel.text = [teamOneLabel.text stringByAppendingString:[[_teamOne playerTwo] playerName]];
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
    teamTwoLabel.text = [[_teamTwo playerOne] playerName];
    if (_isDoubles) {
        teamTwoLabel.text = [teamTwoLabel.text stringByAppendingString:@" & "];
        teamTwoLabel.text = [teamTwoLabel.text stringByAppendingString:[[_teamTwo playerTwo] playerName]];
    }
    [cell addSubview:teamTwoLabel];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2, 0, cell.frame.size.width / 2, GAMESIZE*3)];
    [cell addSubview:scrollView];
    
    Set *tmp = [_setsArray objectAtIndex:indexPath.row];
    NSMutableArray *gamesTextViews = [[NSMutableArray alloc] init];
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
            
            NSDictionary *dict = @{ @"TextFieldOne" : textFieldOne, @"TextFieldTwo" : textFieldTwo, };
            [gamesTextViews addObject:dict];
            
            if (![tmp hasWinner]) {
                //add a button
                Game *newGame = [[Game alloc] init];
                
                [[tmp games] addObject:newGame];
                
                VBFPopFlatButton *addGameButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(([[tmp games] count])*GAMESIZE, scrollView.frame.size.height / 2 - 10, 15, 15) buttonType:buttonAddType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
                [addGameButton addTarget:self action:@selector(addNewGame:) forControlEvents:UIControlEventTouchUpInside];
                addGameButton.roundBackgroundColor = [UIColor asbestosColor];
                addGameButton.tintColor = [UIColor turquoiseColor];
                addGameButton.tag = indexPath.row;
                [addGameButton setCenter:CGPointMake(GAMESIZE*[[tmp games] count] + 20, 60/*scrollView.frame.size.height / 2*/ )];
                [scrollView addSubview:addGameButton];
                
                if (addGameButton.center.x + 15 > self.frame.size.width) {
                    [scrollView setContentSize:CGSizeMake(([[tmp games] count]+1)*GAMESIZE, 90)];
                    [scrollView setContentOffset:CGPointMake(([[tmp games] count]-4)*GAMESIZE, 0)];
                }
            }
        }
    }
    else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, GAMESIZE, GAMESIZE)];
        label.text = [[NSNumber numberWithInt:1] stringValue];
        label.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:label];
        
        IQDropDownTextField *textFieldOne = [[IQDropDownTextField alloc] initWithFrame:CGRectMake(0, GAMESIZE, GAMESIZE, GAMESIZE)];
        textFieldOne.adjustsFontSizeToFitWidth = YES;
        textFieldOne.isOptionalDropDown = NO;
        [textFieldOne setItemList:@[@"0", @"15", @"30", @"40", @"Ad."]];
        textFieldOne.borderStyle = UITextBorderStyleLine;
        textFieldOne.textAlignment = NSTextAlignmentCenter;
        textFieldOne.text = @"0";
        textFieldOne.delegate = self;
        
        IQDropDownTextField *textFieldTwo = [[IQDropDownTextField alloc] initWithFrame:CGRectMake(0, GAMESIZE*2, GAMESIZE, GAMESIZE)];
        textFieldTwo.adjustsFontSizeToFitWidth = YES;
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
        
        VBFPopFlatButton *addGameButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(([[tmp games] count])*GAMESIZE, scrollView.frame.size.height / 2 - 10, 20, 20) buttonType:buttonAddType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
        [addGameButton addTarget:self action:@selector(addNewGame:) forControlEvents:UIControlEventTouchUpInside];
        addGameButton.roundBackgroundColor = [UIColor asbestosColor];
        addGameButton.tintColor = [UIColor turquoiseColor];
        addGameButton.tag = indexPath.row;
        [addGameButton setCenter:CGPointMake(GAMESIZE*[[tmp games] count] + 20, 60 )];
        [scrollView addSubview:addGameButton];
        
        if (addGameButton.center.x + 20 > self.frame.size.width/2) {
            [scrollView setContentSize:CGSizeMake((_numSets+1)*GAMESIZE, _setsScrollView.frame.size.height)];
            [scrollView setContentOffset:CGPointMake((_numSets-4)*GAMESIZE, 0)];
        }
    }
    
    [_setGamesTextViews addObject:gamesTextViews];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    //NSIndexPath *updatedPath = [NSIndexPath indexPathForItem:(_numSets - indexPath.row - 1) inSection:0];
    [self configureCell:cell withIndex:indexPath];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_setsArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELLHEIGHT;
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
