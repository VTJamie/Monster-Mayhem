//
//  Menu.h
//  MonsterMash
//
//  Created by Jamieson Abbott on 2/4/14.
//
//

#import "SPDisplayObject.h"
#import "SPTextField.h"

@interface GameOver : SPSprite

- (id) initWithScore: (int) score;

@property (nonatomic, retain) SPTextField* gameOverText;
@property (nonatomic, assign) int score;
- (void) setup;

@end
