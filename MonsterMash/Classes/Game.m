//
//  Game.m
//  AppMonsterMash
//

#import "Game.h"
#import "GameOver.h"
#import "Playable.h"
#import "StartMenu.h"


// --- private interface ---------------------------------------------------------------------------

@interface Game ()

- (void)setup;

@end


// --- class implementation ------------------------------------------------------------------------

@implementation Game

- (id)init
{
    if ((self = [super init]))
    {
        gameInstance = self;
        self.gameJuggler = [SPJuggler juggler];
        self.menuJuggler = [SPJuggler juggler];
        [self setup];
    }
    
    return self;
}

- (void)dealloc
{
    // release any resources here
    [Media releaseAtlas];
    [Media releaseSound];
}

- (void)setup
{
    [SPAudioEngine start];  // starts up the sound engine
    
    
    [Media initAtlas];      // loads your texture atlas -> see Media.h/Media.m
    //  [Media initSound];      // loads all your sounds    -> see Media.h/Media.m
    
    [self showStartMenu];
}

- (void) startGame
{
    [self removeAllChildren];
    self.startmenu = nil;
    self.playarea = [[Playable alloc] init];
    [self addChild:self.playarea];
    [self.playarea start];
}

- (void) showStartMenu
{
    [self removeAllChildren];
    self.playarea = nil;
    self.startmenu = [[StartMenu alloc] init];
    [self addChild:self.startmenu];
    [self.startmenu setup];
}

- (void) showGameOver: (BOOL) win
{
    [self removeAllChildren];
    self.playarea = nil;
        self.startmenu = nil;
    self.gameover = [[GameOver alloc] initWithStatus: win];
    [self addChild:self.gameover];
    [self.gameover setup];
}

+(Game*) instance
{
    return gameInstance;
}

@end
