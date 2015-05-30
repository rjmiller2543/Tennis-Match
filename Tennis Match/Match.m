//
//  Match.m
//  Tennis Match
//
//  Created by Robert Miller on 4/5/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "Match.h"


@implementation Match

@dynamic timeStamp;
@dynamic doubles;
@dynamic sets;
@dynamic teamOne;
@dynamic teamTwo;
@dynamic teamOneMatchStats;
@dynamic teamTwoMatchStats;

-(int)matchWinner {
    int winner = 0;
    Team *one = (Team*)self.teamOne;
    Team *two = (Team*)self.teamTwo;
    if ([[one score] intValue] >= 2) {
        winner = 1;
    }
    else if ([[two score] intValue] >= 2) {
        winner = 2;
    }
    return winner;
}

-(int)savedMatchWinner {
    int winner = 0;
    Team *one = (Team*)self.teamOne;
    Team *two = (Team*)self.teamTwo;
    if ([[one score] intValue] > [[two score] intValue]) {
        winner = 1;
    }
    else {
        winner = 2;
    }
    return winner;
}

@end

@implementation Sets

+ (Class)transformedValueClass
{
    return [NSArray class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (NSArray*)reverseTransformedValue:(id)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end

@implementation TeamOne

+ (Class)transformedValueClass
{
    return [Team class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (NSArray*)reverseTransformedValue:(id)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end

@implementation TeamTwo

+ (Class)transformedValueClass
{
    return [Team class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (NSArray*)reverseTransformedValue:(id)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end

@implementation TeamOneMatchStats

+ (Class)transformedValueClass
{
    return [Stats class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (NSArray*)reverseTransformedValue:(id)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end

@implementation TeamTwoMatchStats

+ (Class)transformedValueClass
{
    return [Stats class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (NSArray*)reverseTransformedValue:(id)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end
