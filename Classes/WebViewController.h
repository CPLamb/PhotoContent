//
//  WebViewController.h
//  SlideShow
//
//  Created by Chris Lamb on 2/16/11.
//  Copyright 2011 CPL Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>s

@interface WebViewController : UIViewController 
{
	IBOutlet UIWebView *webView;
}

-(IBAction)closeWebView;

@end
