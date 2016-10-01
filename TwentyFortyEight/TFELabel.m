//
//  TFELabel.m
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 9/30/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "TFELabel.h"

@implementation TFELabel

#if !TARGET_OS_IPHONE
- (NSString *)text
{
    return [super stringValue];
}

- (void)setText:(NSString *)text
{
    [super setStringValue:text];
}
#endif

@end
