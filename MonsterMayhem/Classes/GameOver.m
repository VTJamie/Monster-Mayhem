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

- (id) initWithScore: (int) score
{
    self = [super init];
    if (self)
    {
        self.score = score;
        int highscore = [[Game instance] getHighScore];
        if (score > highscore)
        {
            [[Game instance] saveHighScore:score];
        }
    }
    return self;
}

- (void) setup
{
    
    [self addChild:[[SPQuad alloc] initWithWidth:Sparrow.stage.width height:Sparrow.stage.height color:0x000000]];
    
    self.gameOverText = [[SPTextField alloc] initWithWidth:250 height:50 text:@"Game Over" fontName:@"Arcadepix" fontSize:28 color:0xFF0000];
    
    self.gameOverText.x = Sparrow.stage.width / 2.0 - 125;
    self.gameOverText.y = Sparrow.stage.height / 4.0 - 25;
    self.gameOverText.hAlign = SPHAlignCenter;
    self.gameOverText.vAlign = SPVAlignCenter;
    
    [self addChild:self.gameOverText];
    
    SPTextField* score = [[SPTextField alloc] initWithWidth:150 height:50 text:[NSString stringWithFormat:@"Score: %d", self.score] fontName:@"Arcadepix" fontSize:24 color:0x0000FF];
    
    score.x = Sparrow.stage.width / 2.0 - 75;
    score.y = Sparrow.stage.height / 2.0 - 25;
    score.hAlign = SPHAlignCenter;
    score.vAlign = SPVAlignCenter;
    [self addChild:score];
    
    [self addEventListener:@selector(close:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
}

- (void) close: (SPTouchEvent*) event
{
    [[Game instance] showStartMenu];
}

@end
