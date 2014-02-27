//
//  GCHelper.m
//  MonsterMayhem
//
//  Created by Jamieson Abbott on 2/26/14.
//
//

#import "GCHelper.h"
#import <GameKit/GameKit.h>

@implementation GCHelper
static GCHelper* sharedHelper = nil;

+ (GCHelper*) sharedInstance
{
    if (!sharedHelper)
    {
        sharedHelper = [[GCHelper alloc] init];
    }
    return sharedHelper;
}

- (void) authenticateLocalUser
{
    if ([GKLocalPlayer localPlayer].authenticated == NO)
    {
        NSLog(@"Not Logged In");
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError* error){
            if (error)
            {
                NSLog(@"%@", error);

            }
        }];
        
    }
    else
    {
        NSLog(@"Logged In");
    }
}

- (void) reportScore: (int) score
{
    if ([GKLocalPlayer localPlayer].isAuthenticated)
    {
        GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: @"monstermayhemhighscores"];
        scoreReporter.value = score;
        scoreReporter.context = 0;
        
        [scoreReporter reportScoreWithCompletionHandler:^(NSError* error){
            if (error)
            {
                NSLog(@"%@", error);
            }
        }];
    }
}

@end
