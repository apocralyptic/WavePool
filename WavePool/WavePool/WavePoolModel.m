//
//  WavePoolModel.m
//  Workbook
//
//  Created by Nicholas Arcolano on 2012-12-08.
//  Copyright (c) 2012 Nicholas Arcolano. All rights reserved.
//

#import "WavePoolModel.h"
#import "MeshNode.h"
#import "WavePoolConstants.h"

@interface WavePoolModel ()

@property(readwrite) int rows;  // Make writeable within class implementation
@property(readwrite) int columns;
@property(readwrite) CGFloat gridSize;
@property(readwrite) CGSize size;

@end

@implementation WavePoolModel
@synthesize rows, columns, meshGrid, previousMeshGrid;

-(id) initWithResolution:(CGFloat)n forView:(UIView*)theView
{
    if (self = [super init])
    {
        // Compute and store size and number of rows/columns
        self.rows = ceil(theView.bounds.size.height/n);
        self.columns = ceil(theView.bounds.size.width/n);
        self.gridSize = n;
        
        CGSize poolSize;
        poolSize.width = self.rows * self.gridSize;
        poolSize.height = self.columns * self.gridSize;
        [self setSize:poolSize];
        
        // Initialize array and place nodes at proper x- and y-coordinates
        NSMutableArray* newMeshGrid = [[NSMutableArray alloc] initWithCapacity:self.rows];
        
        for (int i=0; i<self.rows; i++) {
            NSMutableArray* currentRow = [[NSMutableArray alloc] initWithCapacity:self.columns];
            CGFloat currentYPosition = i*self.gridSize;
            for (int ii=0; ii<self.columns; ii++) {
                MeshNode* currentNode;
                CGFloat currentXPosition = ii*self.gridSize;
                currentNode = [[MeshNode alloc] initWithXPosition:currentXPosition yPosition:currentYPosition depth:0];
                
                // Determine if boundary
                if (i == 0 || i == self.rows-1 || ii == 0 || ii == self.columns-1) {
                    currentNode.isBoundary = TRUE;
                }
                
                // Insert
                [currentRow insertObject:currentNode atIndex:ii];
            }
            [newMeshGrid insertObject:currentRow atIndex:i];
        }
        [self setMeshGrid:newMeshGrid];
        [self setPreviousMeshGrid:newMeshGrid];
    }
    return self;
}

-(id) getMeshNodeAtRow:(int)rowIndex andColumn:(int)columnIndex
{
    MeshNode* theNode = [[self.meshGrid objectAtIndex:rowIndex] objectAtIndex:columnIndex];
    return theNode;
}

-(void) addDropletWithXPosition:(CGFloat)x yPosition:(CGFloat)y
{
    // Find closest node point
    CGFloat minDistance = self.size.height;
    int minRowIndex = 0;
    int minColumnIndex = 0;
     for (int i=0; i<self.rows; i++) {
        for (int ii=0; ii<self.columns; ii++) {
            MeshNode* currentNode = [[self.meshGrid objectAtIndex:i] objectAtIndex:ii];
            CGFloat distanceSquared = pow(currentNode.xPosition - x,2) + pow(currentNode.yPosition - y,2);
            if (distanceSquared < minDistance) {
                minDistance = distanceSquared;
                minRowIndex = i;
                minColumnIndex = ii;
            }
        }
    }
    // Add droplet
    MeshNode* theNode = [[self.meshGrid objectAtIndex:minRowIndex] objectAtIndex:minColumnIndex];
    CGFloat newDepth = theNode.depth + WavePoolConstants.defaultDropletDepth;
    [theNode setDepth:newDepth];
}

