//
//  ViewControllerExtension.swift
//  weather
//
//  Created by 薛博安 on 2023/5/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}
