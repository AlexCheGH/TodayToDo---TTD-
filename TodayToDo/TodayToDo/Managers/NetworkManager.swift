//
//  NetworkManager.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 2/9/22.
//

import Foundation

protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) -> ModelType?
    func execute(withCompletion completion: @escaping (ModelType?) -> Void)
}

extension NetworkRequest {
    func makeRequest(url: URL, completion: @escaping(ModelType?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let value = self.decode(data)  else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            DispatchQueue.main.async {
                completion(value)
            }
        }.resume()
    }
}

class WeatherRequest {
    private let apiKey = "d993c7d8d3f4e8de63516cc737a6c16b" //need to create a config/certificate in future
    
    let url: URL
    
    init(coordinates: (Double,Double)) {
        self.url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.0)&lon=\(coordinates.1)&appid=\(apiKey)")!
    }
}

extension WeatherRequest: NetworkRequest {
    typealias ModelType = Weather
    
    func decode(_ data: Data) -> Weather? {
        let decoder = JSONDecoder()
        let weather = try? decoder.decode(ModelType.self, from: data)
        
        return weather
    }
    
    func execute(withCompletion completion: @escaping (Weather?) -> Void) {
        makeRequest(url: url, completion: completion)
    }
}
