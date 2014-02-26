//
//  Death.m
//  MonsterMash
//
//  Created by Jamieson Abbott on 2/24/14.
//
//

#import "Death.h"

@implementation Death

- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"death";
                [self setup];
    }
    return self;
}



@end
