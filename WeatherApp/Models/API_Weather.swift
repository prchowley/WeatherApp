//
//  API_Weather.swift
//  WeatherApp
//
//  Created by Priyabrata Chowley on 13/10/19.
//  Copyright © 2019 Priyabrata Chowley. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - API_Weather
struct API_Weather: Codable {
    let coord: API_Coord?
    let weather: [API_WeatherElement]?
    let base: String?
    let main: API_Main?
    let wind: API_Wind?
    let clouds: API_Clouds?
    let dt: Int?
    let sys: API_Sys?
    let id: Int?
    let name: String?
    let cod: Int?

    enum CodingKeys: String, CodingKey {
        case coord = "coord"
        case weather = "weather"
        case base = "base"
        case main = "main"
        case wind = "wind"
        case clouds = "clouds"
        case dt = "dt"
        case sys = "sys"
        case id = "id"
        case name = "name"
        case cod = "cod"
    }
}

// MARK: - API_Clouds
struct API_Clouds: Codable {
    let all: Int?

    enum CodingKeys: String, CodingKey {
        case all = "all"
    }
}

// MARK: - API_Coord
struct API_Coord: Codable {
    let lon: Double?
    let lat: Double?

    enum CodingKeys: String, CodingKey {
        case lon = "lon"
        case lat = "lat"
    }
}

// MARK: - API_Main
struct API_Main: Codable {
    let temp: Double?
    let pressure: Double?
    let humidity: Int?
    let tempMin: Double?
    let tempMax: Double?
    let seaLevel: Double?
    let grndLevel: Double?

    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case pressure = "pressure"
        case humidity = "humidity"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - API_Sys
struct API_Sys: Codable {
    let message: Double?
    let country: String?
    let sunrise: Int?
    let sunset: Int?

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case country = "country"
        case sunrise = "sunrise"
        case sunset = "sunset"
    }
}

// MARK: - API_WeatherElement
struct API_WeatherElement: Codable {
    let id: Int?
    let main: String?
    let weatherDescription: String?
    let icon: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case main = "main"
        case weatherDescription = "description"
        case icon = "icon"
    }
}

// MARK: - API_Wind
struct API_Wind: Codable {
    let speed: Double?
    let deg: Int?

    enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case deg = "deg"
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - Alamofire response handlers
extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }

            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }

            return Result { try newJSONDecoder().decode(T.self, from: data) }
        }
    }

    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }

    @discardableResult
    func responseAPI_Weather(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<API_Weather>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
