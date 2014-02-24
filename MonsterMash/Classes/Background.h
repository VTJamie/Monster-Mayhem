//
//  Background.h
//  MonsterMash
//
//  Created by Jamieson Abbott on 2/8/14.
//
//


#import "CenterChangeEvent.h"

@interface Background : SPSprite

- (void)setup;

- (void) onCenterChange: (CenterChangeEvent*) event;

@property (nonatomic, retain) NSMutableArray* tiles;

@end
