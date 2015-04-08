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

@interface NewMatchView ()

@property(nonatomic,retain) VBFPopFlatButton *addMatchButton;
@property(nonatomic,retain) UIScrollView *setsScrollView;

@property(nonatomic) int numSets;

@end

@implementation NewMatchView

-(instancetype)init {
    self = [super init];
    if (self) {
        //Configure the view
        //[self setFrame:[UIScreen mainScreen].bounds];
        self.backgroundColor = [UIColor sunflowerColor];
        _setsArray = [[NSMutableArray alloc] init];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 170, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 170)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        _setsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2, 90, [UIScreen mainScreen].bounds.size.width / 2, 60)];
        _setsScrollView.directionalLockEnabled = YES;
        _setsScrollView.userInteractionEnabled = NO;
        [self addSubview:_setsScrollView];
        
        _isDoubles = false;
        _numSets = 0;
        
        _addMatchButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(30*_numSets + 15, _setsScrollView.frame.size.height / 2 - 5, 15, 15) buttonType:buttonAddType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
        [_addMatchButton addTarget:self action:@selector(addNewSet) forControlEvents:UIControlEventTouchUpInside];
        _addMatchButton.roundBackgroundColor = [UIColor asbestosColor];
        _addMatchButton.tintColor = [UIColor turquoiseColor];
        [_setsScrollView addSubview:_addMatchButton];
    }
    return self;
}

-(void)setIsDoubles:(BOOL)isDoubles {
    _isDoubles = isDoubles;
}

-(void)setTeamOne:(Team *)teamOne {
    UILabel *teamOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 90, self.frame.size.width / 2 - 10, 30)];
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
    UILabel *teamTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 120, self.frame.size.width / 2 - 10, 30)];
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

-(void)addNewSet {
    UITextField *textFieldOne = [[UITextField alloc] initWithFrame:CGRectMake(30*_numSets, 0, 30, 30)];
    textFieldOne.borderStyle = UITextBorderStyleLine;
    textFieldOne.textAlignment = NSTextAlignmentCenter;
    textFieldOne.text = @"0";
    UITextField *textFieldTwo = [[UITextField alloc] initWithFrame:CGRectMake(30*_numSets, 30, 30, 30)];
    textFieldTwo.borderStyle = UITextBorderStyleLine;
    textFieldTwo.textAlignment = NSTextAlignmentCenter;
    textFieldTwo.text = @"0";
    
    [_setsScrollView addSubview:textFieldOne];
    [_setsScrollView addSubview:textFieldTwo];
    
    _numSets += 1;
    
    [_addMatchButton setCenter:CGPointMake(30*_numSets + 15, _setsScrollView.frame.size.height / 2 )];
}

-(void)addNewGame {
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    if (indexPath.row >= [_setsArray count]) {
        VBFPopFlatButton *newButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(cell.frame.size.width / 2 - 10, cell.frame.size.height / 2 - 10, 20, 20) buttonType:buttonAddType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
        newButton.roundBackgroundColor = [UIColor asbestosColor];
        newButton.tintColor = [UIColor turquoiseColor];
        [newButton addTarget:self action:@selector(addNewGame) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:newButton];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_setsArray count] + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
