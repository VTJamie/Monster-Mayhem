//
//  Media.h
//  AppMonsterMash
//

#import <Foundation/Foundation.h>

@interface Media : NSObject 

+ (void)initAtlas;
+ (void)releaseAtlas;

+ (SPTexture *)atlasTexture:(NSString *)name;
+ (SPImage *) atlasImage:(NSString *) name;
+ (NSArray *)atlasTexturesWithPrefix:(NSString *)prefix;

+ (void)initSound;
+ (void)releaseSound;

+ (SPSoundChannel *)soundChannel:(NSString *)soundName;
+ (void)playSound:(NSString *)soundName;

@end
