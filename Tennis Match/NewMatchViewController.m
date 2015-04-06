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

@interface NewMatchViewController () <NewPlayerViewDelegate>

@property(nonatomic,retain) NewPlayerView *playerList;
@property(nonatomic) int playerNumber;
@property(nonatomic) BOOL isSingles;

@property(nonatomic,retain) UIButton *playerOneButton;
@property(nonatomic,retain) UIButton *playerTwoButton;
@property(nonatomic,retain) UIButton *playerThreeButton;
@property(nonatomic,retain) UIButton *playerFourButton;

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

-(instancetype)init {
    self = [super init];
    if (self) {
        //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tennis-court.png"]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"tennis-court.png"];
    [self.view addSubview:imageView];
    
    _isSingles = true;
    
    [self configureSingles];
    
    UIButton *doubleButton = [[UIButton alloc] init];
    [doubleButton addTarget:self action:@selector(toggleDoubles:) forControlEvents:UIControlEventTouchUpInside];
    doubleButton.backgroundColor = [UIColor blackColor];
    [doubleButton setTitle:@"Singles" forState:UIControlStateNormal];
    [doubleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doubleButton sizeToFit];
    [doubleButton setCenter:self.view.center];
    [self.view addSubview:doubleButton];
    
    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton addTarget:self action:@selector(cancelView) forControlEvents:UIControlEventTouchUpInside];
    closeButton.backgroundColor = [UIColor blackColor];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton sizeToFit];
    [closeButton setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 60)];
    [self.view addSubview:closeButton];
    
    _playerList = [[NewPlayerView alloc] init];
    _playerList.delegate = self;
    _playerList.parentViewController = self;
    [_playerList setFrame:CGRectMake(0, self.view.frame.size.height+5, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_playerList];
    
}

-(void)configureSingles {
    
    _playerOneButton = [[UIButton alloc] init];
    [_playerOneButton addTarget:self action:@selector(addPlayerOne) forControlEvents:UIControlEventTouchUpInside];
    _playerOneButton.backgroundColor = [UIColor blackColor];
    [_playerOneButton setTitle:@"Add Player One" forState:UIControlStateNormal];
    [_playerOneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_playerOneButton sizeToFit];
    [_playerOneButton setCenter:CGPointMake(self.view.frame.size.width / 2, 120)];
    _playerOneButton.tag = PLAYERONEBUTTON;
    [self.view addSubview:_playerOneButton];
    
    _playerTwoButton = [[UIButton alloc] init];
    [_playerTwoButton addTarget:self action:@selector(addPlayerTwo) forControlEvents:UIControlEventTouchUpInside];
    _playerTwoButton.backgroundColor = [UIColor blackColor];
    [_playerTwoButton setTitle:@"Add Player Two" forState:UIControlStateNormal];
    [_playerTwoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_playerTwoButton sizeToFit];
    [_playerTwoButton setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 120)];
    _playerTwoButton.tag = PLAYERTWOBUTTON;
    [self.view addSubview:_playerTwoButton];
    
}

-(void)configureDoubles {
    
    _playerOneButton = [[UIButton alloc] init];
    [_playerOneButton addTarget:self action:@selector(addPlayerOne) forControlEvents:UIControlEventTouchUpInside];
    _playerOneButton.backgroundColor = [UIColor blackColor];
    [_playerOneButton setTitle:@"Add Player One" forState:UIControlStateNormal];
    [_playerOneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_playerOneButton sizeToFit];
    [_playerOneButton setCenter:CGPointMake(self.view.frame.size.width / 2, 120)];
    _playerOneButton.tag = PLAYERONEBUTTON;
    [self.view addSubview:_playerOneButton];
    
    _playerTwoButton = [[UIButton alloc] init];
    [_playerTwoButton addTarget:self action:@selector(addPlayerOne) forControlEvents:UIControlEventTouchUpInside];
    _playerTwoButton.backgroundColor = [UIColor blackColor];
    [_playerTwoButton setTitle:@"Add Player Two" forState:UIControlStateNormal];
    [_playerTwoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_playerTwoButton sizeToFit];
    [_playerTwoButton setCenter:CGPointMake(self.view.frame.size.width / 2, 160)];
    _playerTwoButton.tag = PLAYERTWOBUTTON;
    [self.view addSubview:_playerTwoButton];
    
    _playerThreeButton = [[UIButton alloc] init];
    [_playerThreeButton addTarget:self action:@selector(addPlayerTwo) forControlEvents:UIControlEventTouchUpInside];
    _playerThreeButton.backgroundColor = [UIColor blackColor];
    [_playerThreeButton setTitle:@"Add Player Three" forState:UIControlStateNormal];
    [_playerThreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_playerThreeButton sizeToFit];
    [_playerThreeButton setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 120)];
    _playerThreeButton.tag = PLAYERTHREEBUTTON;
    [self.view addSubview:_playerThreeButton];
    
    _playerFourButton = [[UIButton alloc] init];
    [_playerFourButton addTarget:self action:@selector(addPlayerTwo) forControlEvents:UIControlEventTouchUpInside];
    _playerFourButton.backgroundColor = [UIColor blackColor];
    [_playerFourButton setTitle:@"Add Player Four" forState:UIControlStateNormal];
    [_playerFourButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_playerFourButton sizeToFit];
    [_playerFourButton setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 160)];
    _playerFourButton.tag = PLAYERFOUR;
    [self.view addSubview:_playerFourButton];
    
}

-(void)toggleDoubles:(id)sender {
    UIButton *button = (UIButton*)sender;
    
    for (id button in [self.view subviews]) {
        if ([button class] == [UIButton class]) {
            UIButton *tmp = (UIButton*)button;
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
        _isSingles = false;
    }
    else {
        [self configureSingles];
        [button setTitle:@"Singles" forState:UIControlStateNormal];
        [button sizeToFit];
        _isSingles = true;
    }
}

-(void)cancelView {
    [self dismissViewControllerAnimated:YES completion:^{
        //up up
    }];
}

-(void)addPlayerOne {
    [UIView animateWithDuration:1.0 animations:^{
        [_playerList setFrame:self.view.frame];
    } completion:^(BOOL finished) {
        //up up
    }];
    _playerNumber = PLAYERONE;
}

-(void)addPlayerTwo {
    [UIView animateWithDuration:1.0 animations:^{
        [_playerList setFrame:self.view.frame];
    } completion:^(BOOL finished) {
        //up up
    }];
    _playerNumber = PLAYERTWO;
}

-(void)addPlayerThree {
    [UIView animateWithDuration:1.0 animations:^{
        [_playerList setFrame:self.view.frame];
    } completion:^(BOOL finished) {
        //up up
    }];
    _playerNumber = PLAYERTHREE;
}

-(void)addPlayerFour {
    [UIView animateWithDuration:1.0 animations:^{
        [_playerList setFrame:self.view.frame];
    } completion:^(BOOL finished) {
        //up up
    }];
    _playerNumber = PLAYERFOUR;
}

-(void)closePlayerList {
    [UIView animateWithDuration:1.0 animations:^{
        [_playerList setFrame:CGRectMake(0, self.view.frame.size.height+5, self.view.frame.size.width, self.view.frame.size.height)];
    } completion:^(BOOL finished) {
        //up up
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
