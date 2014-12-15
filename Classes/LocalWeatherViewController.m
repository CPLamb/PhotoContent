//
//  LocalWeatherViewController.m
//  LocalWeather
//
//  Created by Matt Tuzzolo on 8/30/10.
//  Copyright iCodeBlog LLC 2010. All rights reserved.
//

#import "LocalWeatherViewController.h"
#import "ICB_WeatherConditions.h"
#import "MapKit/MapKit.h"

@implementation LocalWeatherViewController

@synthesize currentTempLabel, conditionsLabel, cityLabel;
@synthesize windLabel, humidityLabel;
@synthesize day1Label, lowTempDay1Label, highTempDay1Label, conditionsDay1Label;
@synthesize day2Label, lowTempDay2Label, highTempDay2Label, conditionsDay2Label;
@synthesize day3Label, lowTempDay3Label, highTempDay3Label, conditionsDay3Label;
@synthesize day4Label, lowTempDay4Label, highTempDay4Label, conditionsDay4Label;
@synthesize conditionsImageView;
@synthesize conditionsImageViewDay1, conditionsImageViewDay2, conditionsImageViewDay3, conditionsImageViewDay4;
@synthesize conditionsImage;
@synthesize conditionsImageDay1, conditionsImageDay2, conditionsImageDay3, conditionsImageDay4;
@synthesize latitudeLabel, longitudeLabel;
@synthesize myLocation, locationManager;
@synthesize currentDateTimeLabel;
@synthesize currentZip;
@synthesize tempUnitsButton;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

/*	if (0) //you have coordinates but need a city
    {
        // Check out Part 1 of the tutorial to see how to find your Location with CoreLocation
        CLLocationCoordinate2D coord;    
        coord.latitude = 38.9341;
        coord.longitude = -119.9108;

        // Geocode coordinate (normally we'd use location.coordinate here instead of coord).
        // This will get us something we can query Google's Weather API with
        MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:coord];
        geocoder.delegate = self;
        [geocoder start];
    }
    else // You already know your users zipcode, city, or otherwise.
    {
        // Do this in the background so we don't lock up the UI.
        [self performSelectorInBackground:@selector(showWeatherFor:) withObject:@"07417"];
    }
*/
//  [self performSelectorInBackground:@selector(showWeatherFor:) withObject:@"48023"];

	//starts core location stuff
	[[self locationManager] startUpdatingLocation];
	
	//custom font for labels... commented out to test 'LabelOptima class' 
	//[currentTempLabel setFont: [UIFont fontWithName: @"OptimaLTStd" size: currentTempLabel.font.pointSize]];
//	[highTempDay1Label setFont: [UIFont fontWithName: @"OptimaLTStd" size: highTempDay1Label.font.pointSize]];
//	[lowTempDay1Label setFont: [UIFont fontWithName: @"OptimaLTStd" size: lowTempDay1Label.font.pointSize]];
//	[conditionsLabel setFont: [UIFont fontWithName: @"OptimaLTStd" size: conditionsLabel.font.pointSize]];
//	[cityLabel setFont: [UIFont fontWithName: @"OptimaLTStd" size: cityLabel.font.pointSize]];
	
	[self.view bringSubviewToFront:tempUnitsButton];
	[self hourTimer];
}

// This will run in the background
- (void)showWeatherFor:(NSString *)query
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"performing showWeatherFor method (XML stuff)");
    ICB_WeatherConditions *weather = [[ICB_WeatherConditions alloc] initWithQuery:query];
    
	// Figuring whether we're AM or PM
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease]; 
	NSDate *now = [NSDate date]; 
	// This will produce an 24 hour string
	[formatter setDateFormat:@"HH"];
	NSString *timeString =[formatter stringFromDate:now];
	int hour = [timeString intValue];
	NSLog(@"The hour VALUE is %d", hour);
	// compares the timeString value 5 < hour < 18 and sets BOOL am or day
	if ((hour > 5) && (hour < 18)) {		
		am = YES;
	} else {
		am = NO;
	}	
	
	self.conditionsImage = [self selectWeatherIconFor:weather.condition];	
	// displays conditions for forecast days
	self.conditionsImageDay1 = [self selectWeatherIconFor:weather.conditionDay1];
	self.conditionsImageDay2 = [self selectWeatherIconFor:weather.conditionDay2];
	self.conditionsImageDay3 = [self selectWeatherIconFor:weather.conditionDay3];
	self.conditionsImageDay4 = [self selectWeatherIconFor:weather.conditionDay4];

    // executes updateUI
	[self performSelectorOnMainThread:@selector(updateUI:) withObject:weather waitUntilDone:NO];

    [pool release];
}

