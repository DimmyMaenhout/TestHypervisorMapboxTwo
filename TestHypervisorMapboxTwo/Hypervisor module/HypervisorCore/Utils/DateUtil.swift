//
//  DateUtil.swift
//  HypervisorCore
//
//  Created by Maarten Zonneveld on 05/02/2021.
//

import Foundation

public enum DateUtil {
        
    /// Date time formatter used for the date time objects.
    /// "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
