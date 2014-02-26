//
//  Golbez.m
//  MonsterMash
//
//  Created by Jamieson Abbott on 2/24/14.
//
//

#import "Golbez.h"

@implementation Golbez

- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"golbez";
                [self setup];
    }
    return self;
}


@end
