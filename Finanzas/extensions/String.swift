//
//  String.swift
//  Finanzas
//
//  Created by Paulo Menezes on 04/09/22.
//

import Foundation

extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Brazil/Recife")
        dateFormatter.locale = Locale(identifier: "pt-BR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        
        let date = dateFormatter.date(from: self)

        return date
    }
}
