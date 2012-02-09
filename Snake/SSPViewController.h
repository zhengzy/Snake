//
//  SSPViewController.h
//  Snake
//
//  Created by Ying Jiang on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StateMap.h"

@interface SSPViewController : UIViewController <StateMapDelegate> {
//    NSMutableArray *snakeCubes;
//    UIView *cherryCube;
}

@property (nonatomic, strong) NSMutableArray *snakeCubes;
@property (nonatomic, strong) UIView *cherryCube;

- (IBAction)directionAction:(id)sender;

@end
