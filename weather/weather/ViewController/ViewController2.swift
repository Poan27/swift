//
//  ViewController2.swift
//  weather
//
//  Created by 薛博安 on 2023/4/25.
//

import UIKit

class ViewController2: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: ViewController2Delegate?
    var citys: [City] = []
    
    @IBOutlet weak var cityTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.cityTableView.delegate = self
        self.cityTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let loveList  = UserDefaults.standard.stringArray(forKey: "123") {
            print(loveList)
            citys = loveList.map { name in
                let city = City()
                city.cityName = name
                return city
            }
            loading(locations: citys) { (isSuccess) in
                if isSuccess {
                    DispatchQueue.main.async {
                        self.cityTableView.reloadData()
                    }
                } else {
                    self.showErrorAlert(title: "Error", message: self.loadingError?.localizedDescription ?? "Api Error.")
                }
            }
        }
    }
    
    private var loadingError: Error? = nil
    func loading(locations: [City], isSuccess: @escaping (Bool) -> Void) {
        let group = DispatchGroup()
        for city in citys {
            group.enter()
            WeatherAPI.loadWeatherApi(locationName: city.cityName) { (weatherData) in
                guard let weatherData = weatherData else { return }
                var weatherParam = WeatherParam()
                for data in weatherData {
                    if let target = WeatherParameters(rawValue: data.elementName) {
                        switch target {
                        case .weatherPhenomenon:
                            weatherParam.wx = data.time[0].parameter.parameterName
                        case .minTemperature:
                            weatherParam.minT = data.time[0].parameter.parameterName + "°C"
                        case .Comfort:
                            weatherParam.ci = data.time[0].parameter.parameterName
                        case .maxTemperature:
                            weatherParam.maxT = data.time[0].parameter.parameterName + "°C"
                        default:
                            break
                        }
                    }
                }
                city.temperatureNumber = weatherParam.temp
                city.weatherImage = weatherParam.image
                city.comfortText = weatherParam.ci
                group.leave()
            } failedHandler: { error in
                print("失敗")
                group.leave()
            }
        }
        group.notify(queue: .main) { [ weak self ] in
            guard let self = self else { return }
            if self.loadingError != nil {
                isSuccess(false)
            } else {
                isSuccess(true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! LoveCitysTableViewCell
        cell.initCell(citys[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citys.count
        //        if tableView == self.cityTableView{
        //            return citys.count
        //        }else{
        //            return resultArray.count
        //        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! LoveCitysTableViewCell
        let location = cell.locationLabel.text ?? ""
        print("A : \(location)")
        delegate?.didSelectLocation(location)
        navigationController?.popViewController(animated: true)
    }
}
