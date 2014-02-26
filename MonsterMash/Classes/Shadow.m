//
//  Shadow.m
//  MonsterMash
//
//  Created by Jamieson Abbott on 2/24/14.
//
//

#import "Shadow.h"

@implementation Shadow

- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"shadow";
                [self setup];
    }
    return self;
}


@end
