//
//  ICB_WeatherConditions.m
//  LocalWeather
//
//  Created by Matt Tuzzolo on 9/28/10.
//  Copyright 2010 iCodeBlog. All rights reserved.
//
/*	To make TouchXML work do the following;
		 Go to “Project -> Edit project settings”
		 Activate “Build” tab
		 Search for “Header search paths” setting and add /usr/include/libxml2 value to it
		 Search for “Other linker flags” setting and add -lxml2 value
	Google Weather XML URL --->  http://www.google.com/ig/api?weather=95062
*/ 

#import "ICB_WeatherConditions.h"
#import "TouchXML.h"

@implementation ICB_WeatherConditions

@synthesize currentTempF, currentTempC, condition, conditionImageURL, location, currentDateTime;
@synthesize humidity, wind;
@synthesize day1OfWeek, conditionDay1, lowTemp, highTemp;
@synthesize day2OfWeek, conditionDay2, lowTempDay2, highTempDay2;
@synthesize day3OfWeek, conditionDay3, lowTempDay3, highTempDay3;
@synthesize day4OfWeek, conditionDay4, lowTempDay4, highTempDay4;

- (ICB_WeatherConditions *)initWithQuery:(NSString *)query
{
    if (self = [super init])
    {
		NSLog(@"performing query for weather data");
        CXMLDocument *parser = [[[CXMLDocument alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.google.com/ig/api?weather=%@", query]] options:0 error:nil] autorelease];
     //current conditions   
        condition         = [[[[[parser nodesForXPath:@"/xml_api_reply/weather/current_conditions/condition" error:nil] objectAtIndex:0] attributeForName:@"data"] stringValue] retain];        
        location          = [[[[[parser nodesForXPath:@"/xml_api_reply/weather/forecast_information/city" error:nil] objectAtIndex:0] attributeForName:@"data"] stringValue] retain];
		currentDateTime	  = [[[[[parser nodesForXPath:@"/xml_api_reply/weather/forecast_information/current_date_time" error:nil] objectAtIndex:0] attributeForName:@"data"] stringValue] retain];
        currentTempF       = [[[[[parser nodesForXPath:@"/xml_api_reply/weather/current_conditions/temp_f" error:nil] objectAtIndex:0] attributeForName:@"data"] stringValue] integerValue];
        currentTempC       = [[[[[parser nodesForXPath:@"/xml_api_reply/weather/current_conditions/temp_c" error:nil] objectAtIndex:0] attributeForName:@"data"] stringValue] integerValue];
        humidity         = [[[[[parser nodesForXPath:@"/xml_api_reply/weather/current_conditions/humidity" error:nil] objectAtIndex:0] attributeForName:@"data"] stringValue] retain];        
        wind			= [[[[[parser nodesForXPath:@"/xml_api_reply/weather/current_conditions/wind_condition" error:nil] objectAtIndex:0] attributeForName:@"data"] stringValue] retain];        
	//forecast today
		day1OfWeek         = [[[[[parser nodesForXPath:@"/xml_api_reply/weather/forecast_conditions[1]/day_of_week" error:nil] objectAtIndex:0] attributeForName:@"data"] stringValue] retain];        
        lowTemp           = [[[[[parser nodesForXPath:@"/xml_api_reply/weather/forecast_conditions[1]/low" error:nil] objectAtIndex:0] attributeForName:@"data"] stringValue] integerValue];
        highTemp          = [[[[[parser nodesForXPath:@"/xml_api_reply/weather/forecast_conditions[1]/high" error:nil] objectAtIndex:0] attributeForName:@"data"] stringValue] integerValue];
        conditionDay1         = [[[[[parser nodesForXPath:@"/xml_api_reply/weather/forecast_conditions[1]/condition" error:nil] objectAtIndex:0] attributeForName:@"data"] stringValue] retain];        
	// 2nd day forecast
		day2OfWeek         = [[[[[parser nodesForXPath:@"/xml_api_reply/weather/forecast_conditions[2]/day_of_week" error:nil] objectAtIndex:0] attributeForName:@"data"] stringValue] retain];        
        lowTempDay2           = [[[[[parser nodesForXPath:@"/xml_api_reply/weather/forecast_conditions[2]/low" error:nil] objectAtIndex:0] attributeForName:@"data"] stringValue] integerValue];
        highTempDay2          = [[[[[parser nodesForXPath:@"/xml_api_reply/weather/forecast_conditions[2]/high" error:nil] objectAtIndex:0] attributeForName:@"data"] stringValue] integerValue];
        conditionDay2         = [[[[[parser nodesForXPath:@"/xml_api_reply/weather/forecast_conditions[2]/condition" error:nil] objectAtIndex:0] attributeForName:@"data"] stringValue] retain];        
	// 3rd day forecast
		day3OfWeek         = [[[[[parser nodesForXPath:@"/xml_api_reply/weather/forecast_conditions[3]/day_of_week" error:nil] objectAtIndex:0] attributeForName:@"data"] stringValue] retain];        
        lowTempDay3           = [[[[[parser nodesForXPath:@"/xml_api_reply/weather/forecast_conditions[3]/low" error:nil] objectAtIndex:0] attributeForName:@"data"] stringValue] integerValue];
        highTempDay3          = [[[[[parser nodesForXPath:@"/xml_api_reply/weather/forecast_conditions[3]/high" error:nil] objectAtIndex:0] attributeForName:@"data"] stringValue] integerValue];
        conditionDay3         = [[[[[parser nodesForXPath:@"/xml_api_reply/weather/forecast_conditions[3]/condition" error:nil] objectAtIndex:0] attributeForName:@"data"] stringValue] retain];        
	// 4th day forecast
		day4OfWeek         = [[[[[parser nodesForXPath:@"/xml_api_reply/weather/forecast_conditions[4]/day_of_week" error:nil] objectAtIndex:0] attributeForName:@"data"] stringValue] retain];        
        lowTempDay4           = [[[[[parser nodesForXPath:@"/xml_api_reply/weather/forecast_conditions[4]/low" error:nil] objectAtIndex:0] attributeForName:@"data"] stringValue] integerValue];
        highTempDay4          = [[[[[parser nodesForXPath:@"/xml_api_reply/weather/forecast_conditions[4]/high" error:nil] objectAtIndex:0] attributeForName:@"data"] stringValue] integerValue];
        conditionDay4         = [[[[[parser nodesForXPath:@"/xml_api_reply/weather/forecast_conditions[4]/condition" error:nil] objectAtIndex:0] attributeForName:@"data"] stringValue] retain];        
		
        conditionImageURL = [[NSURL URLWithString:[NSString stringWithFormat:@"http://www.google.com%@", [[[[parser nodesForXPath:@"/xml_api_reply/weather/current_conditions/icon" error:nil] objectAtIndex:0] attributeForName:@"data"] stringValue]]] retain];
    }

    return self;
}

- (void)dealloc {    
    [conditionImageURL release];
    [condition release];
	[humidity release];
	[wind release];
	[conditionDay2 release];
	[conditionDay3 release];
	[conditionDay4 release];
	[day1OfWeek release];
	[day2OfWeek release];
	[day3OfWeek release];
	[day4OfWeek release];
    [location release];
	[currentDateTime release];
    [super dealloc];
}

@end
