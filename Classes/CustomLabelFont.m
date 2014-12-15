//
//  LabelOptima.m
//  CustomFontTest
//
//  Created by Adon on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomLabelFont.h"


@implementation CustomLabelFont

- (id)initWithCoder:(NSCoder *)decoder {
	
	if (self = [super initWithCoder: decoder]) {
		[self setFont: [UIFont fontWithName: @"zanders" size: self.font.pointSize]];
	}
	
	return self;
}


@end