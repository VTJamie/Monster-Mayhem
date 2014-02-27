//
//  Playable.h
//  MonsterMash
//
//  Created by Jamieson Abbott on 2/23/14.
//
//

#import "SPSprite.h"

@interface Playable : SPSprite

@property (nonatomic, assign) double timepassed;
@property (nonatomic, assign) double interval;
@property (nonatomic, assign) double secondticker;

@property (nonatomic, assign) int squashed;
@property (nonatomic, assign) BOOL gameover;

@property (nonatomic, retain) SPTextField* currentscore;

- (void)start;

@end
