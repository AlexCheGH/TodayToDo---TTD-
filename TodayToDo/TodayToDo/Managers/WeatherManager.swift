//
//  WeatherManager.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 2/9/22.
//

import Foundation
import Combine
import UIKit


class WeatherManager: ObservableObject {
    private var weatherRequest: WeatherRequest?
    private var weatherIconRequest: WeatherImageRequest?
    
    @Published private var weather: Weather?
    @Published private var userPreference: WeatherPreference?
    @Published private var weatherIconImage: UIImage?
    @Published private var coodrinates: (Double, Double)?
    
    init() {
        //Won't be nil. The default parameter is .fahrenheit. Safe to force unwrap
        self.userPreference = TodayTodoUserDefaults().userWeatherFormatPreference
    }
    
    var currentWeather: AnyPublisher <String?, Never> {
        return Publishers.CombineLatest3($weather, $userPreference, $coodrinates)
            .map{weather, preference, _ in
                let temperature = weather?.main?.temp
                guard let temperature = temperature else { return nil }
                return self.processedTemperature(of: preference!, from: temperature)
            }
            .eraseToAnyPublisher()
    }
    
    var currentWeatherImage: AnyPublisher <UIImage?, Never> {
        return $weatherIconImage.map{
            return $0
        }.eraseToAnyPublisher()
    }
    
    
    //MARK: - Network calls
    func loadWeather(coordinates: (Double, Double)) {
        //Start the request to get weather data
        self.weatherRequest = WeatherRequest(coordinates: coordinates)
        self.weatherRequest?.execute { weather in
            self.weather = weather
            
            //Once data is received, we can initiate a request to get an image
            if let icon = weather?.weather?.first?.icon {
                self.loadImage(icon: icon)
            }
        }
    }
    
    //Loads the weather status icon. Weather-Model provides us the image name
    private func loadImage(icon: String) {
        self.weatherIconRequest = WeatherImageRequest(iconID: icon)
        self.weatherIconRequest?.execute(withCompletion: { image in
            self.weatherIconImage = image
        })
    }
    
    //MARK: - Data formatters
    //Formats raw data in Kelvins to F or C
    private func processedTemperature(of type: WeatherPreference, from value: Double) -> String {
        var temperature = 0.0
        let kelvinConst = 273.15
        
        switch type {
        case .fahrenheit:
            temperature = (value - kelvinConst) * 1.8 + 32
        case .celsius:
            temperature = value - kelvinConst
        }
        return String(format: "%.1f", temperature) + "º"
    }
}
