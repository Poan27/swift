//
//  ViewController.swift
//  weather
//
//  Created by 薛博安 on 2023/3/22.
//
// TODO: replace button

import UIKit

enum WeatherParameters: String {
    
    case weatherPhenomenon = "Wx"
    case chanceOfRain = "PoP"
    case minTemperature = "MinT"
    case Comfort = "CI"
    case maxTemperature = "MaxT"
}

class ViewController: UIViewController {
    ///天氣圖示
    @IBOutlet weak var iconImage: UIImageView!
    ///地點時間選擇
    @IBOutlet weak var selectButton: UIButton!
    /// 溫度
    @IBOutlet weak var temperatureLabel: UILabel!
    ///舒適度
    @IBOutlet weak var cILabel: UILabel!
    ///
    /// 降雨機率
    @IBOutlet weak var poPLabel: UILabel!
    ///日出
    @IBOutlet weak var sunriseLabel: UILabel!
    ///日落
    @IBOutlet weak var sunsetLabel: UILabel!

    ///scroll view No.1
    ///時間
    @IBOutlet weak var timeFirstLabel: UILabel!
    ///天氣圖示
    @IBOutlet weak var weatherIconFirstImage: UIImageView!
    ///溫度
    @IBOutlet weak var temperatureFirstLabel: UILabel!
    
    ///scroll view No.2
    ///時間
    @IBOutlet weak var timeSecondLabel: UILabel!
    ///天氣圖示
    @IBOutlet weak var weatherIconSecondImage: UIImageView!
    ///溫度
    @IBOutlet weak var temperatureSecondLabel: UILabel!
    
    ///scroll view No.3
    ///時間
    @IBOutlet weak var timeThirdLabel: UILabel!
    ///天氣圖示
    @IBOutlet weak var weatherIconThirdImage: UIImageView!
    ///溫度

    @IBOutlet weak var temperatureThirdLabel: UILabel!
    
    
    
    
    let location = ["臺中市","彰化縣","嘉義縣","嘉義市","雲林縣","臺南市","高雄市","屏東縣","台東縣","花蓮縣","宜蘭縣","基隆市","臺北市"," 新北市","桃園市","新竹縣","新竹市","苗栗縣","南投縣","連江縣","金門縣","澎湖縣"]
    
    var timeData = [String]()
    var pickerSelectLocation = "臺北市"
    let locationPickerView = UIPickerView(frame: CGRect(x: 0,y: 50, width: 280, height: 150))
    var wxTXT: String = ""
    var wxArr = [String]()
    var popArr = [String]()
    var minTArr = [String]()
    var cIArr = [String]()
    var maxTArr = [String]()

    var date : String = ""
    func getStrSysDate(withFormat strFormat: String) -> String {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = strFormat
            dateFormatter.locale = Locale.ReferenceType.system
            dateFormatter.timeZone = TimeZone.ReferenceType.system
            return dateFormatter.string(from: Date())
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationPickerView.delegate = self
        locationPickerView.dataSource = self
        date = getStrSysDate(withFormat: "yyyy-MM-dd")
//        print(date)
        loadWeatherAPI(locationName: pickerSelectLocation)
        loadSunriseSunsetApi(locationName: pickerSelectLocation, date: date)
        
    }
    
    @IBAction func changeLocationAndTime(_ sender: UIButton) {
        wxArr.removeAll()
        popArr.removeAll()
        minTArr.removeAll()
        maxTArr.removeAll()
        cIArr.removeAll()
        timeData.removeAll()
        showLocationView()
    }
    
