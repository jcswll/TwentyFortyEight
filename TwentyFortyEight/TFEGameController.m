//
//  TFEGameController.m
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 9/29/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "TFEGameController.h"
#import "TFEGameController+Private.h"
#import "TFEMainScene.h"
#import "TFEBoard.h"
#import "TFELabel.h"

@implementation TFEGameController
{
    uint32_t _score;
}

- (instancetype)init
{
    self = [super initWithNibName:@"MainView" bundle:nil];
    if( !self ) return nil;
    
    _scene = [TFEMainScene sceneWithSize:CGSizeMake(100, 100)];
    _board = [TFEBoard boardWithController:self
                                     scene:_scene];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self scene] setSize:[[self gameView] bounds].size];
}

- (void)viewWillAppear
{
    [self viewWillAppear:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self gameView] presentScene:[self scene]];
}

- (BOOL)becomeFirstResponder
{
    return YES;
}

//MARK: Board communication

- (void)gameDidEndInVictory:(BOOL)victorious
{
    [[self scene] gameDidEndInVictory:victorious];
}

- (void)updateScoreTo:(uint32_t)new_score
{
    [[self scoreLabel] setText:[NSString stringWithFormat:@"%d", new_score]];
}

@end
