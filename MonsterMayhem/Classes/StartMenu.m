//
//  Menu.m
//  MonsterMash
//
//  Created by Jamieson Abbott on 2/4/14.
//
//

#import "StartMenu.h"
#import "Game.h"
#import "Background.h"
#import "Death.h"
#import "Golbez.h"
#import "Vampire.h"
#import "Shadow.h"

@implementation StartMenu

- (id) init
{
    self = [super init];
    if (self)
    {
        self.timepassed = 0.0;
    }
    return self;
}

- (void) setup
{
    
    [self addChild:[[Background alloc] init]];
    
    self.monsterlayer = [[SPSprite alloc] init];
    
    [self addChild:self.monsterlayer];
    
    self.newgame = [[SPImage alloc] initWithContentsOfFile:@"New-Game.png"];
    self.newgame.x = Sparrow.stage.width / 2.0 - self.newgame.width / 2.0;
    self.newgame.y = Sparrow.stage.height / 2.0 - self.newgame.height / 2.0;
    
    [self addChild:self.newgame];
    
    SPImage* logo = [[SPImage alloc] initWithContentsOfFile:@"Monster-Mayhem.png"];
    logo.scaleX = Sparrow.stage.width / logo.width;
    logo.scaleY = Sparrow.stage.width / logo.width;
    logo.x = (Sparrow.stage.width - logo.width) / 2.0;
    logo.y = Sparrow.stage.height / 4.0 - logo.height / 2.0;
    [self addChild:logo];
    
    SPTextField* highscore = [[SPTextField alloc] initWithWidth:200 height:50 text:[NSString stringWithFormat:@"HIGH SCORE: %d", [[Game instance] getHighScore]] fontName:@"Arcadepix" fontSize:18 color:0x0000FF];
    highscore.x = Sparrow.stage.width / 2.0 - 100;
    highscore.y = Sparrow.stage.height / 4.0 * 3.0 - 25;
    [self addChild:highscore];
    
    [self.newgame addEventListener:@selector(startGame:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
    [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
}

- (void) startGame: (SPTouchEvent*) event
{
    SPTouch* touch = [[event touchesWithTarget:self.newgame andPhase:SPTouchPhaseEnded] anyObject];
    if (touch)
    {
        [[Game instance] startGame];
    }
}

- (void) onEnterFrame: (SPEnterFrameEvent*) event
{
    self.timepassed += event.passedTime;
    if (self.timepassed > 2.0)
    {
        Monster* monster = nil;
        self.timepassed -= 2.0;
        
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
        if(monster) {
            for (int i = 0; i < [self.monsterlayer numChildren]; i++)
            {
                if ([[[self.monsterlayer childAtIndex:i] class] isSubclassOfClass:[Monster class]] && monster.y < [[self.monsterlayer childAtIndex:i] y])
                {
                    [self.monsterlayer addChild:monster atIndex:i];
                    return;
                }
            }
            [self.monsterlayer addChild:monster];
            
        }
    }
}

@end
