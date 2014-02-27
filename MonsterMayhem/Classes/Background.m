//
//  Background.m
//  MonsterMash
//
//  Created by Jamieson Abbott on 2/8/14.
//
//

#import "Background.h"

@implementation Background

- (id)init
{
    if ((self = [super init]))
    {

        [self setup];
    }
    return self;
}

- (void)dealloc
{

}

- (void)setup
{

    
    
    SPImage* referencetile = [Media atlasImage:@"Grass"];
    double numtilewide = Sparrow.stage.width / (referencetile.width-1) + 1;
    double numtileheight = Sparrow.stage.height / (referencetile.height-1)  + 1;
    double w = referencetile.width -1;
    double h = referencetile.height -1;
    
    
    for (int i = 0; i < numtilewide; i++)
    {
        for (int j = 0; j < numtileheight; j++)
        {
            SPImage* tile = [Media atlasImage:@"Grass"];
            tile.x = i * w;
            tile.y = j * h;
            [self addChild:tile];
        }
    }
    
    SPImage* referencepinetree = [Media atlasImage:@"PineTree"];
    double numtreewide = Sparrow.stage.width / referencepinetree.width+1;
    
    for ( int i = 0; i < numtreewide; i++)
    {
        SPImage* tree = [Media atlasImage:@"PineTree"];
        tree.x = i * tree.width;
        tree.y = -25;
        [self addChild:tree];
        
        SPImage* tree2 = [Media atlasImage:@"PineTree"];
        tree2.x = i * tree2.width;
        tree2.y = Sparrow.stage.height - tree2.height;
        [self addChild:tree2];
    }
    
}

@end
