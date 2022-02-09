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
    
    init(coordinates: (Double, Double)) {
        self.weatherRequest = WeatherRequest(coordinates: coordinates)
        self.weatherRequest.execute { weather in
            self.weather = weather
        }
    }
    
    var currentWeather: AnyPublisher <String?, Never> {
        return Publishers.CombineLatest($weather, $weather)//need to re-write
            .map{weather, _ in
                
                let some = weather?.main?.temp ?? 0.0
                
                return String(format: "%f", some)
            }
            .eraseToAnyPublisher()
    }
}
