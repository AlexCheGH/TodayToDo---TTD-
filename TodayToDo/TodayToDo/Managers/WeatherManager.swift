//
//  WeatherManager.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 2/9/22.
//

import Foundation
import Combine

class WeatherManager: ObservableObject {
    
    private let weatherRequest: WeatherRequest
    
    @Published private var weather: Weather?
    @Published private var userPreference: WeatherPreference?
    
    init(coordinates: (Double, Double)) {
        self.weatherRequest = WeatherRequest(coordinates: coordinates)
        self.weatherRequest.execute { weather in
            self.weather = weather
        }
        //Won't be nil. The default parameter is .fahrenheit. Safe to force unwrap
        self.userPreference = TodayTodoUserDefaults().userWeatherFormatPreference
    }
    
    var currentWeather: AnyPublisher <String?, Never> {
        return Publishers.CombineLatest($weather, $userPreference)
            .map{weather, preference in
                let temperature = weather?.main?.temp
                guard let temperature = temperature else { return nil }
                return self.processTemperature(of: preference!, from: temperature)
            }
            .eraseToAnyPublisher()
    }
    
    //Formats raw data in Kelvins to F or C
    private func processTemperature(of type: WeatherPreference, from value: Double) -> String {
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
