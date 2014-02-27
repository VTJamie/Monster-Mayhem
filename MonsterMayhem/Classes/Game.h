//
//  Game.h
//  AppMonsterMash
//

#import <Foundation/Foundation.h>
#import <UIKit/UIDevice.h>
#import "Playable.h"
#import "StartMenu.h"
#import "GameOver.h"
#import <GameKit/GameKit.h>
@interface Game : SPSprite <GKGameCenterControllerDelegate>

+ (Game*) instance;
@property (nonatomic, retain) SPJuggler* gameJuggler;
@property (nonatomic, retain) SPJuggler* menuJuggler;

@property (nonatomic, retain) Playable* playarea;
@property (nonatomic, retain) StartMenu* startmenu;
@property (nonatomic, retain) GameOver* gameover;


- (void) startGame;
- (void) showStartMenu;
- (void) showGameOver: (int) score;

- (int) getHighScore;
- (void) saveHighScore: (int) score;

@end


static Game* gameInstance;