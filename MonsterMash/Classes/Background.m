//
//  Background.m
//  MonsterMash
//
//  Created by Jamieson Abbott on 2/8/14.
//
//

#import "Background.h"
#import "ZoomChangedEvent.h"

@implementation Background

- (id)init
{
    if ((self = [super init]))
    {
        self.tiles = [[NSMutableArray alloc] init];
        [self setup];
    }
    return self;
}

- (void)dealloc
{

}

- (void)setup
{
    [self generateTiles];
    [[Game instance].playarea addEventListener:@selector(onCenterChange:) atObject:self forType:EVENT_TYPE_NEW_CENTER_TRIGGERED];
    [[Game instance].playarea addEventListener:@selector(onZoomChanged:) atObject:self forType:EVENT_TYPE_NEW_ZOOM];
    
}

- (void) onZoomChanged: (ZoomChangedEvent*) zoomevent
{
    [self generateTiles];
}

- (void) generateTiles
{
    [self.tiles removeAllObjects];
    [self removeAllChildren];
    SPImage *tempimage = [[SPImage alloc] initWithTexture:[Media atlasTexture:@"stars"]];
    double gamezoom = [Game instance].playarea.overallscale;
    int gameWidth  = Sparrow.stage.width / gamezoom;
    int gameHeight = Sparrow.stage.height / gamezoom;
    int imageWidth = tempimage.width;
    int imageHeight = tempimage.height;

    
    int tileWidth = gameWidth / imageWidth/gamezoom + 2;
    int tileHeight = gameHeight / imageHeight/gamezoom + 2;
       NSLog(@"%d, %d : %d, %d", tileWidth, tileHeight, gameWidth, gameHeight);
    
    for (int x = 0; x < tileWidth; x++)
    {
        for (int y = 0; y < tileHeight; y++)
        {
            SPImage* image = [[SPImage alloc] initWithTexture:[Media atlasTexture:@"stars"]];
            image.pivotX = 0;
            image.pivotY = 0;
            image.x = -imageWidth - [Game instance].playarea.x - [Game instance].playarea.currentcenter.x + imageWidth * x;
            image.y = -imageHeight - [Game instance].playarea.y - [Game instance].playarea.currentcenter.y + imageHeight * y;
            [self.tiles addObject:image];
            [self addChild:image];
        }
    }
}

- (void) redrawTiles: (SPPoint*) centerchange {
    double gamezoom = [Game instance].playarea.overallscale;
    double gx = [Game instance].x;
    double gy = [Game instance].y;
    for (SPImage* image in self.tiles)
    {
        image.x -= centerchange.x;
        image.y -= centerchange.y;
        
        int x = image.x / gamezoom - gx;
        int y = image.y / gamezoom - gy;
        
       // NSLog(@"%d, %d : %f, %f", x, y, gx, gy );
        if (y > Sparrow.stage.height / gamezoom)
        {
         //   NSLog(@"%d, %f", y, Sparrow.stage.height);
            image.y = -image.height + image.y - gx - Sparrow.stage.height / gamezoom;
        }
        
        if (x > Sparrow.stage.width / gamezoom)
        {
            image.x = -image.width + image.x - gx - Sparrow.stage.width / gamezoom;
        }
        
        if (x + image.width / gamezoom < 0)
        {
            image.x = Sparrow.stage.width / gamezoom + (image.x + image.width + gx);
        }
        
        if (y + image.height / gamezoom < 0)
        {
            image.y = Sparrow.stage.height / gamezoom + (image.y + image.height + gx);
        }
    }
}

- (void) onCenterChange: (CenterChangeEvent*) event
{
 //   [self generateTiles];
    [self redrawTiles:event.change];
}

//- (void) onTouchBack


@end
