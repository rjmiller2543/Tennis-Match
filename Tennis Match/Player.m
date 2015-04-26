//
//  Player.m
//  Tennis Match
//
//  Created by Robert Miller on 4/19/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "Player.h"
#import "Stats.h"


@implementation Player

@dynamic playerImage;
@dynamic playerName;
@dynamic timeStamp;
@dynamic playerLastName;
@dynamic playerStats;
@dynamic opponents;

@end

@implementation Opponents

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

@implementation PlayerStats

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
