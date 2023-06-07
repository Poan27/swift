//
//  WeatherAPI.swift
//  weather
//
//  Created by 薛博安 on 2023/5/4.
//

import Foundation

class WeatherAPI {
    
    class func loadWeatherApi(locationName: String,
                              completionHandler: @escaping (_ iiii: [WeatherElement]?) -> Void,
                              failedHandler: @escaping (Error) -> Void) {
        let url =  "https://opendata.cwb.gov.tw/api/v1/rest/datastore/F-C0032-001?Authorization=CWB-FCD3F473-1F08-455C-9FF0-11AE228B011E&format=JSON&locationName=\(locationName)"
        if let newUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            guard let URL = URL(string: newUrl) else {
                let error = NSError(domain: "loadWeatherApi", code: 0, userInfo: [NSLocalizedDescriptionKey: " Invalid URL"])
                failedHandler(error)
                return
            }
            var request = URLRequest(url: URL,timeoutInterval: Double.infinity)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                let decoder = JSONDecoder()
                guard let data = data else {
                    print("error")
                    return
                }
                do {
                    let weather = try decoder.decode(Weather.self, from: data)
                    DispatchQueue.main.sync {
                        completionHandler(weather.records.location.first?.weatherElement)
                    }
                } catch {
                    failedHandler(error)
                }
            }
            task.resume()
        }
    }
}
