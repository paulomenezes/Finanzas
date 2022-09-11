//
//  Date.swift
//  Finanzas
//
//  Created by Paulo Menezes on 04/09/22.
//

import Foundation

extension Date {
    func toFormattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "pt-BR")
        
        return formatter.string(from: self)
    }
    
    func noon(using calendar: Calendar = .current) -> Date {
        calendar.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    func day(using calendar: Calendar = .current) -> Int {
        calendar.component(.day, from: self)
    }
    
    func adding(_ component: Calendar.Component, value: Int, using calendar: Calendar = .current) -> Date {
        calendar.date(byAdding: component, value: value, to: self)!
    }
    
    func monthSymbol(using calendar: Calendar = .current) -> String {
        calendar.monthSymbols[calendar.component(.month, from: self)-1]
    }
}
