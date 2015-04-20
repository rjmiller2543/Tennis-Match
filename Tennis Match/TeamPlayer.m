//
//  TeamPlayer.m
//  Tennis Match
//
//  Created by Robert Miller on 4/18/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import "TeamPlayer.h"

@implementation TeamPlayer

-(id)initWithCoder:(NSCoder*)aDecoder {
    if (self = [super init]) {
        [self setTimeStamp:[aDecoder decodeObjectForKey:@"timeStamp"]];
        [self setName:[aDecoder decodeObjectForKey:@"name"]];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder*)aCoder {
    [aCoder encodeObject:_timeStamp forKey:@"timeStamp"];
    [aCoder encodeObject:_name forKey:@"name"];
}

@end
