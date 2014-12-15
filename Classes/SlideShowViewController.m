//
//  SlideShowViewController.m
//  SlideShow
//
//  Created by Chris Lamb on 1/24/11.
//  Copyright 2011 CPL Consulting. All rights reserved.
//

#import "SlideShowViewController.h"
#import "LocalWeatherViewController.h"
#import "MainViewController.h"
#import "SetupViewController.h"
#import "WebViewController.h"

@implementation SlideShowViewController

@synthesize setupPopover;
@synthesize animationImages, pictureView;
@synthesize delaySeconds;
@synthesize weatherView;
@synthesize clockView, clockLabel, dateLabel;
@synthesize radioView, forecastView;
@synthesize lastPhoto, lastPhotoView;
@synthesize setupView;
@synthesize radioButton, weatherButton, clockButton, infoButton;
@synthesize viewTop, viewBottom;

@synthesize titleLabel, descriptionLabel, titleView, descriptionView;
@synthesize photoArray;
@synthesize descriptionText;

#pragma mark Application setup methods
#pragma mark ------------------------------------------------

- (void)viewDidLoad 
{
    [super viewDidLoad];	
// initializes all views & sets the switches in the popover
	animateSlideShow = YES;
	delaySeconds = 7.0;
	weatherShowing = NO;
	clockShowing = YES;
	radioShowing = NO;
	forecastShowing = NO;
	timeLabelBig = YES;
	justSlideshow = NO;
	i = 1;
	[self photoLoop];
	self.descriptionView.alpha = 0.0;
	titleShowing = YES;
	
//basic screen setup
	self.view.backgroundColor = [UIColor blackColor];
	
//clockView display
	[self.view addSubview:clockView];
	[self runTimer];
	
//radioView display
	MainViewController *radiovc = [[MainViewController alloc]
								   initWithNibName:@"MainView" bundle:nil];
	// Add view formatting here 
	radiovc.view.frame = CGRectMake(0.0, 468.0, 1024.0, 300.0);		
	radioView = radiovc.view;
	[self.view addSubview:radioView];
	[radiovc release];
	radioView.alpha = 0.0;
	
// Add in weatherView
	LocalWeatherViewController *lwvc = [[LocalWeatherViewController alloc]
										initWithNibName:@"LocalWeatherViewController" bundle:nil];	
	lwvc.view.frame = CGRectMake(0.0, 468.0, 1024.0, 300.0);
	weatherView = lwvc.view;
	[self.view addSubview:weatherView];
	weatherView.alpha = 0.0;
	
/*forecastView display
	LocalWeatherViewController *forecastvc = [[LocalWeatherViewController alloc]
											  initWithNibName:@"ForecastView" bundle:nil];
	forecastvc.view.frame = CGRectMake(0.0, 468.0, 1024.0, 300.0);	
*/ 
//	forecastView = forecastvc.view;
	forecastView = lwvc.view;
	[self.view addSubview:forecastView];
	forecastView.alpha = 0.0;

	
//allows for 2 tap gesture to hide/show all widgets
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] 
											 initWithTarget:self
											 action:@selector(allViewsDoubleTap:)];
	tapRecognizer.numberOfTapsRequired = 2;
	tapRecognizer.numberOfTouchesRequired = 1;
	[self.view addGestureRecognizer:tapRecognizer];
	[tapRecognizer release];

// Start/Stop Slideshow single long touch gesture 
//	UILongPressGestureRecognizer *tapRunSlideshow = [[UILongPressGestureRecognizer alloc]
//													 initWithTarget:self
//													 action:@selector(switchSlideShowView)];
	 UITapGestureRecognizer *tapRunSlideshow = [[ UITapGestureRecognizer alloc] 
												initWithTarget:self
												action:@selector(switchSlideShowView)];
	tapRunSlideshow.numberOfTapsRequired = 3;
	tapRunSlideshow.numberOfTouchesRequired = 1;
//	tapRunSlideshow.minimumPressDuration = 4.0;
	[self.view addGestureRecognizer:tapRunSlideshow];
	[tapRunSlideshow release];	
			
