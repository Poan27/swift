//
//  StringExtension.swift
//  weather
//
//  Created by 薛博安 on 2023/5/22.
//

import Foundation

extension String {
    
    ///
    func removeSpace() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    /// 將 yyyy-MM-dd HH:mm:ss 時間格式化
    /// - Returns:字串 MM-dd HH:mm
    func monthDayHour() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "MM-dd HH:mm"
            let formattedDateString = dateFormatter.string(from: date)
            return formattedDateString
        }
        return ("time error")
    }
}