- (UIImage *)selectWeatherIconFor:(NSString *)condition 
{
	NSLog(@"Trying to pick icons for %@", condition);
	UIImage *icon = [[UIImage alloc] init];
	
// selection statements for custom weather icons
// default if condition string is unknown
	if (am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
																 pathForResource:@"weather_default.png" ofType:nil]];
	} else {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
																 pathForResource:@"weather_default.png" ofType:nil]];
	}
// Sunny/Clear
	if (([condition isEqual:@"Sunny"] || [condition isEqual:@"Clear"]) && am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_amClear.png" ofType:nil]];
	} 
	if (([condition isEqual:@"Sunny"] || [condition isEqual:@"Clear"]) && !am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_pmClear.png" ofType:nil]];
	}
// Mostly Sunny/ Partly Cloudy
	if (([condition isEqual:@"Partly Cloudy"] || [condition isEqual:@"Mostly Sunny"]) && am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_amPartlyCloudy.png" ofType:nil]];
	} 
	if (([condition isEqual:@"Partly Cloudy"] || [condition isEqual:@"Mostly Sunny"]) && !am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_pmPartlyCloudy.png" ofType:nil]];
	}	
// Mostly Cloudy
	if ([condition isEqual:@"Mostly Cloudy"] && am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_amCloudy.png" ofType:nil]];
	} 
	if ([condition isEqual:@"Mostly Cloudy"] && !am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_pmCloudy.png" ofType:nil]];
	}	
// Overcast
	if ([condition isEqual:@"Overcast"] && am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_amFog.png" ofType:nil]];
	} 
	if ([condition isEqual:@"Overcast"] && !am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_pmFog.png" ofType:nil]];
	}
	
// Cloudy
	if ([condition isEqual:@"Cloudy"] && am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_cloudy.png" ofType:nil]];
	} 
	if ([condition isEqual:@"Cloudy"] && !am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_cloudy.png" ofType:nil]];
	}	
// Rain
	if ([condition isEqual:@"Rain"] && am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_rain.png" ofType:nil]];
	} 
	if ([condition isEqual:@"Rain"] && !am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_rain.png" ofType:nil]];
	}	
// Showers / Rain Showers (dont think either of these get called by google) 
	if (([condition isEqual:@"Showers"] || [condition isEqual:@"Rain Showers"])  && am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_rain.png" ofType:nil]];
	} 
	if (([condition isEqual:@"Showers"] || [condition isEqual:@"Rain Showers"]) && !am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_rain.png" ofType:nil]];
	}	
// Snow or Chance of Snow
	if (([condition isEqual:@"Snow"] || [condition isEqual:@"Chance of Snow"]) && am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_snow.png" ofType:nil]];
	} 
	if (([condition isEqual:@"Snow"] || [condition isEqual:@"Chance of Snow"]) && !am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_snow.png" ofType:nil]];
	}	
// Flurries
	if ([condition isEqual:@"Flurries"] && am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_snow.png" ofType:nil]];
	} 
	if ([condition isEqual:@"Flurries"] && !am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_snow.png" ofType:nil]];
	}	
// Chance of Thunderstorm or Thunderstorm
	if (([condition isEqual:@"Chance of Thunderstorm"] || [condition isEqual:@"Thunderstorm"]) && am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_thunderstorms.png" ofType:nil]];
	} 
	if (([condition isEqual:@"Chance of Thunderstorm"] || [condition isEqual:@"Thunderstorm"]) && !am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_thunderstorms.png" ofType:nil]];
	}	
// Chance of Rain or Chance of Showers
	if (([condition isEqual:@"Chance of Rain"] || [condition isEqual:@"Chance of Showers"]) && am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_amChanceOfRain.png" ofType:nil]];
	} 
	if (([condition isEqual:@"Chance of Rain"] || [condition isEqual:@"Chance of Showers"]) && !am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_pmChanceOfRain.png" ofType:nil]];
	}	
// Chance of Storm or Storm
	if (([condition isEqual:@"Chance of Storm"] || [condition isEqual:@"Storm"]) && am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_rain.png" ofType:nil]];
	} 
	if (([condition isEqual:@"Chance of Storm"] || [condition isEqual:@"Storm"]) && !am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_rain.png" ofType:nil]];
	}	
// Sleet
	if ([condition isEqual:@"Sleet"] && am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_sleet.png" ofType:nil]];
	} 
	if ([condition isEqual:@"Sleet"] && !am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_sleet.png" ofType:nil]];
	}	
