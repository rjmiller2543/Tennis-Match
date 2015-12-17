//
//  InterfaceController.m
//  Tennis Match Watchkit App Extension
//
//  Created by Robert Miller on 12/15/15.
//  Copyright © 2015 Robert Miller. All rights reserved.
//

#import "InterfaceController.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "TennisMatchHelper.h"


@interface InterfaceController() <WCSessionDelegate>

@property(nonatomic,retain) WCSession *session;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    if ([WCSession isSupported]) {
        _session = [WCSession defaultSession];
        _session.delegate = self;
        [_session activateSession];
    }
}

-(void)menuOnePressed:(id)sender {
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:@[kPlayerOneUp] forKeys:@[kUpdateScore]];
    [_session sendMessage:data replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
        [_playerOneScore setText:[replyMessage valueForKey:kTeamOneScore]];
        [_playerTwoScore setText:[replyMessage valueForKey:kTeamTwoScore]];
        [_playerOneSets setText:[[replyMessage valueForKey:kTeamOneSets] stringValue]];
        [_playerTwoSets setText:[[replyMessage valueForKey:kTeamTwoSets] stringValue]];
        if ([[replyMessage valueForKey:kServingPlayer] intValue] % 2) {
            [_playerTwoLabel setTextColor:TENNISBALLCOLOR];
            [_playerOneLabel setTextColor:[UIColor lightGrayColor]];
        }
        else {
            [_playerOneLabel setTextColor:TENNISBALLCOLOR];
            [_playerTwoLabel setTextColor:[UIColor lightGrayColor]];
        }
    } errorHandler:^(NSError * _Nonnull error) {
        //up up
    }];
}

-(void)menuTwoPressed:(id)sender {
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:@[kPlayerTwoUp] forKeys:@[kUpdateScore]];
    [_session sendMessage:data replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
        [_playerOneScore setText:[replyMessage valueForKey:kTeamOneScore]];
        [_playerTwoScore setText:[replyMessage valueForKey:kTeamTwoScore]];
        [_playerOneSets setText:[[replyMessage valueForKey:kTeamOneSets] stringValue]];
        [_playerTwoSets setText:[[replyMessage valueForKey:kTeamTwoSets] stringValue]];
        if ([[replyMessage valueForKey:kServingPlayer] intValue] % 2) {
            [_playerTwoLabel setTextColor:TENNISBALLCOLOR];
            [_playerOneLabel setTextColor:[UIColor lightGrayColor]];
        }
        else {
            [_playerOneLabel setTextColor:TENNISBALLCOLOR];
            [_playerTwoLabel setTextColor:[UIColor lightGrayColor]];
        }
    } errorHandler:^(NSError * _Nonnull error) {
        //up up
    }];
}

-(void)menuThreePressed:(id)sender {
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:@[kPlayerOneDn] forKeys:@[kUpdateScore]];
    [_session sendMessage:data replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
        [_playerOneScore setText:[replyMessage valueForKey:kTeamOneScore]];
        [_playerTwoScore setText:[replyMessage valueForKey:kTeamTwoScore]];
        [_playerOneSets setText:[[replyMessage valueForKey:kTeamOneSets] stringValue]];
        [_playerTwoSets setText:[[replyMessage valueForKey:kTeamTwoSets] stringValue]];
        if ([[replyMessage valueForKey:kServingPlayer] intValue] % 2) {
            [_playerTwoLabel setTextColor:TENNISBALLCOLOR];
            [_playerOneLabel setTextColor:[UIColor lightGrayColor]];
        }
        else {
            [_playerOneLabel setTextColor:TENNISBALLCOLOR];
            [_playerTwoLabel setTextColor:[UIColor lightGrayColor]];
        }
    } errorHandler:^(NSError * _Nonnull error) {
        //up up
    }];
}

-(void)menuFourPressed:(id)sender {
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:@[kPlayerTwoDn] forKeys:@[kUpdateScore]];
    [_session sendMessage:data replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
        [_playerOneScore setText:[replyMessage valueForKey:kTeamOneScore]];
        [_playerTwoScore setText:[replyMessage valueForKey:kTeamTwoScore]];
        [_playerOneSets setText:[[replyMessage valueForKey:kTeamOneSets] stringValue]];
        [_playerTwoSets setText:[[replyMessage valueForKey:kTeamTwoSets] stringValue]];
        if ([[replyMessage valueForKey:kServingPlayer] intValue] % 2) {
            [_playerTwoLabel setTextColor:TENNISBALLCOLOR];
            [_playerOneLabel setTextColor:[UIColor lightGrayColor]];
        }
        else {
            [_playerOneLabel setTextColor:TENNISBALLCOLOR];
            [_playerTwoLabel setTextColor:[UIColor lightGrayColor]];
        }
    } errorHandler:^(NSError * _Nonnull error) {
        //up up
    }];
}

-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message {
    [_playerOneLabel setText:[message objectForKey:kTeamOneName]];
    [_playerTwoLabel setText:[message objectForKey:kTeamTwoName]];
    [_playerOneScore setText:[[message objectForKey:kTeamOneScore] stringValue]];
    [_playerTwoScore setText:[[message objectForKey:kTeamTwoScore] stringValue]];
    [_playerOneSets setText:[[NSNumber numberWithInt:0] stringValue]];
    [_playerTwoSets setText:[[NSNumber numberWithInt:0] stringValue]];
    
    [_playerOneLabel setTextColor:TENNISBALLCOLOR];
    [_playerTwoLabel setTextColor:[UIColor lightGrayColor]];
    [_playerOneScore setTextColor:[UIColor colorWithRed:(136.0/255.0) green:(184.0/255.0) blue:(157.0/255.0) alpha:1.0]];
    [_playerTwoScore setTextColor:[UIColor colorWithRed:(136.0/255.0) green:(184.0/255.0) blue:(157.0/255.0) alpha:1.0]];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



