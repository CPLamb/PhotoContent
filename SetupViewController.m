//
//  SetupViewController.m
//
//  Created by Chris Lamb on 2/15/11.
//  Copyright 2011 CPL Consulting. All rights reserved.
//

#import "SetupViewController.h"
#import "WebViewController.h"

@implementation SetupViewController
@synthesize delegate;
@synthesize titleSwitch;
@synthesize transitionDelaySlider;

#pragma mark switch controls methods -------------------------------


-(IBAction)switchTitle:(id)sender
{
	NSLog(@"Title switch toggled");
	[self.delegate switchTitleView:self];
}

-(IBAction)transitionDelay:(UISlider *)sender
{
	[self.delegate changeTransitionDelay:self];
}

-(IBAction)urlButton:(id)sender
{
	NSLog(@"Accessing our iTunes page");
	[self.delegate displayURL];
}

#pragma mark  Application setup methods ----------------------------

- (void)viewDidLoad {
	[self.view bringSubviewToFront:titleSwitch];	

	[super viewDidLoad];
}

- (void)dealloc {
	[titleSwitch release];
	[transitionDelaySlider release];
    [super dealloc];
}


@end