// Icy 
	if (([condition isEqual:@"Icy"] || [condition isEqual:@"Ice"]) && am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_ice.png" ofType:nil]];
	} 
	if (([condition isEqual:@"Icy"] || [condition isEqual:@"Ice"]) && !am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_ice.png" ofType:nil]];
	}	
// Smoke
	if ([condition isEqual:@"Smoke"] && am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_amSmoke.png" ofType:nil]];
	} 
	if ([condition isEqual:@"Smoke"] && !am) {
		icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
												 pathForResource:@"weather_pmSsmoke.png" ofType:nil]];
	}	
		 
// Haze
	if ([condition isEqual:@"Haze"] && am) {
			 icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
													  pathForResource:@"weather_amHaze.png" ofType:nil]];
	} 
	if ([condition isEqual:@"Haze"] && !am) {
			 icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
													  pathForResource:@"weather_pmHaze.png" ofType:nil]];
	}
		 
// Dust
	if ([condition isEqual:@"Dust"] && am) {
			 icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
													  pathForResource:@"weather_amDust.png" ofType:nil]];
	} 
	if ([condition isEqual:@"Dust"] && !am) {
			 icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
													  pathForResource:@"weather_pmDust.png" ofType:nil]];
	}	
// Mist or Fog
	if (([condition isEqual:@"Mist"] || [condition isEqual:@"Fog"]) && am) {
			 icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
													  pathForResource:@"weather_amFog.png" ofType:nil]];
	} 
	if (([condition isEqual:@"Mist"] || [condition isEqual:@"Fog"]) && !am) {
			 icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
													  pathForResource:@"weather_pmFog.png" ofType:nil]];
}
		 
	
//	NSLog(@"icon = %@", icon);
	return icon;	
}								   
 
// This happens in the main thread
- (void)updateUI:(ICB_WeatherConditions *)weather
{
//	[self selectWeatherIconFor:weather.conditionDay1]; 
    self.conditionsImageView.image = self.conditionsImage;
    self.conditionsImageViewDay1.image = self.conditionsImageDay1;
    self.conditionsImageViewDay2.image = self.conditionsImageDay2;
    self.conditionsImageViewDay3.image = self.conditionsImageDay3;	
    self.conditionsImageViewDay4.image = self.conditionsImageDay4;

// Changes temp from fahrenheit to Celsius
	if (!displayF) {
		self.currentTempLabel.text = [NSString stringWithFormat:@"%d", weather.currentTempF];
	// today's forecast	
		[self.highTempDay1Label setText:[NSString stringWithFormat:@"%d°", weather.highTemp]];
		[self.lowTempDay1Label setText:[NSString stringWithFormat:@"%d°", weather.lowTemp]];
	// day 2 forecast
		[self.lowTempDay2Label setText:[NSString stringWithFormat:@"%d°", weather.lowTempDay2]];
		[self.highTempDay2Label setText:[NSString stringWithFormat:@"%d°", weather.highTempDay2]];
	// day 3 forecast
		[self.lowTempDay3Label setText:[NSString stringWithFormat:@"%d°", weather.lowTempDay3]];
		[self.highTempDay3Label setText:[NSString stringWithFormat:@"%d°", weather.highTempDay3]];
	// day 4 forecast
		[self.lowTempDay4Label setText:[NSString stringWithFormat:@"%d°", weather.lowTempDay4]];
		[self.highTempDay4Label setText:[NSString stringWithFormat:@"%d°", weather.highTempDay4]];
	} else {
	// today's forecast	
		self.currentTempLabel.text = [NSString stringWithFormat:@"%d", weather.currentTempC];
		[self.highTempDay1Label setText:[NSString stringWithFormat:@"%3.0f°", ((weather.highTemp - 32.0)/1.8)]];
		[self.lowTempDay1Label setText:[NSString stringWithFormat:@"%3.0f°", ((weather.lowTemp - 32.0)/1.8)]];
	// day 2 forecast
		[self.lowTempDay2Label setText:[NSString stringWithFormat:@"%3.0f°", ((weather.lowTempDay2 - 32.0)/1.8)]];
		[self.highTempDay2Label setText:[NSString stringWithFormat:@"%3.0f°", ((weather.highTempDay2 - 32.0)/1.8)]];
	// day 3 forecast
		[self.lowTempDay3Label setText:[NSString stringWithFormat:@"%3.0f°", ((weather.lowTempDay3 - 32.0)/1.8)]];
		[self.highTempDay3Label setText:[NSString stringWithFormat:@"%3.0f°", ((weather.highTempDay3 - 32.0)/1.8)]];
	// day 4 forecast
		[self.lowTempDay4Label setText:[NSString stringWithFormat:@"%3.0f°", ((weather.lowTempDay4 - 32.0)/1.8)]];
		[self.highTempDay4Label setText:[NSString stringWithFormat:@"%3.0f°", ((weather.highTempDay4 - 32.0)/1.8)]];
	}
	// current conditions
    [self.conditionsLabel setText:weather.condition];
    [self.cityLabel setText:weather.location];
	[self.currentDateTimeLabel setText:weather.currentDateTime];
    [self.windLabel setText:weather.wind];
    [self.humidityLabel setText:weather.humidity];
	// forecast conditions
	[self.conditionsDay1Label setText:weather.conditionDay1];
	[self.conditionsDay2Label setText:weather.conditionDay2];
	[self.conditionsDay3Label setText:weather.conditionDay3];
	[self.conditionsDay4Label setText:weather.conditionDay4];
	[self.day1Label setText:weather.day1OfWeek];
	[self.day2Label setText:weather.day2OfWeek];
	[self.day3Label setText:weather.day3OfWeek];
	[self.day4Label setText:weather.day4OfWeek];

    [weather release];
}

