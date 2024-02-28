//
//  ISODateFormatter.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 28.2.2024.
//

import Foundation

extension DateFormatter {
    
    static let iso8601Formatter: ISO8601DateFormatter = {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter
    }()
}
