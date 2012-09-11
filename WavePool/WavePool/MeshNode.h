//
//  MeshNode.h
//  WavePool
//
//  Created by Nicholas Arcolano on 2012-10-08.
//  Copyright (c) 2012 Nicholas Arcolano. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MeshNode : NSObject

@property(readonly) CGFloat xPosition;  // x-coordinate of node (meters)
@property(readonly) CGFloat yPosition;  // y-coordinate of node (meters)
@property CGFloat depth;  // depth of water at node (meters)
@property BOOL isBoundary;  // Whether or not node is a reflective boundary point

-(id) initWithXPosition:(CGFloat)x yPosition:(CGFloat)y depth:(CGFloat)d;

@end