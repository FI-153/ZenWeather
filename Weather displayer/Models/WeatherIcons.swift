//
//  WeatherDataIcons.swift
//  Weather displayer
//
//  Created by Federico Imberti on 01/02/22.
//

import Foundation

struct WeatherIcons{
    ///Maps weather conditions to their assigned SF Symbol
	static let icons: [String : String] = [
		"snow"				    : "snow",
		"rain"				    : "cloud.rain.fill",
		"fog"				    : "cloud.fog.fill",
		"wind"				    : "wind",
		"cloudy"				: "cloud.fill",
		"partly-cloudy-day"		: "cloud.sun.fill",
		"partly-cloudy-night"	: "cloud.moon.fill",
		"clear-day"			    : "sun.max.fill",
		"clear-night"			: "moon.fill"
	]
}
