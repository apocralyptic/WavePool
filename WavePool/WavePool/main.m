//
//  main.m
//  WavePool
//
//  Created by Nicholas Arcolano on 2012-21-08.
//  Copyright (c) 2012 Nicholas Arcolano. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WavePoolAppDelegate.h"
#import "WavePoolModel.h"
#import "WavePoolConstants.h"
#import "MeshNode.h"

int main(int argc, char *argv[])
{
    // Testing WavePoolModel class initialization
    UIView* theView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    WavePoolModel* thePool;
    thePool = [[WavePoolModel alloc] initWithResolution:20 forView:theView];
    
    // Add droplet
    [thePool addDropletWithXPosition:20 yPosition:20];
    
    // Display WavePoolModel properties
    [thePool displayMeshStateToConsole];

    // Update state
    [thePool advancePoolByTimeStep:0.1];
    
    // Display WavePoolModel properties
    [thePool displayMeshStateToConsole];
    
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([WavePoolAppDelegate class]));
    }
}
