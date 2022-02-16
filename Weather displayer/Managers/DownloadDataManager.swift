//
//  DownloadDataManager.swift
//  Weather displayer
//
//  Created by Federico Imberti on 01/02/22.
//

import UIKit
import Combine

class DownloadDataManager {
	
	///Publishes all downloaded locations
	@Published var downloadedData:WeatherData = WeatherData.mockData
	
	///Saves the previous downloaded weather data
	var previouslyDownloadedData:WeatherData?
	
	///Will be false is the downaloader has finished downloading data
	@Published var isLoading:Bool = true
	
	///Singleton instance of the class
	static let shared = DownloadDataManager()
	public init(isForTesting:Bool = false){
		
		if !isForTesting {
			do{
				try downloadWeatherData(for: "Cazzano sant'Andrea")
			}catch let error {
				isLoading = false
				print(error)
			}
		}
		
	}
	
	private var cancellables = Set<AnyCancellable>()
	
	///Weather data is downloaded for a specifiec location
	func downloadWeatherData(for location:String) throws{
		
		do {
			isLoading = true
			
			let url = try createUrl(for: location)

			downloadData(for: url)

		} catch let error{
			throw error
		}
		
	}
	
	///Handles the output from the downloader
	private func handleOutput(output:URLSession.DataTaskPublisher.Output) throws -> Data {
		guard
			let response = output.response as? HTTPURLResponse,
			response.statusCode >= 200 && response.statusCode < 300 else {
				throw URLError(.badServerResponse)
			}
		return output.data
	}
	
	///Creates the URL version of the given string
	public func createUrl(for location: String) throws -> URL{
		
		guard let url = URL(string: composeUrlRequest(for: location)) else {
			throw URLError(.badURL)
		}

		return url
	}
	
	///Composes an URL request to conform to the API format
	public func composeUrlRequest(for location: String) -> String {
		
		let before 				= "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/"
		let after 				= "/next7days?unitGroup=metric&include=days&key=AZSUM3BTUUFQD2FRU4T8ZR6MQ&contentType=json"
		let formattedLocation 	= location.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .illegalCharacters).filter{ !" \n\t\r".contains($0) }
		
		return before + formattedLocation + after
	}
	
	///Downloads the data at the given URL then saves it
	public func downloadData(for url: URL) {
		
		URLSession.shared.dataTaskPublisher(for: url)
			.receive(on: DispatchQueue.main)
			.tryMap(handleOutput)
			.decode(type: WeatherData.self, decoder: JSONDecoder())
			.replaceError(with: previouslyDownloadedData ?? WeatherData.mockData)
			.sink { [weak self] receivedWeather in
				
				guard let self = self else { return }
				
				self.downloadedData = 			receivedWeather
				self.previouslyDownloadedData = 	self.downloadedData
				self.isLoading = 				false
			}
			.store(in: &cancellables)
		
	}
	
}
