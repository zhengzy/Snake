//
//  SSPViewController.m
//  Snake
//
//  Created by Ying Jiang on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SSPViewController.h"
#import "StateMap.h"

@implementation SSPViewController {
    int sideLength;
    NSTimer *timer;
}

@synthesize snakeCubes;
@synthesize cherryCube;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)gameOver
{
    [timer invalidate];
    
    [UIView animateWithDuration:0.2 animations:^{
        for (UIView * v in snakeCubes) {
            v.alpha = 0.3;
        }
    }completion:^(BOOL finished){
        if (finished) {
            [UIView animateWithDuration:0.2 animations:^{
                for (UIView * v in snakeCubes) {
                    v.alpha = 1;
                }
            }completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:0.2 animations:^{
                        for (UIView * v in snakeCubes) {
                            v.alpha = 0.3;
                        }                        
                    }completion:^(BOOL finished){
                        int count = [snakeCubes count];
                        for (UIView *v in snakeCubes) {
                            [v removeFromSuperview];
                        }
                        [snakeCubes removeAllObjects];
                        [cherryCube removeFromSuperview];
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game over" message:[NSString stringWithFormat:@"Score: %d. Restart?", count] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }];
                }
            }];
        }
    }];
}

- (void)updateCherry:(SPoint *)cherry
{
    CGRect rect = cherryCube.frame;
    rect.origin = CGPointMake(cherry.x * sideLength + 0.5, cherry.y * sideLength + 0.5);
    cherryCube.frame = rect;
    [self.view setNeedsDisplay];
}

- (void)cherryCreated:(SPoint *)cherry
{
    [self performSelectorOnMainThread:@selector(updateCherry:) withObject:cherry waitUntilDone:YES];
}

- (void)updateSnakeWithPoints:(NSArray *)array
{
    while ([array count] > [snakeCubes count]) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sideLength - 1, sideLength - 1)];
        v.backgroundColor = [UIColor blackColor];
        [self.view addSubview:v];
        [snakeCubes addObject:v];
    }
    
    for (int i = 0; i < [array count]; i ++) {
        SPoint *p = (SPoint *)[array objectAtIndex:i];
        UIView *v = [snakeCubes objectAtIndex:i];
        v.frame = CGRectMake(p.x * sideLength + 0.5, p.y * sideLength + 0.5, sideLength - 1, sideLength - 1);
        [self.view setNeedsDisplay];
    }
}

- (void)initSnake
{
    NSArray *array = [[StateMap sharedInstance] getSnakePoints];
    [self performSelectorOnMainThread:@selector(updateSnakeWithPoints:) withObject:array waitUntilDone:YES];
}

- (void)tick
{
    NSArray *array = [[StateMap sharedInstance] getNextTickSnakePoints];
    [self performSelectorOnMainThread:@selector(updateSnakeWithPoints:) withObject:array waitUntilDone:YES];
}

- (void)start
{
    ((StateMap *)[StateMap sharedInstance]).delegate = self;
    sideLength = [[StateMap sharedInstance] getSideLength];
    snakeCubes = [[NSMutableArray alloc] init];
    cherryCube = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sideLength, sideLength)];
    cherryCube.backgroundColor = [UIColor redColor];
    [self.view addSubview:cherryCube];
    
    [[StateMap sharedInstance] initSnake];
    
    [self initSnake];
    
//    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
//    [timer fire];
    if (timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    backgroundView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:backgroundView];
    
//    UIGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self start];
    
    [self.view addSubview:self.cherryCube];

}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self start];
}


- (IBAction)directionAction:(id)sender
{
    int direction = ((UIButton *)sender).tag;
    NSLog(@"Direction = %d", direction);
    [[StateMap sharedInstance] changeDirection:direction];
}


@end
