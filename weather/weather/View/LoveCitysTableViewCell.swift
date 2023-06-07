//
//  TableViewCell.swift
//  weather
//
//  Created by 薛博安 on 2023/4/24.
//

import UIKit

class LoveCitysTableViewCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var iconName: UIImageView!
    @IBOutlet weak var temLabel: UILabel!
    @IBOutlet weak var comft: UILabel!

    func initCell(_ city: City) {
        locationLabel.text = city.cityName
        iconName.image = UIImage(systemName: "cloud.rain")
        temLabel.text = city.temperatureNumber
        comft.text = city.comfortText
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
