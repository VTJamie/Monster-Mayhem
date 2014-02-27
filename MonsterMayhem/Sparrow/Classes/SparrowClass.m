//
//  SPSparrow.m
//  Sparrow
//
//  Created by Daniel Sperl on 27.01.13.
//  Copyright 2013 Gamua. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import "SparrowClass.h"

static __weak SPViewController *controller = nil;

@implementation Sparrow

- (id)init
{
    [NSException raise:NSGenericException format:@"Static class - do not initialize!"];
    return nil;
}

+ (SPViewController *)currentController
{
    return controller;
}

+ (void)setCurrentController:(SPViewController *)value
{
    controller = value;
}

+ (SPJuggler *)juggler
{
    return controller.juggler;
}

+ (SPStage *)stage
{
    return controller.stage;
}

+ (SPDisplayObject *)root
{
    return controller.root;
}

+ (float)contentScaleFactor
{
    return controller ? controller.contentScaleFactor : 1.0f;
}

@end