    func loadWeatherAPI(locationName: String) {
        let url =  "https://opendata.cwb.gov.tw/api/v1/rest/datastore/F-C0032-001?Authorization=CWB-FCD3F473-1F08-455C-9FF0-11AE228B011E&format=JSON&locationName=\(locationName)"
        if let newUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            //        let newUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! // 解析中文
            if let URL = URL(string: newUrl) {
//                var request = URLRequest(url: URL(string: newUrl)!,timeoutInterval: Double.infinity)
                var request = URLRequest(url: URL,timeoutInterval: Double.infinity)
                request.httpMethod = "GET"
                let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
                    let decoder = JSONDecoder()
                    guard let data = data else {
                        print("error")
                        self.showErrorAlert(title: "錯誤訊息", message:"查無資料集")
                        return
                    }
                    do {
                        let weather = try decoder.decode(Weather.self, from: data)
                        //                print(weather)
                        
                        DispatchQueue.main.sync {
                            let location = weather.records.location[0]
                            let elements = location.weatherElement
                            var timeInterval = 0
                            for time in location.weatherElement[0].time {
                                self.timeData.append(time.startTime)
                                for element in elements {
                                    if let target = WeatherParameters(rawValue: element.elementName) {
                                        switch target {
                                        case .weatherPhenomenon:
                                            wxArr.append(element.time[timeInterval].parameter.parameterName)
                                            //                                    print(wxArr)
                                        case .chanceOfRain:
                                            popArr.append(element.time[timeInterval].parameter.parameterName + "%")
                                            //                                    print(popArr)
                                        case .minTemperature:
                                            minTArr.append(element.time[timeInterval].parameter.parameterName + "°" + element.time[timeInterval].parameter.parameterUnit!)
                                            //                                    print(minTArr)
                                        case .Comfort:
                                            cIArr.append(element.time[timeInterval].parameter.parameterName)
                                            //                                    print(cIArr)
                                        case .maxTemperature:
                                            maxTArr.append(element.time[timeInterval].parameter.parameterName + "°" + element.time[timeInterval].parameter.parameterUnit!)
                                            //                                    print(maxTArr)
                                        }
                                    }
                                }
                                //                        print(timeData)
                                self.showUI(index: timeInterval)
                                //                        print(timeInterval)
                                timeInterval += 1
                                //                        print(timeInterval)
                                //                        print(timeData)
                            }
                            self.selectButton.setTitle(location.locationName, for: .normal)
                        }
                    } catch {
                        self.showErrorAlert(title: "錯誤訊息", message: "Error decoding Weather object:\(error.localizedDescription)")
                    }
                }
                task.resume()
            }
        }
    }
    
    func showUI(index: Int) {
        switch index {
        case 0:
            wxTXT = wxArr[index]
//            print("wxTXT0:  \(wxTXT)")
            poPLabel.text = popArr[index]
//            print("poPLabel:  \(poPLabel.text ?? "o")")
            timeFirstLabel.text = timeFormatter(num: index)
            cILabel.text = cIArr[index]
            temperatureLabel.text = minTArr[index] + "～" + maxTArr[index]
            temperatureFirstLabel.text = minTArr[index] + "～" + maxTArr[index]
            self.selectIconImage(imageView: iconImage)
            self.selectIconImage(imageView: weatherIconFirstImage)
//            print(timeData)
        case 1:
            wxTXT = wxArr[index]
//            print("wxTXT1:  \(wxTXT)")
            timeSecondLabel.text = timeData[index]
//            print("timeSecondLabel:  \(timeSecondLabel.text ?? "1")")
            timeSecondLabel.text = timeFormatter(num: index)
            temperatureSecondLabel.text = minTArr[index] + "～" + maxTArr[index]
//            print("temperatureSecondLabel:  \(temperatureSecondLabel.text ?? "2")")
            self.selectIconImage(imageView: weatherIconSecondImage)
        case 2:
            wxTXT = wxArr[index]
//            print("wxTXT2:  \(wxTXT)")
            timeThirdLabel.text = timeData[index]
//            print("timeThirdLabel:  \(timeThirdLabel.text ?? "3")")
            timeThirdLabel.text = timeFormatter(num: index)
            temperatureThirdLabel.text = minTArr[index] + "～" + maxTArr[index]
//            print(temperatureThirdLabel.text ?? 4)
            self.selectIconImage(imageView: weatherIconThirdImage)
        default:
            print("error")
        }
    }

    func timeFormatter(num: Int) -> String {
        let timeString = timeData[num]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: timeString) {
            dateFormatter.dateFormat = "MM-dd HH:mm"
            let formattedDateString = dateFormatter.string(from: date)
//            print(formattedDateString)
            return formattedDateString
        }
        return ("time error")
    }
    
    func loadSunriseSunsetApi(locationName: String, date: String) {
        let SunUrl =  "https://opendata.cwb.gov.tw/api/v1/rest/datastore/A-B0062-001?Authorization=CWB-FCD3F473-1F08-455C-9FF0-11AE228B011E&format=JSON&CountyName=\(locationName)&Date=\(date)"
        if let newSunUrl = SunUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let URL = URL(string: newSunUrl) {
                var sunRequest = URLRequest(url: URL,timeoutInterval: Double.infinity)
                sunRequest.httpMethod = "GET"
                let task2 = URLSession.shared.dataTask(with: sunRequest) { [self] data, response, error in
                    let decoder = JSONDecoder()
                    guard let data = data else {
                        print("error")
                        self.showErrorAlert(title: "錯誤訊息", message:"查無資料集")
                        return
                    }
                    do {
                        let sun = try decoder.decode(Sun.self, from: data)
                        //                print(sun)
                        DispatchQueue.main.sync {
                            self.sunriseLabel.text = sun.records.locations.location[0].time[0].SunRiseTime
                            self.sunsetLabel.text = sun.records.locations.location[0].time[0].SunSetTime
                        }
                    } catch {
                        showErrorAlert(title: "錯誤訊息", message: "Error decoding Sun object:\(error.localizedDescription)")
                    }
                }
                task2.resume()
            }
        }
    }
            
    func selectIconImage (imageView: UIImageView) {
        if wxTXT.contains("雨") {
            if wxTXT.contains("晴") {
                imageView.image = UIImage(systemName: "cloud.sun.rain")
            } else if wxTXT.contains("雷") {
                imageView.image = UIImage(systemName: "cloud.bolt.rain")
            } else {
                imageView.image = UIImage(systemName: "cloud.heavyrain")
            }
            
        } else if wxTXT.contains("晴") {
            if wxTXT.contains("雲") {
                imageView.image = UIImage(systemName: "cloud.sun")
            } else {
                imageView.image = UIImage(systemName: "sun.max")
            }
        } else if wxTXT.contains("雪") {
            imageView.image = UIImage(systemName: "cloud.snow")
        } else {
            imageView.image = UIImage(systemName: "cloud")
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
        let okAction = UIAlertAction(title: "確認",style: .default, handler: { _ in
            self.loadWeatherAPI(locationName: self.pickerSelectLocation)
        })
        alertView.view.addSubview(locationPickerView)
        alertView.addAction(cancelAction)
        alertView.addAction(okAction)
        present(alertView, animated: true, completion: nil)
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == locationPickerView {
            return location.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == locationPickerView {
            return location[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == locationPickerView {
            pickerSelectLocation = location[row]
        }
    }
}


