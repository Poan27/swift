//
//  sunriseSunsetApi.swift
//  weather
//
//  Created by 薛博安 on 2023/5/4.
//

import Foundation

class SunriseSunsetAPI {
    
    class func loadSunriseSunsetApi(locationName: String,
                                    date: String,
                                    completionHandler: @escaping (_ day: [SunTime]?) -> Void,
                                    failedHander: @escaping(Error) -> Void) {
        let SunUrl =  "https://opendata.cwb.gov.tw/api/v1/rest/datastore/A-B0062-001?Authorization=CWB-FCD3F473-1F08-455C-9FF0-11AE228B011E&format=JSON&CountyName=\(locationName)&Date=\(date)"
        if let newSunUrl = SunUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            guard let URL = URL(string: newSunUrl) else {
                let error = NSError(domain: "loadSunriseSunsetApi", code: 0, userInfo: [NSLocalizedDescriptionKey: " Invalid URL"])
                failedHander(error)
                return
            }
            var sunRequest = URLRequest(url: URL,timeoutInterval: Double.infinity)
            sunRequest.httpMethod = "GET"
            let task2 = URLSession.shared.dataTask(with: sunRequest) { data, response, error in
                let decoder = JSONDecoder()
                guard let data = data else {
                    print("error")
                    return
                }
                do {
                    let sun = try decoder.decode(Sun.self, from: data)
                    
                    DispatchQueue.main.sync {
                        completionHandler(sun.records.locations.location.first?.time)
                    }
                } catch {
                    failedHander(error)
                }
            }
            task2.resume()
            
        }
    }
}
