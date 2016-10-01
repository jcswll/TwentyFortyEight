//
//  TFEViewController.h
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 9/30/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//


#import <TargetConditionals.h>

#if !TARGET_OS_IPHONE

@import Cocoa;

@interface TFEViewController : NSViewController
@end

#else

@import UIKit;

@interface TFEViewController : UIViewController
@end

#endif
