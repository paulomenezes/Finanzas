//
//  ActionType.swift
//  Finanzas
//
//  Created by Paulo Menezes on 04/09/22.
//

import Foundation

enum ActionType: String, CaseIterable, Identifiable {
    case none
    case recurrent
    case installments
    
    var id: String { self.rawValue }
}
