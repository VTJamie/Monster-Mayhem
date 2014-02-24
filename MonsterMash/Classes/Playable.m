//
//  Playable.m
//  MonsterMash
//
//  Created by Jamieson Abbott on 2/23/14.
//
//

#import "Playable.h"

@implementation Playable

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"%@", @"Dealloc");
}

- (void)start
{
    
    [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];

}

- (void)onEnterFrame:(SPEnterFrameEvent *)event
{
}

@end
