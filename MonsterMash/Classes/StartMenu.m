//
//  Menu.m
//  MonsterMash
//
//  Created by Jamieson Abbott on 2/4/14.
//
//

#import "StartMenu.h"
#import "Game.h"

@implementation StartMenu

- (id) init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (void) setup
{
    self.startTextButton = [[SPTextField alloc] initWithWidth:150 height:50 text:@"New Game" fontName:@"Helvetica Bold" fontSize:18 color:0xFF0000];
    
    self.startTextButton.x = Sparrow.stage.width / 2.0 - 75;
    self.startTextButton.y = Sparrow.stage.height / 2.0 - 25;
    self.startTextButton.hAlign = SPHAlignCenter;
    self.startTextButton.vAlign = SPVAlignCenter;
    
    [self addChild:self.startTextButton];
    
    [self.startTextButton addEventListener:@selector(startGame:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
}

- (void) startGame: (SPTouchEvent*) event
{
    SPTouch* touch = [[event touchesWithTarget:self.startTextButton andPhase:SPTouchPhaseEnded] anyObject];
    if (touch)
    {
        [[Game instance] startGame];
    }
}

@end
