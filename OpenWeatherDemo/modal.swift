//
//  modal.swift
//  OpenWeatherDemo
//
//  Created by user on 1/4/19.
//  Copyright © 2019 appguru. All rights reserved.
//

struct WeatherList: Decodable {
    let list: [list]
    let city: CityName
}

struct list: Decodable {
    let weather: [weather]
    let dt_txt: String?
    let main: mainInfo
}

struct weather: Decodable {
    let description: String?
    let id: Int?
}

struct mainInfo: Decodable {
    let temp: Float?
    let temp_min: Float?
    let temp_max: Float?
    let humidity: Float?
}

struct CityName: Decodable {
    let name: String?
}

