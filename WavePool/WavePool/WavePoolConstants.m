//
//  WavePoolConstants.m
//  Workbook
//
//  Created by Nicholas Arcolano on 2012-19-08.
//  Copyright (c) 2012 Nicholas Arcolano. All rights reserved.
//

#import "WavePoolConstants.h"

@implementation WavePoolConstants

+(CGFloat) accelerationDueToGravity
{
    return 9.80665;  // Acceleration due to gravity (m/s^2)
}

+(CGFloat) dampingCoefficient
{
    return 1;  // Damping coefficient for wave model
}

+(CGFloat) defaultWaveSpeed
{
    return 20;  // Default wave speed
}

+(CGFloat) defaultDropletDepth
{
    return 10;  // Default depth (z-amplitude) of droplet
}

@end
