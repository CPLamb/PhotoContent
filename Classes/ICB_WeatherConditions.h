//
//  ICB_WeatherConditions.h
//  LocalWeather
//
//  Created by Matt Tuzzolo on 9/28/10.
//  Copyright 2010 iCodeBlog. All rights reserved.
//

@interface ICB_WeatherConditions : NSObject {
    NSString *condition, *location;
	NSString *humidity, *wind;
	NSString *day1OfWeek, *conditionDay1;
	NSString *day2OfWeek, *conditionDay2;
	NSString *day3OfWeek, *conditionDay3;
	NSString *day4OfWeek, *conditionDay4;
    NSURL *conditionImageURL;
    NSInteger currentTempF, currentTempC, lowTemp, highTemp;
	NSInteger lowTempDay2, highTempDay2;
	NSInteger lowTempDay3, highTempDay3;
	NSInteger lowTempDay4, highTempDay4;
	NSString *currentDateTime;
}

@property (nonatomic,retain) NSString *condition, *conditionDay1, *conditionDay2, *conditionDay3, *conditionDay4;
@property (nonatomic,retain) NSString *day1OfWeek, *day2OfWeek, *day3OfWeek, *day4OfWeek;
@property (nonatomic,retain) NSString *humidity, *wind;

@property (nonatomic,retain) NSURL *conditionImageURL;
@property (nonatomic) NSInteger currentTempF, currentTempC, lowTemp, highTemp;
@property (nonatomic) NSInteger lowTempDay2, highTempDay2;
@property (nonatomic) NSInteger lowTempDay3, highTempDay3;
@property (nonatomic) NSInteger lowTempDay4, highTempDay4;
@property (nonatomic,retain) NSString *currentDateTime, *location;

- (ICB_WeatherConditions *)initWithQuery:(NSString *)query;
@end