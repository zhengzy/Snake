//
//  StateMap.m
//  Snake
//
//  Created by Ying Jiang on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StateMap.h"


@implementation SPoint

@synthesize x, y;


- (id)initWithX:(int)xValue Y:(int)yValue
{
    if (self = [super init]) {
        self.x = xValue;
        self.y = yValue;
    }
    
    return self;
}

+ (id)pointWithPoint:(SPoint *)point
{
    SPoint *p = [[SPoint alloc] initWithX:point.x Y:point.y];
    return p;
}

+ (id)pointWithX:(int)xValue Y:(int)yValue
{
    return [[SPoint alloc] initWithX:xValue Y:yValue];
}

- (BOOL)isEqualToPoint:(SPoint *)p
{
    return (self.x == p.x && self.y == p.y);
}

@end

#define MAP_WIDTH 16
#define MAP_HEIGHT 23

int directionArray[2][2] = {{-1, 1},{-1, 1}};

@implementation StateMap {
    NSMutableArray *pixels;
    int direction;  //0, 1, 2, 3  up, down, left, right
    int map[MAP_WIDTH][MAP_HEIGHT];
    SPoint *cherry;
}

@synthesize  delegate;

static StateMap *instance = nil;

- (BOOL)isPointAvailable:(SPoint *)point
{
    if (point.x < 0 || point.x >= MAP_WIDTH || point.y < 0 || point.y >= MAP_HEIGHT) {
        return NO;
    }
    
    if (map[point.x][point.y] == 1) {
        return NO;
    }
    
    return YES;
}

+ (StateMap *)sharedInstance
{
    if (!instance) {
        instance = [[StateMap alloc] init];
    }
    return instance;
}

- (int)getSideLength
{
    return 20;
}

- (void)changeDirection:(int)dire
{
    if (direction == 0 || direction == 2) {
        if (dire - direction == 1) {
            return;
        }
    }
    
    if (direction == 1 || direction == 3) {
        if (dire - direction == -1) {
            return;
        }
    }
    
    direction = dire;
}

- (void)createRandomCherry
{
    int px = random() % MAP_WIDTH;
    int py = random() % MAP_HEIGHT;
    while ([self isPointAvailable:[SPoint pointWithX:px Y:py]] == NO) {
        px = random() % MAP_WIDTH;
        py = random() % MAP_HEIGHT;
    }
    
    cherry = [SPoint pointWithX:px Y:py];
    map[px][py] = -1;
    
    [self.delegate cherryCreated:(SPoint *)cherry];
}

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)initSnake
{
    pixels = [[NSMutableArray alloc] init];
    [pixels addObject:[[SPoint alloc] initWithX:MAP_WIDTH/2 Y:MAP_HEIGHT/2]];
    direction = 1;
    memset(map, 0, sizeof(map));
    map[MAP_WIDTH/2][MAP_HEIGHT/2] = 1;
    [self createRandomCherry];
}

- (SPoint *)getCherryPoint
{
    return cherry;
}

- (NSArray *)getSnakePoints
{
    return pixels;
}

- (NSArray *)getNextTickSnakePoints
{
    SPoint *headPoint = [SPoint pointWithPoint:(SPoint *)[pixels lastObject]];
    
    if (direction / 2 == 0) {
        headPoint.y += directionArray[direction / 2][direction % 2];
    } else {
        headPoint.x += directionArray[direction / 2][direction % 2];
    }
    
//    NSLog(@"headPoint x = %d y = %d", headPoint.x, headPoint.y);
    
    if (![self isPointAvailable:headPoint]) {
        [self.delegate gameOver];
        return nil;
    }
    
    [pixels addObject:headPoint];
    
    //ate cherry
    if (map[headPoint.x][headPoint.y] == -1) {
        [self createRandomCherry];
    } else {
        SPoint *lastPoint = [pixels objectAtIndex:0];
        map[lastPoint.x][lastPoint.y] = 0;
        [pixels removeObjectAtIndex:0];
    }
    
    map[headPoint.x][headPoint.y] = 1;
    
    return pixels;
}

@end
