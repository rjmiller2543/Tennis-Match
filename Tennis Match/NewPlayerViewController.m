//
//  NewPlayerViewController.m
//  Tennis Match
//
//  Created by Robert Miller on 4/19/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "NewPlayerViewController.h"
#import <FlatUIKit.h>
#import <JVFloatLabeledTextField.h>
#import <VBFPopFlatButton.h>
#import "AppDelegate.h"
#include "UIViewController+UIViewController_MZFormDismissal.h"
#include "PlayerDetailViewController.h"
#include "Stats.h"
#include "Opponent.h"

@interface NewPlayerViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic,retain) UIImageView *imageView;
@property(nonatomic,retain) JVFloatLabeledTextField *firstNameField;
@property(nonatomic,retain) JVFloatLabeledTextField *lastNameField;

@end

@implementation NewPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cloudsColor];
    
    NSLog(@"width: %f height: %f", self.view.frame.size.width, self.view.frame.size.height);
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_user-100.png"]];
    [_imageView setFrame:CGRectMake(10, 10, 100, 100)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = 50;
    _imageView.layer.borderColor = [UIColor asbestosColor].CGColor;
    _imageView.layer.borderWidth = 2;
    [self.view addSubview:_imageView];
    _imageView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPhoto)]];
    
    _firstNameField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(120, 10, 120, 60)];
    [_firstNameField setPlaceholder:@"First Name" floatingTitle:@"First Name"];
    [self.view addSubview:_firstNameField];
    
    _lastNameField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(120, 80, 120, 60)];
    [_lastNameField setPlaceholder:@"Last Name" floatingTitle:@"Last Name"];
    [self.view addSubview:_lastNameField];
    
    VBFPopFlatButton *_closeButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(30, 180, 30, 30) buttonType:buttonCloseType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
    [_closeButton addTarget:self action:@selector(cancelView) forControlEvents:UIControlEventTouchUpInside];
    _closeButton.roundBackgroundColor = [UIColor asbestosColor];
    _closeButton.lineThickness = 2.0;
    _closeButton.tintColor = [UIColor turquoiseColor];
    [self.view addSubview:_closeButton];
    
    VBFPopFlatButton *_matchViewButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(90, 180, 30, 30) buttonType:buttonOkType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
    [_matchViewButton addTarget:self action:@selector(savePlayer) forControlEvents:UIControlEventTouchUpInside];
    _matchViewButton.roundBackgroundColor = [UIColor asbestosColor];
    _matchViewButton.lineThickness = 2.0;
    _matchViewButton.tintColor = [UIColor turquoiseColor];
    [self.view addSubview:_matchViewButton];
    
    if (_editPlayer) {
        
        if ([_editPlayer playerImage]) {
            _imageView.image = [UIImage imageWithData:[_editPlayer playerImage]];
        }
        
        _firstNameField.text = [_editPlayer playerName];
        _lastNameField.text = [_editPlayer playerLastName];
    }
}

-(void)savePlayer {
    
    if (_editPlayer == nil) {
        NSManagedObjectContext *context = [[AppDelegate sharedInstance] managedObjectContext];
        Player *newPlayer = (Player*)[NSEntityDescription insertNewObjectForEntityForName:@"Player" inManagedObjectContext:context];
        
        [newPlayer setPlayerName:[_firstNameField text]];
        [newPlayer setPlayerLastName:[_lastNameField text]];
        [newPlayer setPlayerImage:UIImageJPEGRepresentation(_imageView.image, 0.5)];
        [newPlayer setPlayerStats:[[Stats alloc] init]];
        [newPlayer setOpponents:[[NSArray alloc] init]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"error saving new player with error: %@", error);
        }
        
        [self dismissNewPlayerWithCompletionHandler:^(UIViewController *viewController) {
            //up up
        }];
    }
    
    if (_thisParentViewController != nil) {
        
        NSManagedObjectContext *context = [[AppDelegate sharedInstance] managedObjectContext];
        
        [_editPlayer setPlayerName:[_firstNameField text]];
        [_editPlayer setPlayerLastName:[_lastNameField text]];
        [_editPlayer setPlayerImage:UIImageJPEGRepresentation(_imageView.image, 0.5)];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"error saving new player with error: %@", error);
        }
        
        PlayerDetailViewController *detail = (PlayerDetailViewController*)_thisParentViewController;
        detail.detailPlayer = _editPlayer;
        [detail savedPlayer];
        
        [self dismissNewPlayerWithCompletionHandler:^(UIViewController *viewController) {
            //up up
        }];
    }
    else {
        [self dismissNewPlayerWithCompletionHandler:^(UIViewController *viewController) {
            //up up
        }];
    }
    
}

-(void)cancelView {
    [self dismissNewPlayerWithCompletionHandler:^(UIViewController *viewController) {
        //up up
    }];
}

-(void)addPhoto {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    UIAlertController *imagePickerAlert = [UIAlertController alertControllerWithTitle:@"Choose Photo Option" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [imagePickerAlert addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:imagePicker animated:YES completion:^{
            NSLog(@"imgae picker controller presented");
        }];
    }]];
    [imagePickerAlert addAction:[UIAlertAction actionWithTitle:@"Choose Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self presentViewController:imagePicker animated:YES completion:^{
            NSLog(@"imgae picker controller presented");
        }];
        
    }]];
    [imagePickerAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //DO Nothing
        
    }]];
    
    [self presentViewController:imagePickerAlert animated:YES completion:^{
        
        
    }];
}

#pragma mark - image picker delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenPhoto = (UIImage*)info[UIImagePickerControllerOriginalImage];
    _imageView.image = chosenPhoto;
    
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   
                               }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
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
