//
//  Menu.m
//  MonsterMash
//
//  Created by Jamieson Abbott on 2/4/14.
//
//

#import "GameOver.h"
#import "Game.h"

@implementation GameOver

- (id) initWithStatus: (BOOL) won
{
    self = [super init];
    if (self)
    {
        self.won = won;
    }
    return self;
}

- (void) setup
{
    NSString* caption = @"You Lost!";
    if (self.won) {
        caption = @"You Won!";
    }
    
    [self addChild:[[SPQuad alloc] initWithWidth:Sparrow.stage.width height:Sparrow.stage.height color:0x000000]];
    
    self.gameOverText = [[SPTextField alloc] initWithWidth:150 height:50 text:caption fontName:@"Helvetica Bold" fontSize:18 color:0xFF0000];
    
    self.gameOverText.x = Sparrow.stage.width / 2.0 - 75;
    self.gameOverText.y = Sparrow.stage.height / 2.0 - 25;
    self.gameOverText.hAlign = SPHAlignCenter;
    self.gameOverText.vAlign = SPVAlignCenter;
    
    [self addChild:self.gameOverText];
    
    [self addEventListener:@selector(close:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
}

- (void) close: (SPTouchEvent*) event
{
    [[Game instance] showStartMenu];
}

@end
