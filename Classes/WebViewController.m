    //
//  WebViewController.m
//  SlideShow
//
//  Created by Chris Lamb on 2/16/11.
//  Copyright 2011 CPL Consulting. All rights reserved.
//

#import "WebViewController.h"


@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://itunes.apple.com/us/artist/blue-lotus/id378714094"]]];
}

-(IBAction)closeWebView
{
	NSLog(@"Closing the web view");
	[self.view removeFromSuperview];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)dealloc {
    [super dealloc];
}


@end
