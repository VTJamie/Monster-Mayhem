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

- (id) initWithStatus: (BOOL) won;

@property (nonatomic, retain) SPTextField* gameOverText;
@property (nonatomic, assign) BOOL won;
- (void) setup;

@end
