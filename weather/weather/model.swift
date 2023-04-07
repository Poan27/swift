//
//  model.swift
//  weather
//
//  Created by 薛博安 on 2023/3/22.
//

import Foundation
//weather 是保留字
struct Weather: Codable {
    var records: Records
}

struct Records: Codable {
    var location: [Location]
}

struct Location: Codable {
    var locationName: String
    var weatherElement: [WeatherElement]
}

struct WeatherElement: Codable {
    var elementName: String
    var time: [Time]
}

struct Time: Codable {
    var startTime: String
    var endTime: String
    var parameter: Parameter
}

struct Parameter: Codable {
///參數結果
    var parameterName: String
/// 參數結果單位
    var parameterUnit: String?
}


