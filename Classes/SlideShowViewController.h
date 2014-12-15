//
//  SlideShowViewController.h
//  SlideShow
//
//  Created by Chris Lamb on 1/24/11.
//  Copyright 2011 CPL Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetupViewController.h"

@interface SlideShowViewController : UIViewController 
		<SetupViewDelegate, UIPopoverControllerDelegate>
{
	UIPopoverController *setupPopover;
	NSArray *animationImages;
	double delaySeconds;
	int i;
	BOOL animateSlideShow;
	BOOL clockShowing;
	BOOL weatherShowing;
	BOOL radioShowing;
	BOOL forecastShowing;
	BOOL setupShowing;
	BOOL justSlideshow;
	UIImage *lastPhoto;
	UIImageView *lastPhotoView;
	IBOutlet UIImageView *pictureView;		
	IBOutlet UIView *weatherView;
	IBOutlet UIView *radioView;
	IBOutlet UIView *clockView;
	IBOutlet UIView *forecastView;
	UIView *viewTop, *viewBottom;	
	IBOutlet UIButton *radioButton, *weatherButton, *clockButton, *infoButton;
	IBOutlet UILabel *clockLabel;
	IBOutlet UILabel *dateLabel;
	IBOutlet UIView *setupView;
	BOOL timeLabelBig;
	NSTimer *myTicker;
	
	IBOutlet UIView *titleView, *descriptionView;
	IBOutlet UILabel *titleLabel, *descriptionLabel;
	BOOL descriptionShowing, titleShowing;
	NSArray *photoArray;
	IBOutlet UITextView *descriptionText;
	
}
@property (nonatomic, retain) UIPopoverController *setupPopover;
@property (nonatomic, retain) NSArray *animationImages;
@property (nonatomic, retain) IBOutlet UIImageView *pictureView;
@property double delaySeconds;
@property (nonatomic, retain) UIImage *lastPhoto;
@property (nonatomic, retain) UIImageView *lastPhotoView;
@property (nonatomic, retain) UIView *viewTop, *viewBottom;
@property (nonatomic, retain) IBOutlet UIView *weatherView;
@property (nonatomic, retain) IBOutlet UIView *clockView;
@property (nonatomic, retain) IBOutlet UIView *radioView;
@property (nonatomic, retain) IBOutlet UIView *forecastView;
@property (nonatomic, retain) IBOutlet UILabel *clockLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UIView *setupView;
@property (nonatomic, retain) IBOutlet UIButton *radioButton, *weatherButton, *clockButton, *infoButton;

@property (nonatomic, retain) IBOutlet UIView *titleView, *descriptionView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel, *descriptionLabel;
@property (nonatomic, retain) NSArray *photoArray;
@property (nonatomic, retain) IBOutlet UITextView *descriptionText;

- (IBAction)showInfo:(id)sender;
- (void)runTimer;						
- (void)runClock;
- (IBAction)switchView:(UIButton *)sender;

@end

