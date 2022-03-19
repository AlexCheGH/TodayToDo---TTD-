//
//  NetworkManager.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 2/9/22.
//

import Foundation
import UIKit

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


//MARK: - Weather data request
class WeatherRequest {
    
    //Get your key at https://openweathermap.org/api -> Current weather data.
    private static var apiKey: String {
      get {
        // 1
        guard let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist") else {
          fatalError("Couldn't find file 'ApiKeys.plist'.")
        }
        // 2
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "weatherKey") as? String else {
          fatalError("Couldn't find key 'weatherKey' in 'ApiKeys.plist'.")
        }
        return value
      }
    }
    
    let url: URL

    init(coordinates: (Double,Double)) {
        self.url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.0)&lon=\(coordinates.1)&appid=\(WeatherRequest.apiKey)")!
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

//MARK: Request for image
//displays the image for the current weather conditions
class WeatherImageRequest {
    let url: URL
    
    init(iconID: String) {
        self.url = URL(string: "https://openweathermap.org/img/wn/\(iconID)@2x.png")!
    }
}

extension WeatherImageRequest: NetworkRequest {
    typealias ModelType = UIImage
    
    func decode(_ data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    
    func execute(withCompletion completion: @escaping (UIImage?) -> Void) {
        makeRequest(url: url, completion: completion)
    }
}
