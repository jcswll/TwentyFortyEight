//
//  TFEAppDelegate.h
//  TwentyFortyEight
//
//  Created by Joshua Caswell on 2/28/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface TFEAppDelegate : NSObject <NSApplicationDelegate>

@property (weak, nonatomic) IBOutlet NSWindow * mainWindow;
@property (weak, nonatomic) IBOutlet SKView * mainView;

@end
