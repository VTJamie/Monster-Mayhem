//
//  Menu.m
//  MonsterMash
//
//  Created by Jamieson Abbott on 2/4/14.
//
//

#import "Monster.h"
#import "Game.h"

@implementation Monster

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
    if (arc4random() % 2 == 0)
    {
        [self startLeft];
    }
    else {
        [self startRight];
    }

    
    [self addEventListener:@selector(tap:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
}

- (void) tap: (SPTouchEvent*) event
{
    SPTouch* touch = [[event touchesWithTarget:self andPhase:SPTouchPhaseEnded] anyObject];
    if (touch)
    {
        SPEvent* event = [[SPEvent alloc] initWithType:EVENT_MONSTER_SQUASHED];
        [self dispatchEvent:event];
        [self removeEventListener:@selector(tap:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        SPMovieClip* bloodsplatter = [[SPMovieClip alloc] initWithFrames:[Media atlasTexturesWithPrefix:@"blood_"] fps:7];
        [self removeAllChildren];
        [[Game instance].gameJuggler removeObjectsWithTarget:self];
        bloodsplatter.x = -16;
        [self addChild:bloodsplatter];
        [bloodsplatter addEventListener:@selector(bloodFinished:) atObject:self forType:SP_EVENT_TYPE_COMPLETED];
        [[Game instance].gameJuggler addObject:bloodsplatter];
    }
}

- (void) bloodFinished: (SPEvent*) completedblood
{
    [self removeFromParent];
}

- (void) startLeft
{
    NSMutableArray* texturearray = [[NSMutableArray alloc] init];
    
    for (int i = 9; i <= 12; i++)
    {
        [texturearray addObject:[Media atlasTexture:[NSString stringWithFormat:@"%@_%02d", self.name, i]]];
    }
    SPMovieClip* movieclip = [[SPMovieClip alloc] initWithFrames:texturearray fps:5];
    [[Game instance].gameJuggler addObject:movieclip];
    [self addChild:movieclip];
    movieclip.loop = YES;
    [movieclip play];
    self.x = -32;
    self.y = arc4random() % (int)(Sparrow.stage.height - 42 - 65);
    
    SPTween* tween = [[SPTween alloc] initWithTarget:self time:6.0];
    [tween animateProperty:@"x" targetValue:Sparrow.stage.width];
    tween.onComplete = ^(){
        SPEvent* event = [[SPEvent alloc] initWithType:EVENT_MONSTER_MADE_IT];
        [self dispatchEvent:event];
        [self removeEventListener:@selector(tap:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        [self removeFromParent];
    };

    [[Game instance].gameJuggler addObject:tween];
}

- (void) startRight
{
    NSMutableArray* texturearray = [[NSMutableArray alloc] init];
    
    for (int i = 5; i <= 8; i++)
    {
        [texturearray addObject:[Media atlasTexture:[NSString stringWithFormat:@"%@_%02d", self.name, i]]];
    }
    SPMovieClip* movieclip = [[SPMovieClip alloc] initWithFrames:texturearray fps:5];
    [[Game instance].gameJuggler addObject:movieclip];
    [self addChild:movieclip];
        movieclip.loop = YES;
    [movieclip play];
    self.x = Sparrow.stage.width;
    self.y = arc4random() % (int)(Sparrow.stage.height - 42 - 65);
    
    SPTween* tween = [[SPTween alloc] initWithTarget:self time:6.0];
    [tween animateProperty:@"x" targetValue:-32];
    tween.onComplete = ^(){
        SPEvent* event = [[SPEvent alloc] initWithType:EVENT_MONSTER_MADE_IT];
        [self dispatchEvent:event];

        [self removeEventListener:@selector(tap:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        [self removeFromParent];
    };
    [[Game instance].gameJuggler addObject:tween];
    
}

@end
