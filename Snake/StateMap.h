//
//  StateMap.h
//  Snake
//
//  Created by Ying Jiang on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SPoint : NSObject {
@private
    int x;
    int y;
}

@property (nonatomic, assign) int x;
@property (nonatomic, assign) int y;

@end


@protocol StateMapDelegate <NSObject>

- (void)gameOver;
- (void)cherryCreated:(SPoint *)cherry;

@end

@interface StateMap : NSObject {
    id<StateMapDelegate> __unsafe_unretained delegate;
}

@property (nonatomic, unsafe_unretained) id<StateMapDelegate> delegate;

+ (id)sharedInstance;
- (void)initSnake;
- (NSArray *)getSnakePoints;
- (NSArray *)getNextTickSnakePoints;
- (int)getSideLength;
- (void)changeDirection:(int)dire;

@end