-(void) advancePoolByTimeStep:(float)deltaT
{
    CGFloat c = WavePoolConstants.defaultWaveSpeed;
    CGFloat k = WavePoolConstants.dampingCoefficient;
    
    // Store current state in temporary array
    NSMutableArray* tempGrid = [[NSMutableArray alloc] initWithArray:meshGrid];

    // Create grid for new state
    NSMutableArray* newGrid = [[NSMutableArray alloc] initWithArray:meshGrid];
    
    for (int i=0; i<self.rows; i++) {
        for (int ii=0; ii<self.columns; ii++) {
            MeshNode* currentNode = [[self.meshGrid objectAtIndex:i] objectAtIndex:ii];
            MeshNode* previousCurrentNode = [[self.previousMeshGrid objectAtIndex:i] objectAtIndex:ii];
            if (!currentNode.isBoundary) {  // Only update if not a boundary point

                // Extract 8 nodes around current node
                MeshNode* upperLeftNode = [[self.meshGrid objectAtIndex:i-1] objectAtIndex:ii-1];
                MeshNode* upperNode = [[self.meshGrid objectAtIndex:i-1] objectAtIndex:ii];
                MeshNode* upperRightNode = [[self.meshGrid objectAtIndex:i-1] objectAtIndex:ii+1];
                MeshNode* leftNode = [[self.meshGrid objectAtIndex:i] objectAtIndex:ii-1];
                MeshNode* rightNode = [[self.meshGrid objectAtIndex:i] objectAtIndex:ii+1];
                MeshNode* lowerLeftNode = [[self.meshGrid objectAtIndex:i+1] objectAtIndex:ii-1];
                MeshNode* lowerNode = [[self.meshGrid objectAtIndex:i+1] objectAtIndex:ii];
                MeshNode* lowerRightNode = [[self.meshGrid objectAtIndex:i+1] objectAtIndex:ii+1];
                
                // Check for boundary points and store reflections
                if (upperLeftNode.isBoundary) {
                    upperLeftNode = lowerRightNode;
                }
                if (upperNode.isBoundary) {
                    upperNode = lowerNode;
                }
                if (upperRightNode.isBoundary) {
                    upperRightNode = lowerLeftNode;
                }
                if (leftNode.isBoundary) {
                    leftNode = rightNode;
                }
                if (rightNode.isBoundary) {
                    rightNode = leftNode;
                }
                if (lowerLeftNode.isBoundary) {
                    lowerLeftNode = upperRightNode;
                }
                if (lowerNode.isBoundary) {
                    lowerNode = upperNode;
                }
                if (lowerRightNode.isBoundary) {
                    lowerRightNode = upperLeftNode;
                }
                
                // Update center node in new grid
                CGFloat a = (1 - k*deltaT);
                CGFloat term1 = currentNode.depth - previousCurrentNode.depth;
                CGFloat b = deltaT*c/self.gridSize;
                CGFloat term2 = 4*currentNode.depth - leftNode.depth - rightNode.depth - upperNode.depth - lowerNode.depth;
                CGFloat term3 = 4*currentNode.depth - lowerLeftNode.depth - lowerRightNode.depth - upperLeftNode.depth - upperRightNode.depth;
                CGFloat deltaDepth = a*term1 + b*b*(term2 + 0.5*term3);
 
                MeshNode* updateNode = [[newGrid objectAtIndex:i] objectAtIndex:ii];
                updateNode.depth += deltaDepth;
            }
        }
    }
    [self setMeshGrid:newGrid];  // Save new state
    [self setPreviousMeshGrid:tempGrid];  // Update state
}

-(void) pngFromHeightProfile
{
    
}

-(void) displayMeshStateToConsole  // Display mesh state for debugging (uses fast enumeration)
{
    for (NSArray* currentRow in self.meshGrid) {
        for (MeshNode* currentNode in currentRow) {
            NSLog(@"x = %6.2f, y = %6.2f, h = %6.2f, BOUNDARY: %@", currentNode.xPosition, currentNode.yPosition, currentNode.depth, (currentNode.isBoundary ? @"YES" : @"NO"));
        }
    }
}

@end