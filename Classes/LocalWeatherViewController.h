//
//  LocalWeatherViewController.h
//  LocalWeather
//
//  Created by Matt Tuzzolo on 8/30/10.
//  Copyright iCodeBlog LLC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "ICB_WeatherConditions.h"
#import <CoreLocation/CoreLocation.h>
#import "SetupViewController.h"

@interface LocalWeatherViewController : UIViewController 
		<MKReverseGeocoderDelegate, CLLocationManagerDelegate> 
{
	// current conditions
    IBOutlet UILabel *currentTempLabel, *conditionsLabel, *cityLabel;
	IBOutlet UILabel *humidityLabel, *windLabel;
	//forecast data
	IBOutlet UILabel *day1Label, *lowTempDay1Label, *highTempDay1Label, *conditionsDay1Label;
	IBOutlet UILabel *day2Label, *lowTempDay2Label, *highTempDay2Label, *conditionsDay2Label;
	IBOutlet UILabel *day3Label, *lowTempDay3Label, *highTempDay3Label, *conditionsDay3Label;
	IBOutlet UILabel *day4Label, *lowTempDay4Label, *highTempDay4Label, *conditionsDay4Label;
	
    IBOutlet UIImageView *conditionsImageView;
	IBOutlet UIImageView *conditionsImageViewDay1, *conditionsImageViewDay2, *conditionsImageViewDay3, *conditionsImageViewDay4;
    UIImage *conditionsImage;
	UIImage *conditionsImageDay1, *conditionsImageDay2, *conditionsImageDay3, *conditionsImageDay4;
	IBOutlet UILabel *latitudeLabel, *longitudeLabel;
	CLLocationManager *locationManager;
	CLLocation *myLocation;
	IBOutlet UILabel *currentDateTimeLabel;
	BOOL am;
	BOOL displayF;
	NSString *currentZip;
	NSTimer *hourTicker;
	IBOutlet UIButton *tempUnitsButton;
}

@property (nonatomic, retain) IBOutlet UILabel *currentTempLabel, *conditionsLabel, *cityLabel;
@property (nonatomic, retain) IBOutlet UILabel *humidityLabel, *windLabel;
@property (nonatomic, retain) IBOutlet UILabel *day1Label, *lowTempDay1Label, *highTempDay1Label, *conditionsDay1Label;
@property (nonatomic, retain) IBOutlet UILabel *day2Label, *lowTempDay2Label, *highTempDay2Label, *conditionsDay2Label;
@property (nonatomic, retain) IBOutlet UILabel *day3Label, *lowTempDay3Label, *highTempDay3Label, *conditionsDay3Label;
@property (nonatomic, retain) IBOutlet UILabel *day4Label, *lowTempDay4Label, *highTempDay4Label, *conditionsDay4Label;
@property (nonatomic, retain) IBOutlet UIImageView *conditionsImageView;
@property (nonatomic, retain) IBOutlet UIImageView *conditionsImageViewDay1, *conditionsImageViewDay2, *conditionsImageViewDay3, *conditionsImageViewDay4;
@property (nonatomic, retain) UIImage *conditionsImage;
@property (nonatomic, retain) UIImage *conditionsImageDay1, *conditionsImageDay2, *conditionsImageDay3, *conditionsImageDay4;
@property (nonatomic, retain) IBOutlet UILabel *latitudeLabel, *longitudeLabel;
@property (nonatomic, retain) NSString *currentZip;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *myLocation;
@property (nonatomic, retain) IBOutlet UILabel *currentDateTimeLabel;
@property (nonatomic, retain) IBOutlet UIButton *tempUnitsButton;

- (IBAction)switchTempUnits:(UIButton *)sender;
- (void)showWeatherFor:(NSString *)query;
- (void)updateUI:(ICB_WeatherConditions *)weather;

@end