// titleView single tap show/hide descriptionView 
	 UITapGestureRecognizer *tapTitle = [[UITapGestureRecognizer alloc] 
										 initWithTarget:self
										 action:@selector(titleViewTap:)];
	 tapTitle.numberOfTapsRequired = 1;
	 tapTitle.numberOfTouchesRequired = 1;
	 [self.titleView addGestureRecognizer:tapTitle];
	 [tapTitle release];	
	 	
//allows for buttons to be top level view
	[self.view bringSubviewToFront:clockButton];
	[self.view bringSubviewToFront:weatherButton];
	[self.view bringSubviewToFront:radioButton];
	[self.view bringSubviewToFront:infoButton];	
	
// read the photo data from the plist
	NSString *thePath = [[NSBundle mainBundle] pathForResource:@"0Elements" ofType:@"plist"];
	photoArray = [[NSArray alloc] initWithContentsOfFile:thePath];
	
}

// Allows the program to only run in landscape
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || 
	(interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc {
	[lastPhotoView release];
	[lastPhoto release];
	[setupPopover release];
	[animationImages release];
	[pictureView release];
	[weatherView release];
	[clockLabel release];
	[dateLabel release];
	[clockView release];
	[radioView release];
	[forecastView release];
	[setupView release];
	[radioButton release];
	[weatherButton release];
	[clockButton release];
	[infoButton release];
	[viewTop release];
	[viewBottom release];
	
	[titleLabel release];
	[descriptionLabel release];
	[titleView release];
	[descriptionView release];
	[photoArray release];
	[descriptionText release];
	
    [super dealloc];
}

#pragma mark SetupViewDelegate methods
#pragma mark ------------------------------------------------

-(IBAction)changeTransitionDelay:(SetupViewController *)controller		//Time delay between transitions
{
	self.delaySeconds = controller.transitionDelaySlider.value;
}

- (void)switchTitleView:(SetupViewController *)controller
{
	NSLog(@"Show / Hide title");
	if (titleShowing) {				//Hide view
		titleShowing = NO;
//		titleView.alpha = 0.0;
		[UIView animateWithDuration:1.0 delay:0.0 
						options:UIViewAnimationOptionAllowUserInteraction	
						animations:^{
							//titleView.alpha = 0.0;
							[self.titleView setTransform:CGAffineTransformMakeScale(0.005, 1.0)];
							//self.titleView.contentScaleFactor = 0.0;
						 }
						 completion: ^ (BOOL finished) {
							 self.titleView.alpha = 0.0;
						 }];
		 } else {						//show view
		titleShowing = YES;
		titleView.alpha = 0.75;
		[UIView animateWithDuration:2.0 delay:0.0 
						options:UIViewAnimationOptionAllowUserInteraction	
						animations:^{
							[self.titleView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
						 }
						 completion: NULL];					
	}
}

-(void)switchSlideShowView  //establishes loop for slideShow
{
	NSLog(@"animate slideshow toggled!!!!");
	
	if (!animateSlideShow) {
		animateSlideShow = YES;
		[self photoLoop];
		[lastPhotoView removeFromSuperview];
	} else {
		animateSlideShow = NO;		
	//shows last photo if slideShow OFF
		lastPhotoView = [[UIImageView alloc] initWithImage:lastPhoto];
		[self.view addSubview:lastPhotoView];
		[self.view sendSubviewToBack:lastPhotoView];
		[lastPhotoView release];
	}
}

- (void)displayURL
{
	[self.setupPopover dismissPopoverAnimated:YES];
	WebViewController *webViewController = [[WebViewController alloc] init];
	[self.view addSubview:[webViewController view]];
	
}

#pragma mark SlideShowViewController widget animation methods

// toggles weather & forecast views	
- (void)weatherViewTap:(UITapGestureRecognizer *)recognizer
{
	NSLog(@"Toggles Weather & Forecast views");
	if (weatherShowing) {		// Display forecast view
		weatherShowing = NO;
		forecastShowing = YES;
		self.forecastView.center = CGPointMake(512.0, 618.0);
		[UIView animateWithDuration:2.0 delay:0.0 
							options:UIViewAnimationOptionAllowUserInteraction	
						 animations:^{
							 self.forecastView.alpha = 1.0;
							 self.weatherView.alpha = 0.0;
						 }
						 completion: NULL];
	} else {					// Display weather view
		weatherShowing = YES;
		forecastShowing = NO;
		self.weatherView.center = CGPointMake(512.0, 618.0);
		[UIView animateWithDuration:2.0 delay:0.0 
							options:UIViewAnimationOptionAllowUserInteraction	
						 animations:^{
							 self.weatherView.alpha = 1.0;
							 self.forecastView.alpha = 0.0;
						 }
						 completion: NULL];
	}		
}

// 2 taps gesture for hiding widgets
- (void)allViewsDoubleTap:(UITapGestureRecognizer *)recognizer
{
	NSLog(@"Double Tapped");
	
	// view Buttons fade UP/DOWN 
	if (!justSlideshow) {
		justSlideshow = YES;
		[UIView animateWithDuration:2.0 delay:0.0 
							options:UIViewAnimationOptionAllowUserInteraction 		
						 animations:^{
							 self.radioButton.center = CGPointMake(955.0, 1020.0);
							 self.weatherButton.center = CGPointMake(895.0, 1020.0);
							 self.clockButton.center = CGPointMake(835.0, 1020.0);
							 self.infoButton.center = CGPointMake(40.0, 1020.0);
						 }
						 completion: NULL];					
	} else {
		justSlideshow = NO;		
		[UIView animateWithDuration:2.0 delay:0.0 
							options:UIViewAnimationOptionAllowUserInteraction	
						 animations:^{
							 self.radioButton.center = CGPointMake(955.0, 730.0);
							 self.weatherButton.center = CGPointMake(895.0, 730.0);
							 self.clockButton.center = CGPointMake(835.0, 730.0);
							 self.infoButton.center = CGPointMake(40.0, 730.0);
						 }
						 completion: NULL];
	}		
	// clockView fade UP/DOWN 
	if (!clockShowing) {
		clockShowing = YES;
		[UIView animateWithDuration:2.0 delay:0.0 
							options:UIViewAnimationOptionAllowUserInteraction 		
						 animations:^{
							 self.clockView.center = CGPointMake(512.0, 618.0);
						 }
						 completion: NULL];					
	} else {
		clockShowing = NO;		
		[UIView animateWithDuration:2.0 delay:0.0 
							options:UIViewAnimationOptionAllowUserInteraction	
						 animations:^{
							 self.clockView.center = CGPointMake(512.0, 918.0);
						 }
						 completion: NULL];			
	}		
	// radioView fade UP/DOWN 
	if (!radioShowing) {
		radioShowing = YES;
		[UIView animateWithDuration:2.0 delay:0.0 
							options:UIViewAnimationOptionAllowUserInteraction 		
						 animations:^{
							 self.radioView.center = CGPointMake(512.0, 618.0);
						 }
						 completion: NULL];					
	} else {
		radioShowing = NO;		
		[UIView animateWithDuration:2.0 delay:0.0 
							options:UIViewAnimationOptionAllowUserInteraction	
						 animations:^{
							 self.radioView.center = CGPointMake(512.0, 918.0);
						 }
						 completion: NULL];			
	}
	// weatherView fade UP/DOWN
	if (!weatherShowing) {
		weatherShowing = YES;
		[UIView animateWithDuration:2.0 delay:0.0 
							options:UIViewAnimationOptionAllowUserInteraction 		
						 animations:^{
							 self.weatherView.center = CGPointMake(512.0, 618.0);
						 }
						 completion: NULL];					
	} else {
		weatherShowing = NO;		
		[UIView animateWithDuration:2.0 delay:0.0 
							options:UIViewAnimationOptionAllowUserInteraction	
						 animations:^{
							 self.weatherView.center = CGPointMake(512.0, 918.0);
						 }
						 completion: NULL];			
	}		
	// forecastView fade UP/DOWN 
	if (!forecastShowing) {
		forecastShowing = YES;
		[UIView animateWithDuration:2.0 delay:0.0 
							options:UIViewAnimationOptionAllowUserInteraction 		
						 animations:^{
							 self.forecastView.center = CGPointMake(512.0, 618.0);
						 }
						 completion: NULL];					
	} else {
		forecastShowing = NO;		
		[UIView animateWithDuration:2.0 delay:0.0 
							options:UIViewAnimationOptionAllowUserInteraction	
						 animations:^{
							 self.forecastView.center = CGPointMake(512.0, 918.0);
						 }
						 completion: NULL];			
	}	
	// titleView fade UP/DOWN 
	if (!titleShowing) {
		titleShowing = YES;
		[UIView animateWithDuration:2.0 delay:0.0 
							options:UIViewAnimationOptionAllowUserInteraction 		
						 animations:^{
							 self.titleView.center = CGPointMake(500.0, 60.0);
						 }
						 completion: NULL];					
	} else {
		titleShowing = NO;	
		descriptionView.alpha = 0.0;
		descriptionShowing = NO;
		[UIView animateWithDuration:2.0 delay:0.0 
							options:UIViewAnimationOptionAllowUserInteraction	
						 animations:^{
							 self.titleView.center = CGPointMake(500.0, -240.0);
						 }
						 completion: NULL];			
	}	
}

- (IBAction)switchView:(UIButton *)sender
{
	NSLog(@"The %@ button was pressed", sender.titleLabel.text);
	clockShowing = YES;
	radioShowing = NO;
//	weatherShowing = NO;
	forecastShowing = NO;	
	
	if ([sender.titleLabel.text isEqualToString:@"Time"]) {
		self.clockView.center = CGPointMake(512.0, 618.0);
		clockShowing = YES;
		radioShowing = NO;
		weatherShowing = NO;
		weatherButton.selected = NO;
		forecastShowing = NO;
		[UIView animateWithDuration:1.0 delay:0.0 
							options:UIViewAnimationOptionAllowUserInteraction	
						 animations:^{
							 self.clockView.alpha = 1.0;

							 self.weatherView.alpha = 0.0;
							 self.radioView.alpha = 0.0;
							 self.forecastView.alpha = 0.0;
						 }
						 completion: NULL];			
		[UIView animateWithDuration:1.5 delay:0.5 
							options:UIViewAnimationOptionAllowUserInteraction	
						 animations:^{
							 [self.clockLabel setTransform:CGAffineTransformMakeTranslation(0.0, 0.0)];
							 [self.dateLabel setTransform:CGAffineTransformMakeTranslation(0.0, 0.0)];
						 }
						 completion: NULL];			
	}
	
// transitions to weather OR forecast
	if ([sender.titleLabel.text isEqualToString:@"Weather"]) {
		if (!weatherShowing) {
			self.weatherView.center = CGPointMake(512.0, 618.0);
			weatherShowing = YES;
			weatherButton.selected = YES;
			clockShowing = YES;
			radioShowing = NO;
			forecastShowing = NO;		
			[UIView animateWithDuration:1.5 delay:1.0
								options:UIViewAnimationOptionAllowUserInteraction	
							 animations:^{
								 self.weatherView.alpha = 1.0;
								 
								 self.radioView.alpha = 0.0;
								 self.forecastView.alpha = 0.0;
							 }
							 completion: NULL];	
			
			[UIView animateWithDuration:1.5 delay:0.0 
								options:UIViewAnimationOptionAllowUserInteraction
							 animations:^{
								 [self transformTime];
							 }
							 completion: NULL];	
			
		} else {
			self.forecastView.center = CGPointMake(512.0, 618.0);
			forecastShowing = YES;
			clockShowing = YES;
			radioShowing = NO;
			weatherShowing = NO;		
			weatherButton.selected = NO;
			[UIView animateWithDuration:1.5 delay:0.0 
								options:UIViewAnimationOptionAllowUserInteraction	
							 animations:^{
								 self.forecastView.alpha = 1.0;
								 self.weatherView.alpha = 0.0;
							 }
							 completion: NULL];
 
		}
 }
// transitions to radio view	
	if ([sender.titleLabel.text isEqualToString:@"Radio"]) {
		self.radioView.center = CGPointMake(512.0, 618.0);
		radioShowing = YES;
		clockShowing = YES;
		weatherShowing = NO;
		weatherButton.selected = NO;
		forecastShowing = NO;
		[UIView animateWithDuration:1.5 delay:1.0 
							options:UIViewAnimationOptionAllowUserInteraction	
						 animations:^{
							 self.radioView.alpha = 1.0;
							 self.weatherView.alpha = 0.0;
							 self.forecastView.alpha = 0.0;
						 }
						 completion: NULL];		
					
		[UIView animateWithDuration:1.5 delay:0.0 
							options:UIViewAnimationOptionAllowUserInteraction	
						 animations:^{
							 [self transformTime];
	 }
						 completion: NULL];	
	}	
}

- (void)transformTime		//performs scale & translate transition
{
	CGAffineTransform transformTranslate = CGAffineTransformMakeTranslation(-330.0, 15.0);
	CGAffineTransform transformScale = CGAffineTransformMakeScale(0.5, 0.5);
	CGAffineTransform transformClock = CGAffineTransformConcat(transformScale, transformTranslate);
	[self.clockLabel setTransform:transformClock];
	[self.dateLabel setTransform:CGAffineTransformMakeTranslation(-330.0, 0.0)];
}

// single tap in titleView shows/hides descriptionView	
- (void)titleViewTap:(UITapGestureRecognizer *)recognizer
{
	NSLog(@"Toggles description view display");
//	CGAffineTransform showDescription = CGAffineTransformMakeScale(1.0, 0.0);
	if (!descriptionShowing) {		// Display description view
		descriptionShowing = YES;
		[UIView animateWithDuration:2.0 delay:0.0 
							options:UIViewAnimationOptionAllowUserInteraction	
						 animations:^{
//							 [self.descriptionView setTransform:showDescription];
							 self.descriptionView.alpha = 0.75;
						 }
						 completion: NULL];
	} else {					// Hide description view
		descriptionShowing = NO;
		[UIView animateWithDuration:2.0 delay:0.0 
							options:UIViewAnimationOptionAllowUserInteraction	
						 animations:^{
//							 [self.descriptionView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
							 self.descriptionView.alpha = 0.0;
						 }
						 completion: NULL];
	}		
}

#pragma mark Photo Transistion methods
#pragma mark --------------
- (void)fadeFromPhoto:(UIImage *)fromPhoto toPhoto:(UIImage *)toPhoto;
{	
//	NSLog(@"starting fadeFromPhoto with %2.0f delay", delaySeconds);
	// tests an animate with 2 images converts jpegs to UIView where animation is done	
	UIImageView *tv01 = [[UIImageView alloc] initWithImage:fromPhoto];
	UIImageView *bv02 = [[UIImageView alloc] initWithImage:toPhoto];
	CGRect frame = CGRectMake(0.0, 0.0, 200.0, 200.0);
	viewTop = [[UIView alloc] initWithFrame:frame];
	CGRect frame02 = CGRectMake(0.0, 0.0, 200.0, 200.0);
	viewBottom = [[UIView alloc] initWithFrame:frame02];
	
	[viewTop addSubview:tv01];
	[viewBottom addSubview:bv02];
	[tv01 release];
	[bv02 release];
	
	viewBottom.alpha = 0.0;			// start viewBottom alpha as 0 so it can transition to 1.0
	[self.view addSubview:viewBottom];
	[self.view sendSubviewToBack:viewBottom];
	[self.view addSubview:viewTop];
	[self.view sendSubviewToBack:viewTop];

// performSelectorInBackground caused leaks & didn't seem to work
//	[self performSelectorInBackground:(@selector(photoLoopAnimation)) withObject:nil];
	[self photoLoopAnimation];
}

-(void)photoLoopAnimation
{
	// FADE block animation method - THIS contains the basic animation features	
	[UIView animateWithDuration:1.2 delay:delaySeconds 
						options:UIViewAnimationOptionAllowUserInteraction		
					 animations:^{
						 viewTop.alpha = 0.0;
						 viewBottom.alpha = 1.0;
					 }
					 completion:^(BOOL finished) {			// remove both views & loop to slideShowSwitch
						 [viewTop removeFromSuperview];  
						 [viewBottom removeFromSuperview];
						 [viewTop release];
						 [viewBottom release];
						 [self photoLoop];
					 }];	
}

-(void)photoLoop
{
	if (animateSlideShow) {
//		NSLog(@"Animation loop is at counter i = %d                   ", i);
		// simple reset of loop counter
		if (i >= 100) {
			i = 1;
		}
		NSString *fromName = [NSString stringWithFormat:@"image%d", i];
		NSString *fromPhotoName = [[NSBundle mainBundle] pathForResource:fromName ofType:@"jpg"];
		UIImage *fromPhoto = [UIImage imageWithContentsOfFile:fromPhotoName];
		lastPhoto = fromPhoto;			//photo displayed when animation OFF
		if ((i+1) >= 100) {
			i = 0;
		}
		NSString *toName = [NSString stringWithFormat:@"image%d", (i+1)];
		NSString *toPhotoName = [[NSBundle mainBundle] pathForResource:toName ofType:@"jpg"];
//		NSLog(@"fromPhoto = %@ AND toPhoto = %@", fromName, toName);
		UIImage *toPhoto = [UIImage imageWithContentsOfFile:toPhotoName];
		lastPhoto = fromPhoto;			//photo displayed when animation OFF
		[self fadeFromPhoto:fromPhoto toPhoto:toPhoto];
		
// loads data from 0photoData.plist into title & description fields
		NSString *photoItem = [NSString stringWithFormat:@"item%d", (i+1)];
		NSDictionary *photoInfo = [[NSDictionary alloc] init];
		photoInfo = [photoArray objectAtIndex:i];
		NSString *title = [photoInfo objectForKey:@"name"];
 		titleLabel.text = title;
		
		NSString *state = [photoInfo objectForKey:@"state"];
		NSString *weight = [photoInfo objectForKey:@"atomicWeight"];
		NSString *year = [photoInfo objectForKey:@"discoveryYear"];
		descriptionLabel.text = [NSString stringWithFormat:@"Photo %@ is a %@ was discovered in %@ and was found to weigh %@", photoItem, state, year, weight];
		[descriptionText.font fontWithSize:28.0];
		descriptionText.text = descriptionLabel.text;
		NSLog(@"Item %d in the dictionary is %@", i, title);
		
		[photoInfo release];
		
		i++;	
	}
}

#pragma mark clockView methods

- (void)runTimer					//Starts a timer which messages runClock every 0.5sec
{
	myTicker = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(runClock)
											  userInfo:nil repeats:YES];
}

- (void)runClock
{
	NSDate *date = [NSDate date]; 

	// time string
	NSDateFormatter *timeFormatter = [[[NSDateFormatter alloc] init] autorelease]; 
	[timeFormatter setTimeStyle:NSDateFormatterMediumStyle]; 
	
	// date string
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
	
	//swaps time & date strings based upon timeDateSwap boolean
	if (timeLabelBig) {
		[dateLabel setText:[dateFormatter stringFromDate:date]];
		[clockLabel setText:[timeFormatter stringFromDate:date]]; 
	} else {
		[dateLabel setText:[timeFormatter stringFromDate:date]];
		[clockLabel setText:[dateFormatter stringFromDate:date]]; 
	}
}

- (IBAction)showInfo:(id)sender
{
	NSLog(@"Setup popover should display");
	
	SetupViewController *popoverView = [[SetupViewController alloc] init];
	popoverView.delegate = self;
	
	// Creates the popoverController object
	setupPopover = [[UIPopoverController alloc] initWithContentViewController:popoverView];
	[setupPopover setDelegate:self];
	[setupPopover presentPopoverFromRect:CGRectMake(512, 200, 10, -30) inView:self.view permittedArrowDirections:0 animated:NO];
	[setupPopover setPopoverContentSize:CGSizeMake(500, 400)];
	
	//makes sure that switches display actual status of views
	popoverView.titleSwitch.on = titleShowing;
	popoverView.transitionDelaySlider.value = delaySeconds;
	
	[popoverView release];
}



@end
