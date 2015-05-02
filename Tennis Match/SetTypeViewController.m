//
//  SetTypeViewController.m
//  Tennis Match
//
//  Created by Robert Miller on 5/2/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "SetTypeViewController.h"
#import <FlatUIKit.h>
#import "UIViewController+UIViewController_MZFormDismissal.h"

@interface SetTypeViewController ()

@property(nonatomic,retain) UILabel *gamesLabel;

@end

@implementation SetTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
    self.view.backgroundColor = [UIColor midnightBlueColor];
    
    FUIButton *bestButton = [[FUIButton alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 30)];
    [bestButton addTarget:self action:@selector(setBestOfThree) forControlEvents:UIControlEventTouchUpInside];
    bestButton.buttonColor = [UIColor asbestosColor];
    bestButton.cornerRadius = 6.0f;
    bestButton.titleLabel.font = [UIFont boldFlatFontOfSize:22.0f];
    [bestButton setTitle:@"Best of Three" forState:UIControlStateNormal];
    [bestButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateNormal];
    [self.view addSubview:bestButton];
    
    FUIButton *supersetButton = [[FUIButton alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width - 20, 30)];
    [supersetButton addTarget:self action:@selector(setSuperset) forControlEvents:UIControlEventTouchUpInside];
    supersetButton.buttonColor = [UIColor asbestosColor];
    supersetButton.cornerRadius = 6.0f;
    supersetButton.titleLabel.font = [UIFont boldFlatFontOfSize:22.0f];
    [supersetButton setTitle:@"Superset" forState:UIControlStateNormal];
    [supersetButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateNormal];
    [self.view addSubview:supersetButton];
    
    UILabel *numbersLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, self.view.frame.size.width - 20, 30)];
    numbersLabel.font = [UIFont boldFlatFontOfSize:22.0f];
    numbersLabel.textColor = [UIColor turquoiseColor];
    numbersLabel.text = @"Number of winning games in Superset: ";
    [self.view addSubview:numbersLabel];
    
    UILabel *gamesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, 60, 30)];
    gamesLabel.font = [UIFont boldFlatFontOfSize:22.0f];
    gamesLabel.textColor = [UIColor turquoiseColor];
    gamesLabel.text = @"10";
    [self.view addSubview:gamesLabel];
    
    UIStepper *stepper = [[UIStepper alloc] initWithFrame:CGRectMake(80, 130, 60, 30)];
    stepper.value = 10;
    [stepper addTarget:self action:@selector(stepperChanged:) forControlEvents:UIControlEventValueChanged];
    [stepper configureFlatStepperWithColor:[UIColor turquoiseColor] highlightedColor:[UIColor turquoiseColor] disabledColor:[UIColor asbestosColor] iconColor:[UIColor cloudsColor]];
     */
}

-(void)configureView {
    self.view.backgroundColor = [UIColor midnightBlueColor];
    
    FUIButton *bestButton = [[FUIButton alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 60)];
    [bestButton addTarget:self action:@selector(setBestOfThree) forControlEvents:UIControlEventTouchUpInside];
    bestButton.buttonColor = [UIColor asbestosColor];
    bestButton.cornerRadius = 6.0f;
    bestButton.titleLabel.font = [UIFont boldFlatFontOfSize:22.0f];
    [bestButton setTitle:@"Best of Three" forState:UIControlStateNormal];
    [bestButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateNormal];
    [self.view addSubview:bestButton];
    
    FUIButton *supersetButton = [[FUIButton alloc] initWithFrame:CGRectMake(10, 80, self.view.frame.size.width - 20, 60)];
    [supersetButton addTarget:self action:@selector(setSuperset) forControlEvents:UIControlEventTouchUpInside];
    supersetButton.buttonColor = [UIColor asbestosColor];
    supersetButton.cornerRadius = 6.0f;
    supersetButton.titleLabel.font = [UIFont boldFlatFontOfSize:22.0f];
    [supersetButton setTitle:@"Superset" forState:UIControlStateNormal];
    [supersetButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateNormal];
    [self.view addSubview:supersetButton];
    
    UILabel *numbersLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, self.view.frame.size.width - 20, 60)];
    numbersLabel.font = [UIFont boldFlatFontOfSize:22.0f];
    numbersLabel.textColor = [UIColor turquoiseColor];
    numbersLabel.lineBreakMode = NSLineBreakByWordWrapping;
    numbersLabel.numberOfLines = 0;
    numbersLabel.text = @"Number of winning games in Superset: ";
    [self.view addSubview:numbersLabel];
    
    _gamesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 220, 60, 30)];
    _gamesLabel.font = [UIFont boldFlatFontOfSize:22.0f];
    _gamesLabel.textColor = [UIColor turquoiseColor];
    _gamesLabel.text = @"10";
    [self.view addSubview:_gamesLabel];
    
    UIStepper *stepper = [[UIStepper alloc] initWithFrame:CGRectMake(80, 220, 60, 30)];
    stepper.value = 10;
    [stepper addTarget:self action:@selector(stepperChanged:) forControlEvents:UIControlEventValueChanged];
    [stepper configureFlatStepperWithColor:[UIColor turquoiseColor] highlightedColor:[UIColor turquoiseColor] disabledColor:[UIColor asbestosColor] iconColor:[UIColor cloudsColor]];
    [self.view addSubview:stepper];
    
    _numberOfSupersetGames = 10;
}

-(void)setBestOfThree {
    _matchViewParentView.isSuperset = false;
    _matchViewParentView.numberOfSupersetGames = 0;
    
    [self dismissMZFormWithCompletionHandler:^(UIViewController *viewController) {
        //up up
    }];
}

-(void)setSuperset {
    _matchViewParentView.isSuperset = true;
    _matchViewParentView.numberOfSupersetGames = _numberOfSupersetGames;
    
    [self dismissMZFormWithCompletionHandler:^(UIViewController *viewController) {
        //up up
        [_matchViewParentView doneShowingSetsChoice];
    }];
}

-(void)stepperChanged:(id)sender {
    UIStepper *stepper = (UIStepper*)sender;
    NSLog(@"stepper changed to value: %f", stepper.value);
    _gamesLabel.text = [[NSNumber numberWithInt:stepper.value] stringValue];
    _numberOfSupersetGames = stepper.value;
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
