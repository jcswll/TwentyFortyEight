//
//  TFEGameController+Touches.h
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 9/30/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "TFEGameController.h"

@interface TFEGameController (Touches)

- (IBAction)swipe:(UISwipeGestureRecognizer *)recognizer;

- (IBAction)longPress:(UILongPressGestureRecognizer *)recognizer;

@end
