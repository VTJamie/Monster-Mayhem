//
//  Game.m
//  AppMonsterMash
//

#import "Game.h"
#import "GameOver.h"
#import "Playable.h"
#import "StartMenu.h"
#import <GameKit/GameKit.h>
#import "AppDelegate.h"
#import "GCHelper.h"


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
    
//    [self authenticateLocalPlayer];
//    [self showGameCenter];
    [[GCHelper sharedInstance] authenticateLocalUser];
    
    [SPAudioEngine start];  // starts up the sound engine
    
    
    [Media initAtlas];      // loads your texture atlas -> see Media.h/Media.m
    //  [Media initSound];      // loads all your sounds    -> see Media.h/Media.m
    
    [self showStartMenu];
    
    [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
}

- (void) onEnterFrame: (SPEnterFrameEvent*) event
{
    if (self.playarea == nil || !self.playarea.gameover)
    {
        [self.gameJuggler advanceTime:event.passedTime];
    }
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

- (void) showGameOver: (int) score
{
    [self removeAllChildren];
    self.playarea = nil;
        self.startmenu = nil;
    self.gameover = [[GameOver alloc] initWithScore:score];
    [self addChild:self.gameover];
    [self.gameover setup];
}

+(Game*) instance
{
    return gameInstance;
}

- (int) getHighScore
{
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:@"scores.plist"];
    
    // If the file doesn't exist in the Documents Folder, copy it.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:destPath]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"scores" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:destPath error:nil];
    }
    
    // Load the Property List.
    NSMutableDictionary* scores = [[NSMutableDictionary alloc] initWithContentsOfFile:destPath];
    
    int returnvalue = 0;

    if ([scores objectForKey:@"highscore"] != nil)
    {
        returnvalue = [[scores objectForKey:@"highscore"] integerValue];
    }
    return returnvalue;
}
- (void) saveHighScore: (int) score
{
    [[GCHelper sharedInstance] reportScore:score];
    
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:@"scores.plist"];

    NSMutableDictionary* scores = [[NSMutableDictionary alloc] init];
    [scores setObject:[NSNumber numberWithInt:score] forKey:@"highscore"];
    
    [scores writeToFile:destPath atomically:YES];
}

@end
