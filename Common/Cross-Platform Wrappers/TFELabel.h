//
//  TFELabel.h
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 9/30/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import <TargetConditionals.h>

#if !TARGET_OS_IPHONE

@import Cocoa;

@interface TFELabel : NSTextField

@property (copy) NSString * text;

@end

#else

@import UIKit;

@interface TFELabel : UILabel
@end

#endif
