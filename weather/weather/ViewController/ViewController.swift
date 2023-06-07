//
//  ViewController.swift
//  weather
//
//  Created by 薛博安 on 2023/3/22.
//
// TODO: replace button

import UIKit

class ViewController: UIViewController, ViewController2Delegate {
    
    /// 天氣圖示
    @IBOutlet weak var iconImage: UIImageView!
    /// 地點選擇
    @IBOutlet weak var selectButton: UIButton!
    /// 溫度
    @IBOutlet weak var temperatureLabel: UILabel!
    /// 舒適度
    @IBOutlet weak var cILabel: UILabel!
    /// 降雨機率
    @IBOutlet weak var poPLabel: UILabel!
    /// 日出
    @IBOutlet weak var sunriseLabel: UILabel!
    /// 日落
    @IBOutlet weak var sunsetLabel: UILabel!

    /// scroll view No.1
    /// 時間
    @IBOutlet weak var timeFirstLabel: UILabel!
    /// 天氣圖示
    @IBOutlet weak var weatherIconFirstImage: UIImageView!
    /// 溫度
    @IBOutlet weak var temperatureFirstLabel: UILabel!
    
    /// scroll view No.2
    /// 時間
    @IBOutlet weak var timeSecondLabel: UILabel!
    /// 天氣圖示
    @IBOutlet weak var weatherIconSecondImage: UIImageView!
    /// 溫度
    @IBOutlet weak var temperatureSecondLabel: UILabel!
    
    /// scroll view No.3
    /// 時間
    @IBOutlet weak var timeThirdLabel: UILabel!
    /// 天氣圖示
    @IBOutlet weak var weatherIconThirdImage: UIImageView!
    /// 溫度
    @IBOutlet weak var temperatureThirdLabel: UILabel!
    
    /// 我的最愛（愛心）
    @IBOutlet weak var saveLoveCityButton: UIBarButtonItem!
    
