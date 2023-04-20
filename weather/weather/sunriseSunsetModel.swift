//
//  File.swift
//  weather
//
//  Created by 薛博安 on 2023/4/11.
//

import Foundation

struct Sun: Codable {
    var records: SunRecords
}

struct SunRecords: Codable {
    var locations: SunLoctions
}

struct SunLoctions: Codable {
    var location: [SunLocation]
}

struct SunLocation: Codable {
    var time: [SunTime]
    var CountyName: String
}

struct SunTime: Codable {
    var Date: String
    var SunRiseTime: String
    var SunSetTime: String
}
