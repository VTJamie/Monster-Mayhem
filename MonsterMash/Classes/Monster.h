//
//  Menu.h
//  MonsterMash
//
//  Created by Jamieson Abbott on 2/4/14.
//
//

#define EVENT_MONSTER_SQUASHED @"monsterSquashed"
#define EVENT_MONSTER_MADE_IT @"monsterGotToEnd"

@interface Monster : SPSprite

@property (nonatomic, retain) NSString* name;

- (void) setup;

@end
