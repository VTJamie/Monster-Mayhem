//
//  SPTouchEvent.m
//  Sparrow
//
//  Created by Daniel Sperl on 02.05.09.
//  Copyright 2011 Gamua. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import "SPTouchEvent.h"
#import "SPDisplayObject.h"
#import "SPDisplayObjectContainer.h"
#import "SPEvent_Internal.h"

@implementation SPTouchEvent
{
    NSSet *_touches;
}

@synthesize touches = _touches;

- (id)initWithType:(NSString*)type bubbles:(BOOL)bubbles touches:(NSSet*)touches
{   
    if ((self = [super initWithType:type bubbles:bubbles]))
    {        
        _touches = touches;
    }
    return self;
}

- (id)initWithType:(NSString*)type touches:(NSSet*)touches
{   
    return [self initWithType:type bubbles:YES touches:touches];
}

- (id)initWithType:(NSString*)type bubbles:(BOOL)bubbles
{
    return [self initWithType:type bubbles:bubbles touches:[NSSet set]];
}

- (SPEvent*)clone
{
    return [SPTouchEvent eventWithType:self.type touches:self.touches];
}

- (double)timestamp
{
    return [[_touches anyObject] timestamp];    
}

- (NSSet*)touchesWithTarget:(SPDisplayObject*)target
{
    NSMutableSet *touchesFound = [NSMutableSet set];
    for (SPTouch *touch in _touches)
    {
        if ([target isEqual:touch.target] ||
            ([target isKindOfClass:[SPDisplayObjectContainer class]] &&
             [(SPDisplayObjectContainer*)target containsChild:touch.target]))
        {
            [touchesFound addObject: touch];
        }
    }    
    return touchesFound;    
}

- (NSSet*)touchesWithTarget:(SPDisplayObject*)target andPhase:(SPTouchPhase)phase
{
    NSMutableSet *touchesFound = [NSMutableSet set];
    for (SPTouch *touch in _touches)
    {
        if (touch.phase == phase &&
            ([target isEqual:touch.target] || 
             ([target isKindOfClass:[SPDisplayObjectContainer class]] &&
              [(SPDisplayObjectContainer*)target containsChild:touch.target])))
        {
            [touchesFound addObject: touch];
        }
    }    
    return touchesFound;    
}

+ (id)eventWithType:(NSString*)type touches:(NSSet*)touches
{
    return [[self alloc] initWithType:type touches:touches];
}

@end
