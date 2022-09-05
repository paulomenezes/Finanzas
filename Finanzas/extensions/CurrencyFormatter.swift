//
//  CurrencyFormatter.swift
//  Finanzas
//
//  Created by Paulo Menezes on 04/09/22.
//

import Foundation
import CurrencyFormatter

extension CurrencyFormatter {
    static let `default`: CurrencyFormatter = {
        .init {
            $0.currency = .brazilianReal
            $0.locale = CurrencyLocale.portugueseBrazil
            $0.hasDecimals = true
            $0.minValue = 0
            $0.maxValue = 100000000
        }
    }()
}