    let location = ["臺中市","彰化縣","嘉義縣","嘉義市","雲林縣","臺南市","高雄市","屏東縣","臺東縣","花蓮縣","宜蘭縣","基隆市","臺北市","新北市","桃園市","新竹縣","新竹市","苗栗縣","南投縣","連江縣","金門縣","澎湖縣"]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationPickerView.delegate = self
        locationPickerView.dataSource = self
//        UserDefaults.standard.removeObject(forKey: "123")
    }
    /// 回到第一頁重新reload
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        date = getStrSysDate(withFormat: "yyyy-MM-dd")
        loadData(location: pickerSelectLocation)
        //TODO: seperate success failed
        SunriseSunsetAPI.loadSunriseSunsetApi(locationName: pickerSelectLocation, date: date) { day in
            guard let day = day else { return }
            self.sunriseLabel.text = day.first?.SunRiseTime
            self.sunsetLabel.text = day.first?.SunSetTime
        } failedHander: { error in
            self.showErrorAlert(title: "error", message: "api failed: \(error.localizedDescription)")
        }
        if let loveList = UserDefaults.standard.stringArray(forKey: "123") {
            if loveList.contains(pickerSelectLocation) {
                saveLoveCityButton.image = loveImage
            } else {
                saveLoveCityButton.image = unloveImage
            }
                
        }

    }
    
    @IBAction func showFavoriteList(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc2 = sb.instantiateViewController(withIdentifier: "vc2") as! ViewController2
        vc2.delegate = self
        navigationController?.pushViewController(vc2, animated: true)
    }
    
    @IBAction func changeLocationAndTime(_ sender: UIButton) {
        removeAllList()
        showLocationView()
    }
    /// 轉換日期格式
    /// - Parameter strFormat: API取回資料
    /// - Returns: 回傳自定義格式
    func getStrSysDate(withFormat strFormat: String) -> String {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = strFormat
            dateFormatter.locale = Locale.ReferenceType.system
            dateFormatter.timeZone = TimeZone.ReferenceType.system
            return dateFormatter.string(from: Date())
        }
    
    func didSelectLocation(_ location: String) {
        print("Selected location: \(location)")
        removeAllList()
        pickerSelectLocation = location
        loadData(location: pickerSelectLocation)
//        self.selectButton.setTitle(location, for: .normal)
    }
    // MARK: - API串接
    /// Call Weather API
    /// - Parameter loacation: 城市名
    func loadData(location: String) {
        WeatherAPI.loadWeatherApi(locationName: location) { elements in
            guard let elements = elements else { return }
            var timeInterval = 0
            for time in elements[0].time {
                self.timeData.append(time.startTime)
                for element in elements {
                    if let target = WeatherParameters(rawValue: element.elementName) {
                        switch target {
                        case .weatherPhenomenon:
                            self.wxArr.append(element.time[timeInterval].parameter.parameterName)
                        case .chanceOfRain:
                            self.popArr.append(element.time[timeInterval].parameter.parameterName + "%")
                        case .minTemperature:
                            self.minTArr.append(element.time[timeInterval].parameter.parameterName + "°" + element.time[timeInterval].parameter.parameterUnit!)
                        case .Comfort:
                            self.cIArr.append(element.time[timeInterval].parameter.parameterName)
                        case .maxTemperature:
                            self.maxTArr.append(element.time[timeInterval].parameter.parameterName + "°" + element.time[timeInterval].parameter.parameterUnit!)
                        }
                    }
                }
                self.showUI(index: timeInterval)
                timeInterval += 1
            }
            self.selectButton.setTitle(self.pickerSelectLocation, for: .normal)
        } failedHandler: { error in
            self.showErrorAlert(title: "error", message: "api failed: \(error.localizedDescription)")
        }
    }
    
    func removeAllList() {
        wxArr.removeAll()
        popArr.removeAll()
        minTArr.removeAll()
        maxTArr.removeAll()
        cIArr.removeAll()
        timeData.removeAll()
    }
    
    // MARK: - 我的最愛功能
    var loveList: [String] = []
    
    var loveImage: UIImage {
        return UIImage(systemName: "heart.fill")!
    }
    
    var unloveImage: UIImage {
        return UIImage(systemName: "heart")!
    }
    
    @IBAction func changeLove(_ sender: UIBarButtonItem) {
        if loveList.contains(pickerSelectLocation) {
            loveList.removeAll{ $0 == pickerSelectLocation }
            saveLoveCityButton.image = unloveImage
            UserDefaults.standard.set(loveList, forKey: "123")
        } else {
            loveList.append(pickerSelectLocation)
            saveLoveCityButton.image = loveImage
            UserDefaults.standard.set(loveList, forKey: "123")
        }
    }
  // MARK: -顯示畫面
    func showUI(index: Int) {
        switch index {
        case 0:
            wxTXT = wxArr[index]
            poPLabel.text = popArr[index]
            timeFirstLabel.text = timeData[index].monthDayHour()
            cILabel.text = cIArr[index]
            temperatureLabel.text = minTArr[index] + "～" + maxTArr[index]
            temperatureFirstLabel.text = minTArr[index] + "～" + maxTArr[index]
            self.selectIconImage(imageView: iconImage)
            self.selectIconImage(imageView: weatherIconFirstImage)
        case 1:
            wxTXT = wxArr[index]
            timeSecondLabel.text = timeData[index].monthDayHour()
            temperatureSecondLabel.text = minTArr[index] + "～" + maxTArr[index]
            self.selectIconImage(imageView: weatherIconSecondImage)
        case 2:
            wxTXT = wxArr[index]
            timeThirdLabel.text = timeData[index].monthDayHour()
            temperatureThirdLabel.text = minTArr[index] + "～" + maxTArr[index]
            self.selectIconImage(imageView: weatherIconThirdImage)
        default:
            print("error")
        }
        ///  每次更新畫面重新判斷城市 是否是最愛
        if let loveList = UserDefaults.standard.stringArray(forKey: "123") {
            if loveList.contains(self.pickerSelectLocation) {
                saveLoveCityButton.image = loveImage
            } else {
                saveLoveCityButton.image = unloveImage
            }
        }
    }
    
    /// 判斷天氣，顯示符合天氣圖片
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

    func showLocationView() {
        let alertView = UIAlertController(title: "選擇地點", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消",style: .cancel,handler: nil)
        let okAction = UIAlertAction(title: "確認",style: .default, handler: { _ in
            self.loadData(location: self.pickerSelectLocation)
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