- (void)hourTimer	//Starts a timer which triggers a weather update (showWeatherFor) every hour
{
	
	hourTicker = [NSTimer scheduledTimerWithTimeInterval:3600.0 target:self selector:@selector(updateWeather)
											  userInfo:nil repeats:YES];
}

- (void)updateWeather
{
	NSLog(@"Trying to update the weather report");
	[self performSelectorInBackground:@selector(showWeatherFor:) withObject:currentZip];

}

- (IBAction)switchTempUnits:(UIButton *)sender
{
	NSLog(@"Changing temperature units");
	if (displayF) {
		displayF = NO;
		tempUnitsButton.selected = NO; 
	} else {
		displayF = YES;
		tempUnitsButton.selected = YES; 
	}
	[self performSelectorInBackground:@selector(showWeatherFor:) withObject:currentZip];
}


#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	NSLog(@"latitude is %3.4f", newLocation.coordinate.latitude);
	NSLog(@"longitude is %3.4f", newLocation.coordinate.longitude);
	
	// updates myLocation
	self.myLocation = newLocation;
	self.latitudeLabel.text = [NSString stringWithFormat:@"%3.4f", newLocation.coordinate.latitude];
	self.longitudeLabel.text = [NSString stringWithFormat:@"%3.4f", newLocation.coordinate.longitude];

	// Geocode request
	// This should only be sent once, otherwise the network can return error #4 - Placemark not found
	MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
	geocoder.delegate = self;
	[geocoder start];
	
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region
			  withError:(NSError *)error
{
	NSLog(@"updating location FAILED");
}

/**
 Return a location manager -- create one if necessary. Called from viewDidLoad
 */
- (CLLocationManager *)locationManager {
	
    if (locationManager != nil) {
		return locationManager;
	}
	
	self.locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	[locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
	NSLog(@"location manager --> %@", locationManager);
	return locationManager;
}


#pragma mark MKReverseGeocoder Delegate Methods
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	NSLog(@"Performing reverse geocode operation\n");
	currentZip = [placemark.addressDictionary objectForKey:@"ZIP"];
    [self performSelectorInBackground:@selector(showWeatherFor:) withObject:currentZip];
    [geocoder release];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{    
    NSLog(@"reverseGeocoder:%@ didFailWithError:%@", geocoder, error);
    [geocoder release];
}

#pragma mark UIApplication memory methods

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	[myLocation release];
	[locationManager release];
	[currentDateTimeLabel release];
	[currentZip release];
	[windLabel release];
	[humidityLabel release];

	[day1Label release];
	[lowTempDay1Label release];
	[highTempDay1Label release];
	[conditionsDay1Label release];
	[day2Label release];
	[lowTempDay2Label release];
	[highTempDay2Label release];
	[conditionsDay2Label release];
	[day3Label release];
	[lowTempDay3Label release];
	[highTempDay3Label release];
	[conditionsDay3Label release];
	[day4Label release];
	[lowTempDay4Label release];
	[highTempDay4Label release];
	[conditionsDay4Label release];
	
	[conditionsImageDay1 release];
	[conditionsImageViewDay1 release];
	[conditionsImageDay2 release];
	[conditionsImageViewDay2 release];
	[conditionsImageDay3 release];
	[conditionsImageViewDay3 release];
	[conditionsImageDay4 release];
	[conditionsImageViewDay4 release];
	[tempUnitsButton release];
	
	//testing to see if this is whats causing freeze when i push f/c button, seems to work
//	[displayF release];
	
    [super dealloc];
}

@end
