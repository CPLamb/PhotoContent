//
//  SlideShowAppDelegate.h
//  SlideShow
//
//  Created by Chris Lamb on 1/24/11.
//  Copyright 2011 CPL Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideShowViewController.h"

@class SlideShowViewController;

@interface SlideShowAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SlideShowViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SlideShowViewController *viewController;

@end

