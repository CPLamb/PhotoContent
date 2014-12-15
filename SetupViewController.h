//
//  SetupViewController.h
//
//  Created by Chris Lamb on 2/15/11.
//  Copyright 2011 CPL Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "WebViewController.h"

@protocol SetupViewDelegate;	//forward reference to the delegate protocol below

@interface SetupViewController : UIViewController 
{
	id <SetupViewDelegate> delegate;

	IBOutlet UISwitch *titleSwitch;
	IBOutlet UISlider *transitionDelaySlider;
	
}
@property (assign) id <SetupViewDelegate> delegate;
@property (nonatomic, retain) IBOutlet UISwitch *titleSwitch;
@property (nonatomic, retain) IBOutlet UISlider *transitionDelaySlider;
@property (nonatomic, retain) IBOutlet UISegmentedControl *tempUnitsSwitch;

-(IBAction)switchTitle:(id)sender;
-(IBAction)transitionDelay:(UISlider *)sender;
-(IBAction)urlButton:(id)sender;

@end

@protocol SetupViewDelegate
@optional
- (void)switchTitleView:(SetupViewController *)controller;
- (void)changeTransitionDelay:(SetupViewController *)controller;
- (void)displayURL;

@end