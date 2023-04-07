//
//  ViewController2.swift
//  weather
//
//  Created by 薛博安 on 2023/4/7.
//

import UIKit

class ViewController2: UIViewController {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherPhenomenon: UILabel!
    @IBOutlet weak var changeLocation: UIButton!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var pOP: UILabel!
    
    let location = ["臺中市","彰化縣","嘉義縣","嘉義市","雲林縣","臺南市","高雄市","屏東縣","台東縣","花蓮縣","宜蘭縣","基隆市","臺北市"," 新北市","桃園市","新竹縣","新竹市","苗栗縣","南投縣","連江縣","金門縣","澎湖縣"]
    
    var timeData = [String]()
    var pickerSelectLocation = "新北市"
    var pickerSelectTime = 0
    let locationPickerView = UIPickerView(frame: CGRect(x: 0,y: 50, width: 280, height: 150))
    let timePickerView = UIPickerView(frame: CGRect(x: 0,y: 50, width: 280, height: 150))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationPickerView.delegate = self
        locationPickerView.dataSource = self
        timePickerView.delegate = self
        timePickerView.dataSource = self
        
        loadApiData(locationName: pickerSelectLocation, time: pickerSelectTime)
    }
    
//    @IBAction func changeLocationAndTime(_ sender: UIButton) {
//        showLocationView()
//    }
    
    func loadApiData (locationName: String, time: Int) {
        let url =  "https://opendata.cwb.gov.tw/api/v1/rest/datastore/F-C0032-001?Authorization=CWB-FCD3F473-1F08-455C-9FF0-11AE228B011E&format=JSON&locationName=\(locationName)&time=\(time)"
                let newUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!   // 解析中文
                var request = URLRequest(url: URL(string: newUrl)!,timeoutInterval: Double.infinity)
                request.httpMethod = "GET"
                let AQI = URLSession.shared.dataTask(with: request) { data, response, error in
                    let decoder = JSONDecoder()
                    guard let data = data else {
                        print("error")
                        self.showErrorAlert(title: "錯誤訊息", message:"查無資料集")
                        return
                    }
                    do {
                        let weather = try decoder.decode(Weather.self, from: data)
                        print(weather)
        
                        DispatchQueue.main.sync {
                            let location = weather.records.location[0]
                            let elements = location.weatherElement
    }
//    func loadAPI(locationName: String ,time: Int) {
//
//        let url =  "https://opendata.cwb.gov.tw/api/v1/rest/datastore/F-C0032-001?Authorization=CWB-FCD3F473-1F08-455C-9FF0-11AE228B011E&format=JSON&locationName=\(locationName)&time=\(time)"
//        let newUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!   // 解析中文
//        var request = URLRequest(url: URL(string: newUrl)!,timeoutInterval: Double.infinity)
//        request.httpMethod = "GET"
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            let decoder = JSONDecoder()
//            guard let data = data else {
//                print("error")
//                self.showErrorAlert(title: "錯誤訊息", message:"查無資料集")
//                return
//            }
//            do {
//                let weather = try decoder.decode(Weather.self, from: data)
//                print(weather)
//
//                DispatchQueue.main.sync {
//                    let location = weather.records.location[0]
//                    let elements = location.weatherElement
//                    for element in elements {
//                        if let target = weatherParameters(rawValue: element.elementName) {
//                            switch target {
//                            case .weatherPhenomenon:
//                                self.wxLabel.text = element.time[time].parameter.parameterName
//                            case .chanceOfRain:
//                                self.poPLabel.text = element.time[time].parameter.parameterName + "%"
//                            case .minTemperature:
//                                self.minTLabel.text = element.time[time].parameter.parameterName + "°" + element.time[time].parameter.parameterUnit!
//                            case .Comfort:
//                                self.cILabel.text = element.time[time].parameter.parameterName
//                            case .maxTemperature:
//                                self.maxTLabel.text = element.time[time].parameter.parameterName + "°" + element.time[time].parameter.parameterUnit!
//                            }
//                        } else {
//                            print(" no weather parameters ")
//                        }
//                    }
//                    self.selectButton.setTitle(location.locationName, for: .normal)
//                    //                    self.timeLabel.text = location.weatherElement[0].time[time].startTime + " ～ " + location.weatherElement[0].time[time].endTime //預計刪掉？
//                    for time in location.weatherElement[0].time {
//                        self.timeData.append(time.startTime)
//                    }
//
//                    self.selectIconImage()
//                }
//            } catch {
//                self.showErrorAlert(title: "錯誤訊息", message: "Error decoding Weather object:\(error.localizedDescription)")
//            }
//        }
//        task.resume()
//    }
    
    func selectIconImage () {
        //TODO: wxLabel.text
        if let wxText: String = wxLabel.text {
            if wxText.contains("雨") {
                if wxText.contains("晴") {
                    iconImage.image = UIImage(named: "rain_cloud_sun")
                } else if wxText.contains("雷") {
                    iconImage.image = UIImage(named: "storm")
                } else {
                    iconImage.image = UIImage(named: "rain")
                }
                
            } else if wxText.contains("晴") {
                if wxText.contains("雲") {
                    iconImage.image = UIImage(named: "cloudy")
                } else {
                    iconImage.image = UIImage(named: "sun")
                }
            } else if wxText.contains("雪") {
                iconImage.image = UIImage(named: "snow")
            } else {
                iconImage.image = UIImage(named: "clouds")
            }
            
        }
        
    }

    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    func showLocationView() {
        let alertView = UIAlertController(title: "選擇地點", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消",style: .cancel,handler: nil)
        let okAction = UIAlertAction(title: "確認",style: .default,handler: { _ in self.loadAPI(locationName: self.pickerSelectLocation, time: self.pickerSelectTime)
            self.showTimeView()
        }
        )
        //TODO: change alert height to fit pickerView
        
        alertView.view.addSubview(locationPickerView)
        alertView.addAction(cancelAction)
        alertView.addAction(okAction)
        present(alertView, animated: true, completion: nil)
    }
    
    func showTimeView() {
        let alertView = UIAlertController(title: "選擇時間",message: "\n\n\n\n\n\n\n\n\n",preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消",style: .cancel,handler: nil)
        let okAction = UIAlertAction(title: "確認",style: .default,handler: {_ in self.loadAPI(locationName: self.pickerSelectLocation, time: self.pickerSelectTime)})
        alertView.view.addSubview(timePickerView)
        alertView.addAction(cancelAction)
        alertView.addAction(okAction)
        present(alertView, animated: true, completion: nil)
    }
    
}

extension ViewController2: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == locationPickerView {
            return location.count
        }
        if pickerView == timePickerView {
            return timeData.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == locationPickerView {
            return location[row]
        }
        if pickerView == timePickerView {
            return timeData[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == locationPickerView {
            pickerSelectLocation = location[row]
        }
        if pickerView == timePickerView {
            pickerSelectTime = row
        }
    }
}


