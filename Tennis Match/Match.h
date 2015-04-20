//
//  Match.h
//  Tennis Match
//
//  Created by Robert Miller on 4/5/15.
//  Copyright (c) 2015 Robert Miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Team.h"


@interface Match : NSManagedObject

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSNumber * doubles;
@property (nonatomic, retain) id sets;
@property (nonatomic, retain) id teamOne;
@property (nonatomic, retain) id teamTwo;

-(int)matchWinner;

@end

@interface Sets : NSValueTransformer

@end

@interface TeamOne : NSValueTransformer

@end

@interface TeamTwo : NSValueTransformer

@end
