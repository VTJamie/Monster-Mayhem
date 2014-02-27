//
//  GCHelper.h
//  MonsterMayhem
//
//  Created by Jamieson Abbott on 2/26/14.
//
//

#import <Foundation/Foundation.h>

@interface GCHelper : NSObject

+ (GCHelper*) sharedInstance;

- (void) authenticateLocalUser;

- (void) reportScore: (int) score;

@end
