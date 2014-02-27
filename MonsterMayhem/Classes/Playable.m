//
//  Playable.m
//  MonsterMash
//
//  Created by Jamieson Abbott on 2/23/14.
//
//

#import "Playable.h"
#import "Background.h"
#import "Death.h"
#import "Golbez.h"
#import "Vampire.h"
#import "Shadow.h"

@implementation Playable

- (id)init
{
    if ((self = [super init]))
    {
        self.timepassed = 0.0;
        self.interval = 2.0;
        self.gameover = NO;
        self.squashed = 0;
        self.secondticker = 0.0;
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"%@", @"Dealloc");
}

- (void)start
{
    [self addChild:[[Background alloc] init]];
    self.currentscore = [[SPTextField alloc] initWithWidth:200 height:50 text:@"0" fontName:@"Arcadepix" fontSize:18 color:0x0000FF];
    self.currentscore.x = Sparrow.stage.width / 2.0 - 100;
    self.currentscore.y = 25;
    [self addChild:self.currentscore];
    
    
    [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event
{
    self.timepassed += event.passedTime;
    self.secondticker += event.passedTime;
    
    if (self.secondticker >= 1.0)
    {
        self.interval /= 1.05;
        if (self.interval < 0.5)
        {
            self.interval = 0.5;
        }
    }
    
    
    if (self.timepassed > self.interval)
    {
        self.timepassed -= self.interval;
        Monster* monster = nil;
        int monsterselect = arc4random() % 4;
        if (monsterselect == 0)
        {
            monster = [[Death alloc] init];
        }
        else if (monsterselect == 1)
        {
            monster = [[Shadow alloc] init];
        }
        else if (monsterselect == 2)
        {
            
            monster = [[Vampire alloc] init];
        }
        else if (monsterselect == 3)
        {
            monster = [[Golbez alloc] init];
        }
        
        if(monster)
        {
            [monster addEventListener:@selector(squashedMonster:) atObject:self forType:EVENT_MONSTER_SQUASHED];
            [monster addEventListener:@selector(monsterGotToEnd:) atObject:self forType:EVENT_MONSTER_MADE_IT];
            for (int i = 1; i < [self numChildren]; i++)
            {
                if ([[[self childAtIndex:i] class] isSubclassOfClass:[Monster class]] && monster.y < [[self childAtIndex:i] y])
                {
                    [self addChild:monster atIndex:i];
                    return;
                }
            }
            [self addChild:monster];
        }
    }
}

- (void) monsterGotToEnd: (SPEvent*) event
{
    self.gameover = YES;
    [[Game instance] showGameOver:self.squashed];
}

- (void) squashedMonster: (SPEvent*) event
{
    self.squashed++;
    
    self.currentscore.text = [NSString stringWithFormat:@"%d", self.squashed];
}

@end
