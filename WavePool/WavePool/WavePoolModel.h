//
//  WavePoolModel.h
//  Workbook
//
//  Created by Nicholas Arcolano on 2012-12-08.
//  Copyright (c) 2012 Nicholas Arcolano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WavePoolModel : NSObject

@property(readonly) int rows;  // Number of rows (y-axis points)
@property(readonly) int columns;  // Number of columns (x-axis points)
@property(readonly) CGFloat gridSize;  // Size of squares in grid
@property(readonly) CGSize size;  // Dimensions of pool (width and height)
@property NSMutableArray* meshGrid;  // Current mesh grid defining state of pool
@property NSMutableArray* previousMeshGrid;  // Previous state of pool


-(id) initWithResolution:(CGFloat)n forView:(UIView*)theView;
-(id) getMeshNodeAtRow:(int)rowIndex column:(int)columnIndex;
-(void) addDropletWithXPosition:(CGFloat)x yPosition:(CGFloat)y;
-(void) advancePoolByTimeStep:(float)deltaT;
-(void) pngFromHeightProfile;
-(void) displayMeshStateToConsole;

@end