//
//  MeshNode.m
//  WavePool
//
//  Created by Nicholas Arcolano on 2012-10-08.
//  Copyright (c) 2012 Nicholas Arcolano. All rights reserved.
//

#import "MeshNode.h"

@interface MeshNode ()

@property(readwrite) CGFloat xPosition;  // Make writeable within class implementation
@property(readwrite) CGFloat yPosition;

@end

@implementation MeshNode
@synthesize xPosition, yPosition, depth, isBoundary;

-(id) initWithXPosition:(CGFloat)x yPosition:(CGFloat)y depth:(CGFloat)d
{
    if (self = [super init])
    {
        [self setXPosition:x];
        [self setYPosition:y];
        [self setDepth:d];
        [self setIsBoundary:FALSE];  // Default value
    }
    return self;
}

@end