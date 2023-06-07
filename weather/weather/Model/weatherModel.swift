//
//  model.swift
//  weather
//
//  Created by 薛博安 on 2023/3/22.
//

import UIKit
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

enum WeatherParameters: String {
    ///天氣現象
    case weatherPhenomenon = "Wx"
    ///降雨率
    case chanceOfRain = "PoP"
    ///最低溫度
    case minTemperature = "MinT"
    ///舒適度
    case Comfort = "CI"
    ///最高溫度
    case maxTemperature = "MaxT"
}

struct WeatherParam {
    var minT = ""
    var maxT = ""
    var ci  = ""
    var wx = ""
    var image: UIImage {
        return getImageName(wx: wx)
    }
    var temp: String {
        return "\(minT)~\(maxT)"
    }
    
    private func getImageName(wx: String) -> UIImage {
        if wx.contains("雨") {
            if wx.contains("晴") {
                return UIImage(systemName: "cloud.sun.rain")!
            } else if wx.contains("雷") {
                return UIImage(systemName: "cloud.bolt.rain")!
            } else {
                return UIImage(systemName: "cloud.heavyrain")!
            }
        } else if wx.contains("晴") {
            if wx.contains("雲") {
                return UIImage(systemName: "cloud.sun")!
            } else {
                return UIImage(systemName: "sun.max")!
            }
        } else if wx.contains("雪") {
            return UIImage(systemName: "cloud.snow")!
        } else {
            return UIImage(systemName: "cloud")!
        }
    }
}

