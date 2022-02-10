//
//  Weather.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 1/9/22.
//

import Foundation

class Weather: Codable {
    let main: Main?
    let name: String?
    let weather: [WeatherElement]?
    /*let visibility: Int?
    let base: String?
    let coord: Coord?
    let wind: Wind?
    let clouds: Clouds?
    let sys: Sys?
    let dt: Int?
    let timezone, id: Int?
    let cod: Int?
    */

    init(main: Main?, name: String?, weather: [WeatherElement]? /*coord: Coord?, base: String?,  visibility: Int?, wind: Wind?, clouds: Clouds?, dt: Int?, sys: Sys?, timezone: Int?, id: Int?, cod: Int?*/) {
        self.main = main
        self.name = name
        self.weather = weather
        /*self.coord = coord
        self.base = base
        self.visibility = visibility
        self.wind = wind
        self.clouds = clouds
        self.dt = dt
        self.sys = sys
        self.timezone = timezone
        self.id = id
        self.cod = cod
         */
    }
}

// MARK: - Clouds
/* class Clouds: Codable {
    let all: Int?

    init(all: Int?) {
        self.all = all
    }
} */

// MARK: - Coord
/*class Coord: Codable {
    let lon, lat: Double?

    init(lon: Double?, lat: Double?) {
        self.lon = lon
        self.lat = lat
    }
} */

// MARK: - Main
class Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }

    init(temp: Double?, feelsLike: Double?, tempMin: Double?, tempMax: Double?, pressure: Int?, humidity: Int?) {
        self.temp = temp
        self.feelsLike = feelsLike
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.pressure = pressure
        self.humidity = humidity
    }
}

// MARK: - Sys
/* class Sys: Codable {
    let type, id: Int?
    let message: Double?
    let country: String?
    let sunrise, sunset: Int?

    init(type: Int?, id: Int?, message: Double?, country: String?, sunrise: Int?, sunset: Int?) {
        self.type = type
        self.id = id
        self.message = message
        self.country = country
        self.sunrise = sunrise
        self.sunset = sunset
    }
} */

// MARK: - WeatherElement
class WeatherElement: Codable {
    let id: Int?
    let main, weatherDescription, icon: String?

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }

    init(id: Int?, main: String?, weatherDescription: String?, icon: String?) {
        self.id = id
        self.main = main
        self.weatherDescription = weatherDescription
        self.icon = icon
    }
}

// MARK: - Wind
/* class Wind: Codable {
    let speed: Double?
    let deg: Int?

    init(speed: Double?, deg: Int?) {
        self.speed = speed
        self.deg = deg
    }
} */
