//
//  AppDelegate.m
//  AppMonsterMash
//

#import "AppDelegate.h"
#import "Game.h"
#import "Chartboost.h"

// --- c functions ---

void onUncaughtException(NSException *exception)
{
    NSLog(@"uncaught exception: %@", exception.description);
}

// ---

@implementation AppDelegate
{
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSSetUncaughtExceptionHandler(&onUncaughtException);
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    self.window = [[UIWindow alloc] initWithFrame:screenBounds];
    
    self.viewController = [[SPViewController alloc] init];
    
    // Enable some common settings here:
    //
    //   _viewController.showStats = YES;
    self.viewController.multitouchEnabled = YES;
    self.viewController.preferredFramesPerSecond = 60;
    
    [self.viewController startWithRoot:[Game class] supportHighResolutions:YES doubleOnPad:YES];
    
    [self.window setRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)app
{
    Chartboost *cb = [Chartboost sharedChartboost];
    cb.appId = @"530e33ab2d42da49014f22df";
    cb.appSignature = @"913dccc4c77b5c5237d57c87abbbfb2180f22170";
    // Begin a user session
    [cb startSession];
    // Show an interstitial
    [cb showInterstitial];
}

@end
